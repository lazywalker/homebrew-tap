class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.30"
  license "MIT"

  # rgrc release assets currently omit the version in the filename
  # (rgrc-<triple>.tar.gz). The update-checksums.sh script tries the
  # versioned name first and falls back to this form. rgrc may ship
  # versioned assets in a future release, which will need no formula change.
  on_macos do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
      sha256 "61fec3a9f596813121e25ca25f5c5c2510ac10b987e27777aea486b6d3d14bf1"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
      sha256 "8d26bf2ea06397b04efada00318e1be7f6ff44428ba967a4412480411446bf8b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-unknown-linux-musl.tar.gz"
      sha256 "208a8a872d931961435af2e11752deccc221107aa2239a29057d6864a047899a"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8354c7ed836a54a31a5bed9e3e23def62eee3063e492539cf3a42b8fbe9a0e4f"
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
