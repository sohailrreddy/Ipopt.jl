if VERSION >= v"1.3" && !(haskey(ENV, "JULIA_IPOPT_LIBRARY_PATH") && haskey(ENV, "JULIA_IPOPT_EXECUTABLE_PATH"))
    exit()  # Use Ipopt_jll instead.
end

using BinaryProvider

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libipopt"], :libipopt),
    ExecutableProduct(prefix, "ipopt", :amplexe),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaBinaryWrappers/Ipopt_jll.jl/releases/download/Ipopt-v3.13.2+0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-gnu-libgfortran3-cxx03.tar.gz", "bed359bbf63128215d5adb1dc53044ed97566cad757f72b440275932e74fcd2c"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-gnu-libgfortran3-cxx11.tar.gz", "a236e3fdfae8c397fc2400c60d57f31f57541b6f22650a8df9b8a0f7b198a7bb"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-gnu-libgfortran4-cxx03.tar.gz", "3c3507a9b7f7c54881d720f5dd20f39c871407d0196055cdcffbc7f4059f0cd7"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-gnu-libgfortran4-cxx11.tar.gz", "9b0f28c8987b6f2c5c39122a37e9b5accda4019edeacb3be3b8ebe0de320e693"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-gnu-libgfortran5-cxx03.tar.gz", "aa06b89cc0aa4b9157a99260f0adb0a9e85a18c20c5cac4b781498d6ed2d1234"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-gnu-libgfortran5-cxx11.tar.gz", "f6e18d9fb562aa44ed9ddbab1cb2122fcd2cb0dc034686fb5af8a58884c7554a"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-musl-libgfortran3-cxx03.tar.gz", "5c1bfc631ddd0e6de19223558d482aec733f53f99d7af26436753de2a94090cd"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-musl-libgfortran3-cxx11.tar.gz", "e9dcad5a9e8d72cd1250168ffbbb5c68759869ba84e057b8877abf9146940f07"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-musl-libgfortran4-cxx03.tar.gz", "0bb93a5db8fd0b9aa0bdc41db68025bfdebe8ef468a4c6b88b83c6cb4ad3e5a1"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-musl-libgfortran4-cxx11.tar.gz", "65373153d5f8d14504b1e7d0eaf967baf8408db3e749e6f342dda7d755468847"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-musl-libgfortran5-cxx03.tar.gz", "329dd313ba6da542c0ae06a236402f0279e0c45f4d8a9aa1373a8bf82a869c4e"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.aarch64-linux-musl-libgfortran5-cxx11.tar.gz", "6f36bc0fccbd6292f764108c218b26e4449e891a8f063d4b7958700005424f55"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-gnueabihf-libgfortran3-cxx03.tar.gz", "269d9d86c8d23285f864fec19b65d8f6c618ab2f217ea23971f527b3b776a450"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-gnueabihf-libgfortran3-cxx11.tar.gz", "ed2aa1c432f53adf0e5c64524e1b401fbb65a99e4a3d16d9561484f0e5d385bf"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-gnueabihf-libgfortran4-cxx03.tar.gz", "2217cd2ed481ba19de2ce49b13b7f85b0fc87151f207b4846806dc7d076157e5"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-gnueabihf-libgfortran4-cxx11.tar.gz", "e83987f3a60cf400411bdcd295a8fe18398a77ce160e6a09ec92eeb79089e4da"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-gnueabihf-libgfortran5-cxx03.tar.gz", "a9cc1439fc05657ba2dbf6b5f2b548e13364e00940d4f7fd0aad0835a0a1bf91"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-gnueabihf-libgfortran5-cxx11.tar.gz", "6add6a40fb8c6aeee961b7abadf2a3749a821ec68aa5c52cbc0fcede97865da8"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-musleabihf-libgfortran3-cxx03.tar.gz", "e7f93eb56c0408e21381a2efebf7d197e1cd8b423e5768159a541fd386d4c3fa"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-musleabihf-libgfortran3-cxx11.tar.gz", "1d9055d6db6bb0899201506ad885fd6398de2c541489b84e6f34a42abd8475d9"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-musleabihf-libgfortran4-cxx03.tar.gz", "68cce661e19725c087edce05c20ddcf9e78ad697df63af3a2088660a57ebcac9"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-musleabihf-libgfortran4-cxx11.tar.gz", "86fefe99701772d0b45a4759f1382a49c80963cbcd47266e7fe85fc8f7b0632d"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-musleabihf-libgfortran5-cxx03.tar.gz", "398122631c32ccd584bb1761f3f8be9630b3d9f4aa9649d2af503f2e7055b756"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.armv7l-linux-musleabihf-libgfortran5-cxx11.tar.gz", "aa5166ffcd1ad94783beccdc3bb171321974268ef813d65192851a6a2c82f656"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-gnu-libgfortran3-cxx03.tar.gz", "f597e24bc521fee19bd9547347a859b4201deb0c0ca1bc457e7c41cb113fbff8"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-gnu-libgfortran3-cxx11.tar.gz", "ad5278604795f5990f11e27fd1b3927094599c2b458e97aec92e93cd240139b7"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-gnu-libgfortran4-cxx03.tar.gz", "43ac1f94e559016fc117404aa0f4d33cada2cc5a15a308564eb20c06d8c6c3c7"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-gnu-libgfortran4-cxx11.tar.gz", "5c1527018aa2039f6f4251b0eb3c9287aead603f521f9a9563d6baa2807c5eca"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-gnu-libgfortran5-cxx03.tar.gz", "3c352a9b6772ed9d9745efd5bf61a7ddb8e742609db8aa5509cc8ffce42c1c06"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-gnu-libgfortran5-cxx11.tar.gz", "694d7a0191aca91c7d04fc1459cd4d170b051b70bc6c0bb966347e0325d08147"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-musl-libgfortran3-cxx03.tar.gz", "d5c08f899e90e357f69d886731334f8e57e162d66d8bddb4d54f25b4a86f7a63"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-musl-libgfortran3-cxx11.tar.gz", "a88d8ea6d26065b9b478ffe7d05013a043bb15ba8ecd0f08972b78caed6a4e1d"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-musl-libgfortran4-cxx03.tar.gz", "ed0b8242669dec58f797b5647f21fb045000b85edf0ddd48ee08a0a88adf858a"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-musl-libgfortran4-cxx11.tar.gz", "d357ebe823f76e29b6380b72818a0a9597c0e1fe9a3a5a9be752ba9daf5255ae"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-musl-libgfortran5-cxx03.tar.gz", "2baea86a2b9343fe8257accd6fb7cf563a79c971e2263d76c98a3a0186de737a"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-linux-musl-libgfortran5-cxx11.tar.gz", "07197d3aee44396bd289030d7b9ef31399d8959ebc6ff16cb58cc9ef15e12d8d"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-w64-mingw32-libgfortran3-cxx03.tar.gz", "d67d2be408fa63ee67fb8b443f3a52c905d7295284d7c7d6c7fb30bbb650035e"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-w64-mingw32-libgfortran3-cxx11.tar.gz", "7417c88af4cd026d967e44447035ba3c248ae730ab590a36a55a6004b7fc4fdf"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-w64-mingw32-libgfortran4-cxx03.tar.gz", "1bbe178ea16c014e6294bb60c3a88027c4a4511bb30eb57ce54a3bd5ae0384f6"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-w64-mingw32-libgfortran4-cxx11.tar.gz", "4ce9232e7f902a8b9999f3cfa0c934600110176a40a55d6c3921814bf64a35da"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.i686-w64-mingw32-libgfortran5-cxx03.tar.gz", "69fd33000a7085e3713cf7a50f2feca1ec7a0351567f89309cf05b06c9cea7b0"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.i686-w64-mingw32-libgfortran5-cxx11.tar.gz", "92672ea65b1599e47ef77eab638b497e383d52d4447b2037572e598fd59229f7"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.powerpc64le-linux-gnu-libgfortran3-cxx03.tar.gz", "f33dd8f30eaf99ad6849b04988dabd4796ebd92c73866d2c1d1a99647aa54330"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.powerpc64le-linux-gnu-libgfortran3-cxx11.tar.gz", "bd82361e489b530c388fe647d541d8debdc1a050d92c4796f82ba2db221e24a4"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.powerpc64le-linux-gnu-libgfortran4-cxx03.tar.gz", "53c9f9de27a94d3240294ea16c1ca39b72d34bb246cfb17acbff4a93ba9def40"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.powerpc64le-linux-gnu-libgfortran4-cxx11.tar.gz", "e2a057666807d274643c3f9eaa4d3ce867a4e6a74537f40afd458af2d7c44d06"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.powerpc64le-linux-gnu-libgfortran5-cxx03.tar.gz", "67a5fcbc1cf469f35237457537ab2d6878544b6e10e4467a64165c6709a98536"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.powerpc64le-linux-gnu-libgfortran5-cxx11.tar.gz", "8c8c9a6ee63e849c783d7f0d034f79700ddb44ce30da3b7c7b71096fa3cc4c4a"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-apple-darwin14-libgfortran3-cxx03.tar.gz", "a905edd95dbbc38a766408215df90607c5de1149713e54829134c8f205fe189b"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-apple-darwin14-libgfortran3-cxx11.tar.gz", "6b1954a890099cf07d76ad403a89535f80583d58a6be891097dfd57d3a2199b1"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-apple-darwin14-libgfortran4-cxx03.tar.gz", "57ec817ca75ff6befc5b016bfe4796af3cc6d74acbda491d6f4a822ae32e2616"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-apple-darwin14-libgfortran4-cxx11.tar.gz", "2223d9702ead939291ccebd37b65974561c49ba1f08cb826294c2bfd820eca63"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-apple-darwin14-libgfortran5-cxx03.tar.gz", "6c844ed7212af30073964b57400241e24de99ca2262e85090f5d34a21a9f972f"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-apple-darwin14-libgfortran5-cxx11.tar.gz", "72c3d4ae1acdd4815129f329e660008c1767a291847605c09a6d87fe1277cb58"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-gnu-libgfortran3-cxx03.tar.gz", "d496a355c79221228b69dac865567bda121d75772e06f9fbe5bd0b0ab13ceab1"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-gnu-libgfortran3-cxx11.tar.gz", "c9199f5d4bf79121208d3a48f216bbe643dccdac6ee31c7ceff9b727b58c71b9"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-gnu-libgfortran4-cxx03.tar.gz", "4837bc4de9dbb328c171938eceba24f44fd6989a434f9981918348b3c42b8aeb"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-gnu-libgfortran4-cxx11.tar.gz", "4583675e767cd3dee64ecc3cd54a65b943a1769972d805fd2eb1dc4b3cda6bf3"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-gnu-libgfortran5-cxx03.tar.gz", "f46bf6a3a42a4cb175feb73102b2ec62ede908a05d5c2e871d1f8e1dbf4aceec"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-gnu-libgfortran5-cxx11.tar.gz", "be3577870b855476c7b22f134950e98ee27b9bcd73ab456a2d626c8f6f95cc76"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-musl-libgfortran3-cxx03.tar.gz", "a039c6ea305705daada0fffea56ba12f089cd773ab8973fb690ea35d2cba34fb"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-musl-libgfortran3-cxx11.tar.gz", "bd4cae26147fd6d870d81ef052894c19db1f85094e22cf5bdf7842dc62d3585f"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-musl-libgfortran4-cxx03.tar.gz", "1a2de72395c925ea03f9f6d1f84f3a526d6c66df3d8b361a6cee41744190278f"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-musl-libgfortran4-cxx11.tar.gz", "c9ee7a579cca559554f7503fa797d9c08008af4a417945c29ec1fe73be889bf1"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-musl-libgfortran5-cxx03.tar.gz", "89ed817d417d5552a77618efd28e8efc6a3a27dfa75c2dfd14cdd325b331109a"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-linux-musl-libgfortran5-cxx11.tar.gz", "b64ccf90b27f73cb4c0831817176f80520be69c5dcd6da9f06093097cebfb4d7"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-unknown-freebsd11.1-libgfortran3-cxx03.tar.gz", "bcdaee0b1a7dd796f7bcf130740e7d62aba6da3bbaae93028789279ec3215d5c"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-unknown-freebsd11.1-libgfortran3-cxx11.tar.gz", "165f086abd60da2b4ac1f08b02958c69ad1c64880b45441c58081bd0f9e5abbf"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-unknown-freebsd11.1-libgfortran4-cxx03.tar.gz", "24899c094690436654e54f1648cdb637c7699d64f268ef843c3cf74e91cddf2b"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-unknown-freebsd11.1-libgfortran4-cxx11.tar.gz", "c3ef1366203443ed9079d51b8932f4c5b38b0fac2c1f6cc1d1c2c3276670b2e9"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-unknown-freebsd11.1-libgfortran5-cxx03.tar.gz", "2a4d281f72f6b9ea67456daed3920273e06ba1e80f51040ebf76a1e4497b76ea"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-unknown-freebsd11.1-libgfortran5-cxx11.tar.gz", "9cc2d63dfd3ae768aab4b20c9e2641c6804dc9a2b5d27f41908b3c9370b7d4a3"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-w64-mingw32-libgfortran3-cxx03.tar.gz", "70cae55c61a6bd8eaabec96c5c2085951862cc5052b23cff8f87ae05080a032b"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-w64-mingw32-libgfortran3-cxx11.tar.gz", "f01e4120877ac722514a7eded94a351477e2f2f29f5f9b4a94d4c24bd7aa139e"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-w64-mingw32-libgfortran4-cxx03.tar.gz", "a837bda68c6059dff057a1968743c9fbc3957ce8568ad226d7517c364646682f"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-w64-mingw32-libgfortran4-cxx11.tar.gz", "5fe62d97efd77b35ed7ac428a102c7201a2d859c6852547944380a5eef9b26ab"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx03)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-w64-mingw32-libgfortran5-cxx03.tar.gz", "fe339c6d2c1371267ba8f7519de6afa665ff77a1337bdd7566cfdc373464436d"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8, :cxx11)) => ("$bin_prefix/Ipopt.v3.13.2.x86_64-w64-mingw32-libgfortran5-cxx11.tar.gz", "c173c91afe765288658ae9eb1e55e2ebd72604c63274a2aa9c3a552f617ddf2e"),
)

# To fix gcc4 bug in Windows
# https://sourceforge.net/p/mingw-w64/bugs/727/
this_platform = platform_key_abi()
if typeof(this_platform)==Windows && this_platform.compiler_abi.gcc_version == :gcc4
   this_platform = Windows(arch(this_platform), libc=libc(this_platform), compiler_abi=CompilerABI(:gcc6))
end

function update_product(product::LibraryProduct, library_path, binary_path)
    LibraryProduct(library_path, product.libnames, product.variable_name)
end

function update_product(product::ExecutableProduct, library_path, binary_path)
    ExecutableProduct(joinpath(binary_path, basename(product.path)), product.variable_name)
end

custom_library = false
if haskey(ENV,"JULIA_IPOPT_LIBRARY_PATH") && haskey(ENV,"JULIA_IPOPT_EXECUTABLE_PATH")
    custom_products = [update_product(product, ENV["JULIA_IPOPT_LIBRARY_PATH"], ENV["JULIA_IPOPT_EXECUTABLE_PATH"]) for product in products]
    if all(satisfied(p; verbose=verbose) for p in custom_products)
        products = custom_products
        custom_library = true
    else
        error("Could not install custom libraries from $(ENV["JULIA_IPOPT_LIBRARY_PATH"]) and $(ENV["JULIA_IPOPT_EXECUTABLE_PATH"]).\nTo fall back to BinaryProvider call delete!(ENV,\"JULIA_IPOPT_LIBRARY_PATH\");delete!(ENV,\"JULIA_IPOPT_EXECUTABLE_PATH\") and run build again.")
    end
end

if !custom_library
    # Install unsatisfied or updated dependencies:
    # We added `, isolate=true` as otherwise, it would segfault when closing `OpenBLAS32`,
    # probably because it is conflicting with Julia openblas.
    unsatisfied = any(!satisfied(p; verbose=verbose, isolate=true) for p in products)

    dl_info = choose_download(download_info, platform_key_abi())
    if dl_info === nothing && unsatisfied
        # If we don't have a compatible .tar.gz to download, complain.
        # Alternatively, you could attempt to install from a separate provider,
        # build from source or something even more ambitious here.
        error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
    end

    # If we have a download, and we are unsatisfied (or the version we're
    # trying to install is not itself installed) then load it up!
    if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
        # Download and install binaries
        evalfile("build_CompilerSupportLibraries.v0.3.3.jl")
        evalfile("build_ASL.v0.1.1.jl")
        evalfile("build_METIS.v5.1.0.jl")
        evalfile("build_OpenBLAS32.v0.3.9.jl")
        evalfile("build_MUMPS_seq.v5.2.1.jl")
        install(dl_info...; prefix=prefix, force=true, verbose=verbose)
    end
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
