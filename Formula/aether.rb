class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.7.15"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.15/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "0eeb65a7da8360c1358e0b2e83ce37ea9314ff34b0aa8363ba55e57a7c8d8fac"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.15/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2ccb8bbcd2bd1bd6fffc580ce194975a585b77406c12549405179519c4f9f7e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.15/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af1a99aec8a7a6e56f335265fb53179d83fbc09751b4cfb68132e52e1b0b532c"
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
    bin.install "aether", "aether-schemas" if OS.mac? && Hardware::CPU.arm?
    bin.install "aether", "aether-schemas" if OS.linux? && Hardware::CPU.arm?
    bin.install "aether", "aether-schemas" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
