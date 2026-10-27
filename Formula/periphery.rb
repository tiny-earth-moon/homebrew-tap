class Periphery < Formula
  desc "Unused code detector for Swift (maintained fork of peripheryapp/periphery)"
  homepage "https://github.com/tiny-earth-moon/periphery"
  url "https://github.com/tiny-earth-moon/periphery/archive/refs/tags/3.8.4.tar.gz"
  sha256 "4df85b1c3c227dc85f58fab8141e719770a2495861cc0161cf0db337321c1b6f"
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
    assert_match "3.8.4", shell_output("#{bin}/periphery version")
  end
end
