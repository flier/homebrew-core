class Corefx < Formula
  desc ".NET Core foundational libraries"
  homepage "https://github.com/dotnet/corefx"
  url "https://github.com/dotnet/corefx.git", :branch => "release/1.0.0"
  version "1.0.0"
  #url "https://github.com/dotnet/corefx/archive/v1.0.0.tar.gz"
  #sha256 "98f9475ea42e5d55ad9402424e342a6c0ea7351f3fb5805a602132969b44b774"

  depends_on "openssl"
  depends_on "coreclr"
  depends_on "cmake" => :build

  patch :DATA

  def install
    flags = %w[CMAKE_INCLUDE_PATH CMAKE_CXX_FLAGS CMAKE_C_FLAGS].map { |flag|
              ["cmakeargs", "-D#{flag}=-I#{Formula["openssl"].opt_include}"]
            } << [
              "cmakeargs", "-DCMAKE_LIBRARY_PATH=-L#{Formula["openssl"].opt_lib}",
              "cmakeargs", "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_prefix}"
            ]

    system "./build.sh", "native", "x64", "release", "skiptests", *flags.flatten
    system "./build.sh", "managed", "x64", "release"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test corefx`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
__END__
diff --git a/src/Native/CMakeLists.txt b/src/Native/CMakeLists.txt
index 815a873..241bafb 100644
--- a/src/Native/CMakeLists.txt
+++ b/src/Native/CMakeLists.txt
@@ -4,8 +4,8 @@ project(CoreFX)
 set(CMAKE_MACOSX_RPATH ON)
 set(CMAKE_INSTALL_PREFIX $ENV{__CMakeBinDir})
 set(CMAKE_INCLUDE_CURRENT_DIR ON)
-set(CMAKE_C_FLAGS "-std=c11")
-set(CMAKE_CXX_FLAGS "-std=c++11")
+set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")
+set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
 set(CMAKE_SHARED_LIBRARY_PREFIX "")
 set(VERSION_FILE_PATH "${CMAKE_BINARY_DIR}/../../version.c")
