class Outskirts < Formula
  desc "Finds unused code in Swift projects (community-maintained fork of Periphery)"
  homepage "https://github.com/tiny-earth-moon/outskirts"
  url "https://github.com/tiny-earth-moon/outskirts/archive/refs/tags/3.21.3.tar.gz"
  sha256 "583a87d763a49ac67d76b345853cccdfd75f094439d4e44622feecb904b15ace"
  license "MIT"
  head "https://github.com/tiny-earth-moon/outskirts.git", branch: "master"

  bottle do
    root_url "https://github.com/tiny-earth-moon/outskirts/releases/download/3.21.3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8df8aa7cc4fa19749e3bcfbe1c74b0902024f580dbb946b630231b8cb6a67b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "585a37760a1e61b9660cc78d6a6c7961b3d094dd85112c48eb560cd4dc46827f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ae4ff5513deb50fcd1b9a087505f635bb9956606da421c76a8a8eb507b0312a"
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
