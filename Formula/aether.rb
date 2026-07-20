class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.7.26"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.26/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "f927e65f9dec81d8c8ec6e54ea92ed64da1a2057d54d8fbde53221404154ff3d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.26/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3dc1c5604f44bab5c8a40ada38c8b1f8529cf9f7458691351cc0dcdefd3bc103"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.26/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ec1de9b814c642e28d32f2bec2473740864f3e3fc6496676d9b4f7483ba7036"
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
