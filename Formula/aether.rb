class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.10.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.10.1/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "9bfae0f89b494899a3defa5aab691ef0625cca15ffe4e7f5634c8f7ce6ec5eb5"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.10.1/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "544956e22906c08e16907b221eb78cd44116610a2e1cf24b521441d6783e44d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.10.1/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9d9969fb38d0f2e0c2d045d38f27a7c2cdf05c09c692494396e776647bd251a"
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
