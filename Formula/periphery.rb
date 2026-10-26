class Periphery < Formula
  desc "Identify unused code in Swift projects (maintained fork of peripheryapp/periphery)"
  homepage "https://github.com/tiny-earth-moon/periphery"
  url "https://github.com/tiny-earth-moon/periphery/archive/refs/tags/3.8.2.tar.gz"
  sha256 "ecdc052c700072f426d643bb385c3f629dccf56c72902bd1c379ecd616eeb2e7"
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
    assert_match "3.8.2", shell_output("#{bin}/periphery version")
  end
end
