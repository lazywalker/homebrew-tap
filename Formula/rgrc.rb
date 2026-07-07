class Rgrc < Formula
  desc "Rusty Generic Colouriser - just like grc but fast"
  homepage "https://github.com/lazywalker/rgrc"
  version "0.6.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-apple-darwin.tar.gz"
      sha256 "6e3f8220ba14a37e5b5163bae39846a0666768d13b4a52476466fd8083284b21"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-apple-darwin.tar.gz"
      sha256 "aef0f797ddc2d8515955351b5ec709e7a073fafb59de986bebf1d0109ebfde85"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-aarch64-unknown-linux-musl.tar.gz"
      sha256 "0e12545384c3c76396ff2afb42a53c15ef244a994fad7b271a016b56a9a0e499"
    end

    on_intel do
      url "https://github.com/lazywalker/rgrc/releases/download/v#{version}/rgrc-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3256f69256a63fdb8b2084a879ba60bbbdafd530e69c68360530197f5b065e76"
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
