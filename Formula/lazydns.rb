class Lazydns < Formula
  desc "A DNS server/forwarder implementation in Rust, inspired by mosdns"
  homepage "https://github.com/lazywalker/lazydns"
  version "0.3.20"
  license "GPL-3.0-or-later"

  on_arm do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-apple-darwin.tar.gz"
    sha256 "249472e9f51f43abfa4c80108e0cd7745a2cffc3424c499cad783a4ce71b8cea"
  end

  on_intel do
    url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-apple-darwin.tar.gz"
    sha256 "570a6676270443c56d19a6774256f7a3474ddf64850eb23c91fea143319b05b3"
  end

  on_linux do
    on_intel do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "24d73869fa9725bc432dcddf07ae5f8860edb36cb26dd5e1153165ebbc04ac0d"
    end
    on_arm do
      url "https://github.com/lazywalker/lazydns/releases/download/v#{version}/lazydns-full-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5459b09100e5c5f7747c5721beb023fc72a4c37cfb01ec79d72f9403e3e2f1f0"
    end
  end

  def install
    bin.install "lazydns"
    pkgshare.install "config.yaml"
  end

  def post_install
    (etc/"lazydns").mkpath
    config_file = etc/"lazydns/config.yaml"
    unless config_file.exist?
      cp pkgshare/"config.yaml", config_file
    end
  end

  service do
    run [opt_bin/"lazydns", "-c", etc/"lazydns/config.yaml"]
    keep_alive true
    require_root true
  end

  def caveats
    <<~EOS
      A default configuration file has been installed to:
        #{etc}/lazydns/config.yaml

      You can edit this file to customize your settings.
      Then, start the service with:
        brew services start lazydns

    EOS
  end

  test do
    assert_match "lazydns #{version}", shell_output("#{bin}/lazydns --version")
  end
end
