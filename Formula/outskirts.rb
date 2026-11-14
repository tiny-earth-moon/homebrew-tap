class Outskirts < Formula
  desc "Finds unused code in Swift projects (community-maintained fork of Periphery)"
  homepage "https://github.com/tiny-earth-moon/outskirts"
  url "https://github.com/tiny-earth-moon/outskirts/archive/refs/tags/3.24.1.tar.gz"
  sha256 "822fa8dbc110941cf68e25f71301b65004b5c8b1e2d1251a987f86c5e30944e4"
  license "MIT"
  head "https://github.com/tiny-earth-moon/outskirts.git", branch: "master"

  bottle do
    root_url "https://github.com/tiny-earth-moon/outskirts/releases/download/3.24.1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c53d626ecd19741c4ec8fda3fbeaa9509a207affc31e700a9925372474feba0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "45666615bca9bd6b2523a0c4951c56122e25f7102f342b12360aff5624699ffa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf88255b49900ef664a6dbab4fbcb997d47c518c611a59da2c4de4cc747e15fc"
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
