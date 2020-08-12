/*
 * Bug 34359: Update abicheck to require newer libstdc++.so.6
 * This program is useful in determining if the libstdc++.so.6 installed
 * on the system is recent enough. Specifically, this program requires
 * `GLIBCXX_3.4.28` which should be provided by libstdc++.so.6 from
 * gcc >= 9.3.0. If the program executes successfully, that means we
 * should use the system version of libstdc++.so.6 and if not, that means
 * we should use the bundled version.
 *
 * We use std::pmr::monotonic_buffer_resource in order to require
 * GLIBCXX_3.4.28:
 * https://github.com/gcc-mirror/gcc/blob/9e4ebad20a064d10df451cfb2cea9853d339a898/libstdc%2B%2B-v3/config/abi/pre/gnu.ver#L2303
 * The example below got inspired by
 * https://www.mail-archive.com/gcc-patches@gcc.gnu.org/msg227964.html.
 */

#include <memory_resource>

int main () {
  std::pmr::monotonic_buffer_resource res;
  void* a = res.allocate(1);
  res.release();
  return 0;
}
