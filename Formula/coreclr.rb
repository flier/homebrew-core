class Coreclr < Formula
  desc ".NET Core runtime and the base library"
  homepage "https://github.com/dotnet/coreclr"
  url "https://github.com/dotnet/coreclr.git", :branch => "release/1.0.0"
  version "1.0.0"
  #url "https://github.com/dotnet/coreclr/archive/v1.0.4.tar.gz"
  #sha256 "b49ba545fe632dfd5426669ca3300009a5ffd1ccf3c1cf82303dcf44044db33d"

  depends_on "icu4c"
  depends_on "cmake" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  def install
    system "./build.sh", "x64", "release", "skiptests", "verbose"

    libexec.install "bin/obj/OSX.x64.Release"
    bin.install_symlink :path => "#{libexec}/bin"
    include.install_symlink :path => "#{libexec}/inc"
    lib.install_symlink :path => "#{libexec}/lib"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test coreclr`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
