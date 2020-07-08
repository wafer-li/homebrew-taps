class Kcptun < Formula
  desc "A Stable & Secure Tunnel Based On KCP with N:M Multiplexing"
  homepage "https://github.com/xtaci/kcptun"
  version "v20200701"
  url "https://github.com/xtaci/kcptun/archive/#{version}.tar.gz"
  sha256 "d5b2d212c6806f1c4eba5fbce8797734eaa8ae0f8cdd90dd06d0844392888ff0"

  depends_on "go" => :build

  def install
    # ENV["GO111MODULE"] = "on"
    ENV["GOPROXY"] = "https://goproxy.io"
    system "go", "build", "-o", "bin/kcptunc", "./client"
    system "go", "build", "-o", "bin/kcptuns", "./server"

    bin.install "bin/kcptunc"
    bin.install "bin/kcptuns"
  end

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{bin}/kcptunc</string>
        <string>-c</string>
        <string>#{etc}/kcptun/config.json</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/log/kcptun-client-error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/kcptun-client.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    client_version = shell_output("#{bin}/kcptunc -v")
    assert_match "kcptun version SELFBUILD", client_version
    server_version = shell_output("#{bin}/kcptuns -v")
    assert_match "kcptun version SELFBUILD", server_version
    system "kcptunc", "-v"
    system "kcptuns", "-v"
  end
end
