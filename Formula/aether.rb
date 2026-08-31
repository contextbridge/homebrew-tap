class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.7.40"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.40/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "a3e675ee4e73763b7613d05eac69c2d04df69b4603fc4a76d8c736bbe15abb6c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.40/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5526e8cd32a2329d391a34440c126583ae9853cfc628d92d5305a6f084d10a11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.40/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f9b9c71efe160dee5dad2016c78524f24f308d7a163c6a058218bd6254b29e21"
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
