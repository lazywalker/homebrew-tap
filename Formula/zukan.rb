class Zukan < Formula
  desc "Monster Hunter bestiary in your terminal"
  homepage "https://github.com/lazywalker/zukan"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/lazywalker/zukan/releases/download/v#{version}/zukan-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "72ba2faf5bf0f283b4b437dd0fc11ef8d67af79dd0c3a84709caf95739a87532"
    end
    on_intel do
      url "https://github.com/lazywalker/zukan/releases/download/v#{version}/zukan-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "cf7c5e539723de01c0f6be8c5126a51fc88755580fb34c9e5a3d17c539932a22"
    end
  end

  # Linux uses musl static builds so one binary runs on any glibc or musl distro.
  on_linux do
    on_arm do
      url "https://github.com/lazywalker/zukan/releases/download/v#{version}/zukan-#{version}-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8070bb86f56a0f43bbb9a1ef08b86ab66a16d9ac70b9d9e021526dc9587f31ca"
    end
    on_intel do
      url "https://github.com/lazywalker/zukan/releases/download/v#{version}/zukan-#{version}-x86_64-unknown-linux-musl.tar.gz"
      sha256 "01c3dae0ce84f69df10af4c4ae656c82bc2e8671ab4360c5458cead9220d000d"
    end
  end

  def install
    bin.install "zukan"
  end

  test do
    assert_match "zukan #{version}", shell_output("#{bin}/zukan --version")
  end
end
