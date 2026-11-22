---
key: development-secrets
name: Development-time secrets
type: principle
level: architecture
---

# Development-time secrets

A repository that needs a secret at development time, such as an API key its integration tests
present, commits that secret encrypted, beside the code that reads it. The repositories are
public references: a stranger who reads one sees every secret it uses, what each is for, and how
to obtain their own, without being able to read the values. Each secret explains itself, so the
reference stays complete even though the values stay private.

The convention is built on [fnox](https://fnox.jdx.dev), which keeps secrets in a TOML file and
encrypts each value with [age](https://age-encryption.org), and on [mise](https://mise.jdx.dev),
which hands a secret to the tasks that need it. This page is the one home for the convention and
every step of it. A repository that holds secrets documents only its own: which secrets it holds,
which tasks are granted them, and its recipients.

## Where a secret lives

Each repository that needs a secret commits its own root `fnox.toml`, with the age ciphertext of
every value inline. No central store repository holds the values, and no global or parent file
supplies them. A private store would hide the reference from the strangers it serves, and an
untracked parent file has no history and no backup. A repository's file encrypts to named
recipients: only the devices that run that repository's secret-using tasks, plus an offline
backup.

## How a secret describes itself

Every secret carries a description saying what it is, what reads it, and how to generate one's
own, and a link to the page that issues it wherever one does. A reader lists them without a key,
with `mise secrets ls`.

## Keys and the backup

Each device has its own age key, generated on that device, held as a plain file, never a
symbolic link, readable only by its owner, and never copied off it. The key never enters a
dotfiles repository or any other repository, and no repository links it. It is a key of its own
rather than the device's SSH key, so secret access and SSH access rotate apart. Only a key's public
half ever travels.

One more recipient is a backup identity, protected by a passphrase and held offline. It decrypts
every value on its own, so losing every device loses nothing.

## How a task receives a secret

A secret reaches only the task that is granted it, and mise redacts the value from that task's
output. Without an identity that decrypts it, fnox warns and leaves the variable unset, so the
task runs as it would without the secret, and a value the caller exports itself still works. A
contributor without a key loses only the tasks that need the value, and the check never needs one.

## What is not a secret

A credential published for development, such as a local storage emulator's well-known key or a
database container's default password, is not a secret. It stays committed in plain text where
the tooling expects it, since encrypting a published value protects nothing and costs the reader
the reference.

## Adding secrets to a repository

The repository's root `fnox.toml` stops fnox's search for parent files, declares the age
provider and its named recipients, and holds each secret with its description and issuing page:

```toml
root = true

[providers.age]
type = "age"

[providers.age.recipients]
<device> = "age1..."
backup = "age1..."

[secrets]
EXAMPLE_TOKEN = { provider = "age", value = "...", description = "What it is, what reads it, and how to generate your own.", url = "https://issuer.example/tokens" }
```

Write each value through fnox, which encrypts it. With no value argument, fnox reads it from a
hidden prompt or from stdin, so it never lands in a command line or a shell history; `-d` records
the description:

```sh
fnox -c ./fnox.toml set EXAMPLE_TOKEN -d "What it is, what reads it, and how to generate your own."
```

`mise.toml` holds mise to a release that supports task secrets, enables them, pins the tools, and
grants each secret to the tasks that read it:

```toml
min_version = "<version>"

[settings]
experimental = true

[tools]
"aqua:FiloSottile/age" = "<version>"
fnox = "<version>"
jq = "<version>"
yq = "<version>"

[secrets.fnox]

[tasks.integration]
secrets = ["EXAMPLE_TOKEN"]
run = "..."
```

`[secrets.fnox]` makes fnox mise's secret source, and a task's `secrets` list is its grant. When
a secret stands in for a per-role variable a caller may set, such as one token per endpoint, the
task's script copies the granted value only into each role's variable that is still unset, so a
value the caller exports for a role takes precedence over the committed one.

`.gitignore` lists the local override files:

```gitignore
fnox.local.toml
.fnox.local.toml
```

The repository's check runs a `lint-secrets` script, which reads the file without a key and
refuses:

- a secret with no description, which leaves the reference incomplete;
- an age-provider value that isn't age ciphertext, a plaintext value set by hand, which is
  rotated if it was ever committed;
- a tracked file that holds an age secret key, which exposes that identity;
- a local override file that git doesn't ignore, or that is tracked, since it holds one
  machine's own values.

It needs git, jq, and the pinned yq, and no key, so CI runs it.

## Setting up a device's key

On the device, in a repository that pins age, generate the key with the pinned `age-keygen` into
a directory only its owner can open, and print its public key:

```sh
mkdir -p -m 700 ~/.config/fnox
(umask 077; mise exec -- age-keygen -o ~/.config/fnox/age.txt)
mise exec -- age-keygen -y ~/.config/fnox/age.txt
```

fnox reads `$XDG_CONFIG_HOME/fnox/age.txt` by default, which is `~/.config/fnox/age.txt`
unless `XDG_CONFIG_HOME` is set elsewhere. `stat -c '%a %F' ~/.config/fnox
~/.config/fnox/age.txt` confirms `700 directory` and `600 regular file`.

## Creating the offline backup identity

Generate the backup identity straight into a passphrase-protected file, so its secret half never
reaches the disk in the clear:

```sh
mise exec -- age-keygen 2> backup.pub | mise exec -- age -p -a > backup.age
```

`backup.pub` holds the public key after `Public key: `; that key, committed as the `backup`
recipient, is the only part committed. Keep `backup.age` out of every repository, in more than
one offline place, and its passphrase apart from it.

## Adding a device

1. On the new device, clone the repository, run `mise trust` and `mise install` there, then set
   up the device's key.
2. On a device that already decrypts, add the new public key under `[providers.age.recipients]`
   with the device's short name, re-encrypt every value to the new list, and run the check:

   ```sh
   fnox -c ./fnox.toml reencrypt -p age --force
   mise run check
   ```

3. Commit `fnox.toml` and pull it on the new device, where
   `fnox -c ./fnox.toml get EXAMPLE_TOKEN | wc -c` confirms it decrypts without printing the
   value.

## Rotating a value, and removing a device

Removing a recipient doesn't revoke it. The old ciphertext is public and stays in git history,
and the removed key still decrypts it. To remove a device, delete its recipient and re-encrypt as
when adding one, then rotate every value it could read: issue a new value at the source that
issues it, revoke the old one there, and set the new one with `fnox -c ./fnox.toml set`.

## Restoring from the backup

With every device lost, decrypt the backup identity into a directory only its owner can open, and
point fnox at it:

```sh
T=$(mktemp -d); chmod 700 "$T"
mise exec -- age -d -o "$T/age.txt" backup.age
FNOX_CONFIG_DIR="$T" fnox -c ./fnox.toml get EXAMPLE_TOKEN | wc -c
```

With `FNOX_CONFIG_DIR` still set, add the new devices' recipients and re-encrypt as when adding a
device. Then destroy the decrypted identity:

```sh
shred -u "$T/age.txt"; rmdir "$T"
```

## Supplying your own values

A stranger, or a machine that isn't a recipient, supplies its own values in the gitignored
`fnox.local.toml`, which overrides `fnox.toml`. Set up your own key as in [Setting up a device's
key](#setting-up-a-devices-key), give the file an age provider whose only recipient is your public
key, then write each value to it by name:

```sh
fnox -c ./fnox.local.toml set EXAMPLE_TOKEN
```

A plain `fnox set` writes to the committed `fnox.toml`, so name the local file with `-c` unless
you mean to change the committed one. In a fork, replace the committed file's recipients with your
own instead, and set each value again.
