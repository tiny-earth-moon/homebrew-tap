class Periphery < Formula
  desc "Identify unused code in Swift projects (maintained fork of peripheryapp/periphery)"
  homepage "https://github.com/tiny-earth-moon/periphery"
  url "https://github.com/tiny-earth-moon/periphery/archive/refs/tags/3.8.3.tar.gz"
  sha256 "cf5b76b5beee7465b27c416f4551e0d481d66062ab4b2ad0686a687634ab084a"
  license "MIT"
  head "https://github.com/tiny-earth-moon/periphery.git", branch: "master"

  depends_on xcode: ["26.0", :build]
  depends_on :macos

  conflicts_with "periphery", because: "both install a `periphery` binary"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "periphery"
    bin.install ".build/release/periphery"
  end

  test do
    assert_match "3.8.3", shell_output("#{bin}/periphery version")
  end
end
