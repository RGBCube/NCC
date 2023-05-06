{ stdenvNoCC, fetchFromGitHub, ...}:

stdenvNoCC.mkDerivation rec {
  name = "nvchad";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "refs/heads/v${version}";
    sha256 = "sha256-bfDNMy4pjdSwYAjyhN09fGLJguoooJAQm1nKneCpKcU=";
  };

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./ $out
  '';
}
