/*
 * Bug 25485: Browser/TorBrowser/Tor/libstdc++.so.6: version `CXXABI_1.3.11' not found
 * Bug 31646: Update abicheck to require newer libstdc++.so.6
 * This program is useful in determining if the libstdc++.so.6 installed
 * on the system is recent enough. Specifically this program requires
 * `GLIBCXX_3.4.25` which should be provided by libstdc++.so.6 from
 * gcc >= 8.0.0. If the program executes successfully, that means we
 * should use the system version of libstdc++.so.6 and if not, that means
 * we should use the bundled version.
 *
 * We use std::random_device::entropy() in order to require GLIBCXX_3.4.25:
 * https://github.com/gcc-mirror/gcc/blob/gcc-8_3_0-release/libstdc%2B%2B-v3/config/abi/pre/gnu.ver#L1978
 */

#include <iostream>
#include <random>

int main()
{
    std::random_device rd;
    std::cout << "entropy: " << rd.entropy() << std::endl;
    return 0;
}
