{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname   = "gruvbox-plus-icons";
  version = "2023-11-30";

  src = fetchFromGitHub {
    owner = "SylEleuth";
    repo  = "gruvbox-plus-icon-pack";
    rev   = "5ce3ef1ae9d8360e4aadfcf73842df9a417dd53b";
    hash  = "sha256-xS6ijyRhc9CaZVERLjqebbNsSbPoFUVTAutOjWiOUKc=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r Gruvbox-Plus-Dark $out/share/icons/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Gruvbox Plus icon pack for Linux desktops based on the Gruvbox color theme.";
    homepage    = "https://github.com/SylEleuth/gruvbox-plus-icon-pack";
    license     = licenses.gpl3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [
      RGBCube
    ];
  };
}
