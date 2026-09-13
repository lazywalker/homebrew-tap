class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.34"
  license "MIT"

  # rgrc release assets currently omit the version in the filename
  # (rgrc-<triple>.tar.gz). The update-checksums.sh script tries the
  # versioned name first and falls back to this form. rgrc may ship
  # versioned assets in a future release, which will need no formula change.
  on_macos do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
      sha256 "f96b0f36eb9a117b15bfc826ee6209f0dfc381309eb9b58d50690f2facc6440f"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
      sha256 "ae1825a7dfca148033548483cb5870f514b1b4feba90f25babf5331c32eda564"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-unknown-linux-musl.tar.gz"
      sha256 "b7fc894993487b633d9743ed6ce7a0c205ad7849af4f38438baaf80ab207692f"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "03a49fc3cf1a0f069300dba7f2a48f801734beb25ac0156843a62fdbf2f54bdb"
    end
  end

  def install
    bin.install "rgrc"
    generate_completions_from_executable(bin/"rgrc", "--completions")
  end

  def caveats
    <<~EOS
      To enable rgrc aliases, add the following to your ~/.bashrc or ~/.zshrc:

        eval $(rgrc --aliases)
    EOS
  end

  test do
    assert_match "rgrc #{version}", shell_output("#{bin}/rgrc --version")
  end
end
