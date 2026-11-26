class Outskirts < Formula
  desc "Finds unused code in Swift projects (community-maintained fork of Periphery)"
  homepage "https://github.com/tiny-earth-moon/outskirts"
  url "https://github.com/tiny-earth-moon/outskirts/archive/refs/tags/3.28.2.tar.gz"
  sha256 "18eedb7720e325d21e3558d5ca4b8cf49f33b4f85c3fe13533e7c0fa9b195a86"
  license "MIT"
  head "https://github.com/tiny-earth-moon/outskirts.git", branch: "master"

  bottle do
    root_url "https://github.com/tiny-earth-moon/outskirts/releases/download/3.28.2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d256c188e1bd4cdba2fe79cc3cdae57cb477a8fa57ed1b68cc07a2bbd18078e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3d9fd5002d9983ba946ced43848f4bfd29191943b6e3d4eb78ef37e03f73c1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c3c87a0d41df408326c313e127663cf21a45b07cffc83e6767c9566f6a38c52b"
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
