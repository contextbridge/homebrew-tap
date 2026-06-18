class Aether < Formula
  desc "CLI and ACP server for the Aether AI coding agent"
  homepage "https://github.com/contextbridge/aether"
  version "0.7.16"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.16/aether-agent-cli-aarch64-apple-darwin.tar.xz"
    sha256 "7f11782c69edb9f8cbe788f6a236caff5fecbafb465551878ba3009f145cc9d8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.16/aether-agent-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2855f0a59f6600b068bcd3969cf4c7b82bd172351c42684d0a64ef55d2df55d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/contextbridge/aether/releases/download/aether-agent-cli-v0.7.16/aether-agent-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef1d69504d284497ea8f2b0fdec840fbea3fda36a102b57f0f64e434371f11d3"
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
