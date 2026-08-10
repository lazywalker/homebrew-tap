class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.20"
  license "MIT"

  # rgrc release assets currently omit the version in the filename
  # (rgrc-<triple>.tar.gz). The update-checksums.sh script tries the
  # versioned name first and falls back to this form. rgrc may ship
  # versioned assets in a future release, which will need no formula change.
  on_macos do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
      sha256 "877a53b9ab5796c7bbd0b27ae83cdac1ae888c7b2a71e65ed0766190f46dddcc"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
      sha256 "54a50cea3d9d290d7d07e2b826ba412d63d6ffe0818fa92da8205ce75ad9894b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-unknown-linux-musl.tar.gz"
      sha256 "77c408966014094a2ba0e31cf24b9e3f46e4b06d944aa305ebe24945a98d0b34"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d6bdcc0eb08edb30581c216e07f8d327427f1b8774dd70470f5c4e6989ed3361"
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
