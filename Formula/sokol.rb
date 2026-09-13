class Sokol < Formula
  desc "Minimal cross-platform standalone C headers"
  homepage "https://github.com/floooh/sokol"
  license "Zlib"
  head "https://github.com/floooh/sokol.git", branch: "master"

  def install
    (include/"sokol").install Dir["*.h"]
    (include/"sokol/util").install Dir["util/*.h"]
  end

  test do
    (testpath/"test.c").write <<~C
            #define SOKOL_IMPL
            #include "sokol_time.h"

            int main(void) {
              stm_setup();
      (void)stm_now();
      return 0;
            }
    C

    system ENV.cc, "-I#{include}/sokol", "test.c", "-o", "test"
    system "./test"
  end
end
