# lazywalker/homebrew-tap

Personal Homebrew tap for small command-line tools.

## Usage

```bash
brew tap lazywalker/tap
brew install rgrc
brew install zukan
```

`brew tap` clones this repo; the formulae live in `Formula/`.

## Formulae

| Formula | Description | Source |
|---------|-------------|--------|
| `rgrc`  | Rusty Generic Colouriser, like `grc` but fast | [lazywalker/rgrc](https://github.com/lazywalker/rgrc) |
| `zukan` | Monster Hunter bestiary in your terminal | [lazywalker/zukan](https://github.com/lazywalker/zukan) |

## Maintaining

Each formula installs a prebuilt release tarball, so the SHA256 values must be
refreshed on every new upstream release. See [UPDATE_CHECKSUMS.md](UPDATE_CHECKSUMS.md)
for the `update-checksums.sh` workflow.
