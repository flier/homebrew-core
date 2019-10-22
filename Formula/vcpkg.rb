class Vcpkg < Formula
  desc "C++ Library Manager for Windows, Linux, and MacOS"
  homepage "https://docs.microsoft.com/en-us/cpp/vcpkg"

  url "https://github.com/microsoft/vcpkg/archive/2019.09.tar.gz"
  sha256 "16c1b151cc3cf2022b03b699970e548f48cd9cd1e68db0b9c23a1d0d39391e56"
  head "https://github.com/microsoft/vcpkg.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "gcc"
  
  def install
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version_suffix}"
    ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version_suffix}"
    system "./bootstrap-vcpkg.sh", "-useSystemBinaries"
    libexec.install ["ports", "scripts", "triplets", "vcpkg", ".vcpkg-root"]
    bin.install_symlink libexec/"vcpkg"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/vcpkg version")
    assert_match "zlib", pipe_output("#{bin}/vcpkg search zlib")
  end
end
