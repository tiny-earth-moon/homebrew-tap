class Outskirts < Formula
  desc "Finds unused code in Swift projects (community-maintained fork of Periphery)"
  homepage "https://github.com/tiny-earth-moon/outskirts"
  url "https://github.com/tiny-earth-moon/outskirts/archive/refs/tags/3.28.1.tar.gz"
  sha256 "e410b04a5c8a34a8c285c5556f07ab9a21abba48670e6fe887c232f2633917eb"
  license "MIT"
  head "https://github.com/tiny-earth-moon/outskirts.git", branch: "master"

  bottle do
    root_url "https://github.com/tiny-earth-moon/outskirts/releases/download/3.28.1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4b3ba678d2226f0fb02d3d456efa789eea687cdcd952ceaa2c722eba2df129e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fa79c9eda3f57bc1105193bbbf3e5efd59bdd03ff5fbbf4377ed34945593695c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fb10e37d08458e4c6a5449fd8a9aefed2eed337359605fc32671a27a9599ffc"
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
