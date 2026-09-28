class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.35"
  license "MIT"

  # rgrc release assets currently omit the version in the filename
  # (rgrc-<triple>.tar.gz). The update-checksums.sh script tries the
  # versioned name first and falls back to this form. rgrc may ship
  # versioned assets in a future release, which will need no formula change.
  on_macos do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
      sha256 "7314714a56d407d2e91de787a793d2dcda26e0d386f261c5b4035a6152a12d61"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
      sha256 "defd1fc6f539c53d9c794dcd8b30fc811badfea6dd9e97aa34e67204ca2c2aba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-unknown-linux-musl.tar.gz"
      sha256 "f096715db46a56fef0f719d5ac125b638586ba22db37898d36ab2b9d7a5f7424"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8c2a5d0cd6e37d37d845db6c50d1f0a5b505503833a72916ffb038d5136c2944"
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
