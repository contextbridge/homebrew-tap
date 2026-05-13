class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.6.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.6.2/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "24a11ce5f353d9c814fbd0cbb22c4265c6e921bc937a0b6cac256eccdc493065"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.6.2/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8b35c311fdc300ce104a13a84661f05b5a5481654d536d141fd6d9de2eccea9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.6.2/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b80c0ec7c685524e32a75ede73c221a9ab284c1eb4ca41869b168ca1502395d4"
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
