class SokolTools < Formula
  desc "Command-line tools for the Sokol headers"
  homepage "https://github.com/floooh/sokol-tools"
  license "MIT"
  head "https://github.com/floooh/sokol-tools-bin.git", branch: "master"

  depends_on :macos

  def install
    executable = if Hardware::CPU.arm?
      "bin/osx_arm64/sokol-shdc"
    else
      "bin/osx/sokol-shdc"
    end

    bin.install executable
  end

  test do
    system bin/"sokol-shdc", "--help"
  end
end
