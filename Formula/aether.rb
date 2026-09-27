class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.9.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.8/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "1db2d6aa1d146d6a61bc0cf3621d13f4bb3ee88c82f22cf22caae255c747fa74"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.8/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4b9fb336312dfba6e38a7a03e4e75073508302d3cc8d4a9c8d8be790a0265364"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.8/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3c2c8f1b7a8a0090094cfde9ecf563f51e9083668a8fdb3a64c41940c5c772dd"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "aether"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "aether"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "aether"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
