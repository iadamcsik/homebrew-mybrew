class ThriftAT0931 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://archive.apache.org/dist/thrift/0.9.3.1/thrift-0.9.3.1.tar.gz"
  sha256 "8e5f59285f43bdbb30825e731d946dab49686b003f141b000539cd3eaa3f8aa2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "79422a32dc72ec61bb4f0b9db57a08af6c7478ac676e52f14d05e9060acff2df" => :mojave
    sha256 "c48f3d1200f4cedd092622f380bee268caefa553822c4b0f7bf25aec13d19371" => :high_sierra
    sha256 "d0b173d367891df3d5a9398ea5f5e3a48cbd412fa88955e29d061b7707b7b9e4" => :sierra
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "boost"
  depends_on "openssl"

  def install
    args = %w[
      -DWITH_ERLANG=OFF
      -DWITH_HASKELL=OFF
      -DWITH_JAVA=OFF
      -DWITH_PERL=OFF
      -DWITH_PHP=OFF
      -DWITH_PHP_EXTENSION=OFF
      -DWITH_PYTHON=OFF
      -DWITH_RUBY=OFF
      -DWITH_TESTS=OFF
    ]

    ENV.cxx11 if ENV.compiler == :clang

    inreplace "configure", /^am__api_version=[0-9.']+$/, "am__api_version='1.16'"
    build_dir = buildpath.parent/"build"
    build_dir.mkdir
    cd build_dir

    # Don't install extensions to /usr
    ENV["JAVA_PREFIX"] = pkgshare/"java"

    ENV.deparallelize
    system "cmake", buildpath,
                    "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                    *args
    system "make", "install"
#    raise 'baj van'
#    system "make", "check"
#    system "make", "cross"
#    system "make", "dist"
  end

  test do
    assert_match "Thrift", shell_output("#{bin}/thrift --version")
  end
end
