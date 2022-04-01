class OpentelemetryCollector < Formula
  desc "OpenTelemetry Collector"
  homepage "https://opentelemetry.io"
  url "https://github.com/open-telemetry/opentelemetry-collector/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "4659de8422520e99beaae18774fc25dd41f05ac174106af69dc8a760c0ca0d35"
  license "Apache-2.0"
  head "https://github.com/open-telemetry/opentelemetry-collector.git", branch: "main"

  depends_on "go" => :build

  def install
    system "make", "otelcorecol"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip
    bin.install "bin/otelcorecol_#{os}_#{arch}" => "otelcorecol"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otelcorecol --version", 2)
  end
end
