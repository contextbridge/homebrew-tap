class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.9.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.5/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "46217dccb83ab045f1a0e2f4fb6cd8caf4bca0b174917192f80ce2813bc84efa"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.5/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61ee5e81b313c2bbfc5ecc9d1faf422c12b16be3994a6ef6b8795601f27d2b9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.5/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e80891d82e5899953fe406c0f86ea23fc7b806f6276e849b44639938823a801"
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
