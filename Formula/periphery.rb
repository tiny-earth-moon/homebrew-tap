class Periphery < Formula
  desc "Unused code detector for Swift (maintained fork of peripheryapp/periphery)"
  homepage "https://github.com/tiny-earth-moon/periphery"
  url "https://github.com/tiny-earth-moon/periphery/archive/refs/tags/3.13.3.tar.gz"
  sha256 "0850723723af7b01689cdaac53aa8a447cd066da06fdd76a946d6f6395dd4831"
  license "MIT"
  head "https://github.com/tiny-earth-moon/periphery.git", branch: "master"

  bottle do
    root_url "https://github.com/tiny-earth-moon/periphery/releases/download/3.13.3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3002ccbb4e9be96d509189ba36c87891611a839b3ed0e14c39b56f06ecefba9f"
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
