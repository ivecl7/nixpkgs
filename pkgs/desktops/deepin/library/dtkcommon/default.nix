{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "dtkcommon";
  version = "5.7.21";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-l6qWaqpWzsC0iiphxOZ09xi9wZ6sTzN+n9yuWTAeTig=";
  };

  nativeBuildInputs = [ cmake ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Public project for building DTK Library";
    homepage = "https://github.com/linuxdeepin/dtkcommon";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.deepin ];
  };
}
