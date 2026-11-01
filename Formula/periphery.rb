class Periphery < Formula
  desc "Unused code detector for Swift (maintained fork of peripheryapp/periphery)"
  homepage "https://github.com/tiny-earth-moon/periphery"
  url "https://github.com/tiny-earth-moon/periphery/archive/refs/tags/3.12.14.tar.gz"
  sha256 "23f0c3ff272fd4f695728d572985fe0d2248d2bd7058e4595dde4f5784e3d97a"
  license "MIT"
  head "https://github.com/tiny-earth-moon/periphery.git", branch: "master"

  depends_on xcode: ["26.0", :build]
  depends_on :macos

  conflicts_with "periphery", because: "both install a `periphery` binary"
  conflicts_with "periphery-pro/tap/periphery-cli", because: "Periphery Pro also installs a `periphery` binary"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "periphery"
    bin.install ".build/release/periphery"
  end

  test do
    assert_match "3.12.0", shell_output("#{bin}/periphery version")
  end
end
