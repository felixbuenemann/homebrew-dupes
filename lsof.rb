class LsofDownloadStrategy < CurlDownloadStrategy
  def stage
    super
    safe_system "/usr/bin/tar", "xf", "#{name}_#{version}_src.tar"
    cd "#{name}_#{version}_src"
  end
end

class Lsof < Formula
  desc "Utility to list open files"
  homepage "https://people.freebsd.org/~abe/"
  url "https://mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.89.tar.bz2",
    :using => LsofDownloadStrategy
  sha256 "81ac2fc5fdc944793baf41a14002b6deb5a29096b387744e28f8c30a360a3718"

  bottle do
    cellar :any_skip_relocation
    sha256 "166741406a0a1d6ac78b82274d56f1bb1d24c4d4cd2421919e48ce42566f90ca" => :el_capitan
    sha256 "b8292349936eea9e0f24daf01818cba06ce5e689b4e97f026a431034c509e67d" => :yosemite
    sha256 "92a1f687aa8a0df343b90771e16f6a11aa60968c034c9660318e38142533fb82" => :mavericks
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c3acbb8/lsof/lsof-489-darwin-compile-fix.patch"
    sha256 "997d8c147070987350fc12078ce83cd6e9e159f757944879d7e4da374c030755"
  end

  def install
    ENV["LSOF_INCLUDE"] = "#{MacOS.sdk_path}/usr/include"

    # Source hardcodes full header paths at /usr/include
    inreplace %w[
      dialects/darwin/kmem/dlsof.h
      dialects/darwin/kmem/machine.h
      dialects/darwin/libproc/machine.h
    ], "/usr/include", "#{MacOS.sdk_path}/usr/include"

    mv "00README", "README"
    system "./Configure", "-n", `uname -s`.chomp.downcase
    system "make"
    bin.install "lsof"
    man8.install "lsof.8"
  end

  test do
    (testpath/"test").open("w") do
      system "#{bin}/lsof", testpath/"test"
    end
  end
end
