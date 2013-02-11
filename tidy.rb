require 'formula'

class Tidy < Formula
  homepage 'http://tidy.sourceforge.net/'
  url 'ftp://mirror.internode.on.net/pub/gentoo/distfiles/tidy-20090325.tar.bz2'
  sha1 '28c000a2cd40262fc0d7c2c429eb2a09b2df7bf4'

  head 'https://github.com/w3c/tidy-html5.git'

  depends_on :automake
  depends_on :libtool

  def install
    system 'sh', 'build/gnuauto/setup.sh'
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
