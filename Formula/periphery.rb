class Periphery < Formula
  desc "Identify unused code in Swift projects (maintained fork of peripheryapp/periphery)"
  homepage "https://github.com/tiny-earth-moon/periphery"
  url "https://github.com/tiny-earth-moon/periphery/archive/refs/tags/3.8.1.tar.gz"
  sha256 "70bdcb9b509b6bc7e28d3c31a1764001c52d25e2edc6359d02db4ef3f5de2a9a"
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
    assert_match "3.8.1", shell_output("#{bin}/periphery version")
  end
end
