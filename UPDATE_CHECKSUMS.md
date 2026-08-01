# Homebrew Formula Checksum Updater

`update-checksums.sh` updates the SHA256 checksums in any formula in this tap.
It works for every formula under `Formula/` that downloads GitHub Release
tarballs named `<formula>-<version>-<triple>.tar.gz`.

## Usage

```bash
# update zukan using the version already in Formula/zukan.rb
./update-checksums.sh zukan

# update rgrc for an explicit version
./update-checksums.sh rgrc 0.6.14
```

The first argument is the formula basename (without `.rb`). The optional second
argument is the version; when omitted it is read from the formula's `version`
line. The GitHub repo is taken from the formula's `homepage`, and only the
target triples actually present in the formula are updated.

## What it does

1. Reads the formula file and resolves the version (argument or formula).
2. Reads the repo from the formula `homepage`.
3. Downloads every `<formula>-<version>-<triple>.tar.gz` the formula references.
4. Writes the new SHA256 next to each matching `url`.
5. Verifies each checksum landed, then prints a `git diff` hint.

## Prerequisites

- `curl`, `shasum` (macOS) or `sha256sum` (Linux), and network access to GitHub.

## Workflow

After tagging and publishing a release:

```bash
./update-checksums.sh zukan 0.3.1
git diff Formula/zukan.rb
git add Formula/zukan.rb
git commit -m "zukan: v0.3.1"
git push
```

Use `git restore Formula/<name>.rb` to revert if the update looks wrong.
