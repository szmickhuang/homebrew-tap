class Crush < Formula
  desc "AI-powered coding assistant for the terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "4a1a7e2a5675ee6f1fb26c2c5d5307d60b6fecd8d5a9989122af0f3589b1d3bb"
  version "0.76.0"
  license "MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  livecheck do
    url :url
    strategy :github_latest_release
  end

  depends_on "go" => :build

  def install
    # 中国大陆/弱网环境：proxy.golang.org 不稳，用 goproxy.cn 兜底
    ENV["GOPROXY"] = "https://goproxy.cn,https://proxy.golang.org,direct"
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=v#{version}"
    # 直接输出到 prefix/bin，避免 bin.install 找不到文件
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"crush", "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")
  end
end
