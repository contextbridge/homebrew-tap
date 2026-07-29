class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.7.33"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.33/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "fc732e23fa30db653f14e62a3043da8a4d39a2bb35593612de2f8cbcee0a8c96"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.33/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d1410e5bd3bded038dc2024c9ec6396539057f3c8faa4e54f09a6ab7d90288e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.33/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2410d53f73190e859513b08a67a00fbb62afe3123fc9a0e3fd67a3af9b8e77c0"
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
    bin.install "aether" if OS.mac? && Hardware::CPU.arm?
    bin.install "aether" if OS.linux? && Hardware::CPU.arm?
    bin.install "aether" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
