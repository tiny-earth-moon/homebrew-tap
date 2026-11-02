class Periphery < Formula
  desc "Unused code detector for Swift (maintained fork of peripheryapp/periphery)"
  homepage "https://github.com/tiny-earth-moon/periphery"
  url "https://github.com/tiny-earth-moon/periphery/archive/refs/tags/3.13.1.tar.gz"
  sha256 "2ba6156538014f0208a35906efc0b3605a74c2c6b20333580514a2cfc4732949"
  license "MIT"
  head "https://github.com/tiny-earth-moon/periphery.git", branch: "master"

  bottle do
    root_url "https://github.com/tiny-earth-moon/periphery/releases/download/3.13.1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f94f874bca5d2485efa29ce7682dd4912875a883b00c0237af4fb874f3897a0e"
  end

  depends_on :macos
  depends_on xcode: "26.0"

  conflicts_with "periphery", because: "both install a `periphery` binary"
  conflicts_with "periphery-pro/tap/periphery-cli", because: "Periphery Pro also installs a `periphery` binary"

  def install
    args = %w[--disable-sandbox -c release --product periphery]
    # periphery links @rpath/libIndexStore.dylib and swift-index-store only adds the building
    # Xcode to the rpath, e.g. /Applications/Xcode_27.2.app on a CI runner. A bottle must find
    # the library on the user's machine: the default Xcode location first, then the Command Line
    # Tools, which homebrew-core's periphery formula also relies on.
    if build.bottle?
      args += %w[-Xlinker -rpath -Xlinker
                 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib
                 -Xlinker -rpath -Xlinker /Library/Developer/CommandLineTools/usr/lib]
    end
    system "swift", "build", *args
    bin.install ".build/release/periphery"
  end

  def caveats
    <<~EOS
      The bottle loads libIndexStore.dylib from /Applications/Xcode.app, or else from the
      Command Line Tools. If neither is installed there, build from source instead:
        brew reinstall --build-from-source periphery
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/periphery version")
  end
end
