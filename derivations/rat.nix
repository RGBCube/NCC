{
  stdenv,
  fetchFromGitHub,
  unixtools,
}:

stdenv.mkDerivation rec {
  pname = "rat";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner  = "thinkingsand";
    repo   = pname;
    sha256 = "sha256-OsEIOC6EZrAN2NnDvnyN0nBRLVIviSMX2+TPqlidxrI=";
    rev    = "4817f542b067255d2b6cd1d29137f393da6e4085";
  };

  buildInputs = [ unixtools.xxd ];
  buildPhase = ''
    runHook preBuild

    make linux_audio

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 ./bin/rat -t $out/bin/

    runHook postInstall
  '';
}
