{
  pkgs ? import <nixpkgs> { },
}:
with pkgs;
let
  llvmPackages = llvmPackages_18;
in
python313.overrideAttrs (
  final: prev: {
    src = ./.;

    nativeBuildInputs = [
      llvmPackages.libllvm # this must be prepended
      llvmPackages.clang
    ] ++ prev.nativeBuildInputs;

    env = prev.env // {
      PYTHON_FOR_REGEN = lib.getExe pkgsBuildBuild.python3;
    };

    configureFlags = prev.configureFlags ++ [
      "--enable-pystats"
      "--with-pydebug"
      "--enable-experimental-jit=yes-off"
    ];
  }
)
