class Ilbc < Formula
  desc "FreeSWITCH compatible internet low bit rate codec."
  homepage "http://www.soft-switch.org/downloads/voipcodecs/"
  url "http://www.soft-switch.org/downloads/voipcodecs/ilbc-0.0.1.tar.gz"
  sha256 "52df3da6057dc05f1c9d699e0f3964dd256726effca9792f88b41148d3ca63a4"

  def install
    ENV.deparallelize
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    (lib + "pkgconfig/ilbc.pc").write pc_file
  end

  def pc_file; <<-EOF
prefix=#{prefix}
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include/libilbc

Name: ilbc
Description: Internet Low Bitrate Codec (iLBC) library for FreeSWITCH
Version: 0.0.1
Libs: -L${libdir} -lilbc
Libs.private:
Cflags: -I${includedir}/
EOF
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ilbc.h>
      #include <stdio.h>

      int main() {
        ilbc_encode_state_t Enc_Inst;

        ilbc_encode_init(&Enc_Inst, 20);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lilbc", "-o", "test"
    system "./test"
  end
end
