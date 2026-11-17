class Outskirts < Formula
  desc "Finds unused code in Swift projects (community-maintained fork of Periphery)"
  homepage "https://github.com/tiny-earth-moon/outskirts"
  url "https://github.com/tiny-earth-moon/outskirts/archive/refs/tags/3.26.0.tar.gz"
  sha256 "dd34b921f73f7bf97c4f57f03d487c70bf834d7146f8f87d6e3f284d4d12b826"
  license "MIT"
  head "https://github.com/tiny-earth-moon/outskirts.git", branch: "master"

  bottle do
    root_url "https://github.com/tiny-earth-moon/outskirts/releases/download/3.26.0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71ac008a84663ddad13637adbb4e044ab19d06db29bba4e3c15179ff1ac1e69b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "379e2a891fff24790e0885e56831520db5f3ed344f6129d65d819ed620f8b74a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86d61bf6619e8bad211e68e1c8c1300edcb13685b07ca7826538bbf253fce40d"
  end

  depends_on :macos
  depends_on xcode: "26.0"

  conflicts_with "periphery", because: "both install a `periphery` binary"
  conflicts_with "periphery-pro/tap/periphery-cli", because: "both install a `periphery` binary"

  def install
    args = %w[--disable-sandbox -c release --product outskirts]
    # outskirts links @rpath/libIndexStore.dylib and swift-index-store only adds the building
    # Xcode to the rpath, e.g. /Applications/Xcode_27.2.app on a CI runner. A bottle must find
    # the library on the user's machine: the default Xcode location first, then the Command Line
    # Tools, which homebrew-core's periphery formula also relies on.
    if build.bottle?
      args += %w[-Xlinker -rpath -Xlinker
                 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib
                 -Xlinker -rpath -Xlinker /Library/Developer/CommandLineTools/usr/lib]
    end
    system "swift", "build", *args
    bin.install ".build/release/outskirts"
    bin.install_symlink "outskirts" => "periphery"
    generate_completions_from_executable(bin/"outskirts", "--generate-completion-script")
  end

  def caveats
    <<~EOS
      The bottle loads libIndexStore.dylib from /Applications/Xcode.app, or else from the
      Command Line Tools. If neither is installed there, build from source instead:
        brew reinstall --build-from-source outskirts
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/outskirts version")
    assert_match version.to_s, shell_output("#{bin}/periphery version")
  end
end
