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
which hands a secret to the tasks that need it. Each repository's own documentation gives the
step-by-step commands; this page states what holds and why.

## Where a secret lives

Each repository that needs a secret commits its own root `fnox.toml`, with the age ciphertext of
every value inline. No central store repository holds the values, and no global or parent file
supplies them. A private store would hide the reference from the strangers it serves, and an
untracked parent file has no history and no backup. A repository's file encrypts to named
recipients: only the devices that run that repository's secret-using tasks, plus an offline
backup.

## How a secret describes itself

Every secret carries a description saying what it is, what reads it, and how to generate one's
own, and a link to the page that issues it wherever one does. A reader lists them without a key.

Each repository's check guards the file without a key. It refuses a secret with no description,
a value that is not ciphertext, a tracked age secret key, and a local override file that git does
not ignore.

## Keys and the backup

Each device has its own age key, generated on that device, held as a plain file readable only by
its owner, and never copied off it. The key never enters a dotfiles repository or any other
repository. It is a key of its own rather than the device's SSH key, so secret access and SSH access
rotate apart.

One more recipient is a backup identity, protected by a passphrase and held offline. It decrypts
every value on its own, so losing every device loses nothing.

## How a task receives a secret

A secret reaches only the task that is granted it, and mise redacts the value from that task's
output. Without an identity that decrypts it, the task runs as it would without the secret, and a
value the caller exports itself still works. A contributor without a key loses only the tasks that
need the value, and the check never needs one.

## Adding a device, rotating, and restoring

A new device generates its own key, and its public key joins the file's recipients under the
device's name. A device that already decrypts re-encrypts every value to the new list, commits the
file, and the new device pulls it. The key never travels; only its public half does.

Removing a recipient does not revoke it. The old ciphertext is public and stays in git history,
and the removed key still decrypts it. Only rotating the value at the source that issues it
revokes access.

Restoring after losing every device needs only the backup identity: it decrypts every value, and
the values are re-encrypted to the new devices.

## A stranger's own values

A stranger supplies their own values in a gitignored local file, encrypted to their own key, that
overrides the committed one. They name that file explicitly when setting a value, since a plain
set rewrites the committed file. In a fork, they replace the committed file's recipients and values
with their own.

## What is not a secret

A credential published for development, such as a local storage emulator's well-known key or a
database container's default password, is not a secret. It stays committed in plain text where
the tooling expects it, since encrypting a published value protects nothing and costs the reader
the reference.
