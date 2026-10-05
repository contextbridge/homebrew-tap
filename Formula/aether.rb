class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.9.13"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.13/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "60d7e6dce49733163adf2b6282fd562b7c9d1a3cc23be061f311555fd90912b7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.13/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2599a4bf04160e5676f67583875a7239fbc5c72dad539c40d572bc15ad1a776f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.9.13/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13771fb723265593437f66440ecbeef293b73b7e07ba2dd8e8b7c6fcdde40185"
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
