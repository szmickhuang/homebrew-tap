class Crush < Formula
  desc "AI-powered coding assistant for the terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.83.0.tar.gz"
  # 不要单独写版号行，URL 里的 v0.77.0 brew 会自动推断
  sha256 "e0acab570a39579d7aa1164a896ddba1ef60b57a1d655fcee9a3ae735f3334fb"
  license "MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  livecheck do
    # 显式给 GitHub 主页（不能用 :url，brew livecheck 不会展开到 releases 页面）
    # brew audit 建议用 :homepage 简写
    url :homepage
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
