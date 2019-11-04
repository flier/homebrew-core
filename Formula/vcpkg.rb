class Vcpkg < Formula
  desc "C++ Library Manager for Windows, Linux, and MacOS"
  homepage "https://docs.microsoft.com/en-us/cpp/vcpkg"

  url "https://github.com/microsoft/vcpkg/archive/2019.10.tar.gz"
  sha256 "1a3e81b50702522ede10806f38d929d9aa4c7ffb5c2595eeee07a04cafacc77c"
  head "https://github.com/microsoft/vcpkg.git"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "gcc" if MacOS.version <= :mojave

  def install
    if MacOS.version <= :mojave
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version_suffix}"
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{Formula["gcc"].version_suffix}"
    end
    args = %w[-useSystemBinaries]
    args += %w[-allowAppleClang] if MacOS.version > :mojave
    system "./bootstrap-vcpkg.sh", *args
    libexec.install ["ports", "scripts", "triplets", "vcpkg", ".vcpkg-root"]
    bin.install_symlink libexec/"vcpkg"
  end

  test do
    assert_match "zlib", pipe_output("#{bin}/vcpkg search zlib")
  end
end
