{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  spdlog,
  systemd,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtklog";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtklog";
    rev = finalAttrs.version;
    hash = "sha256-IscD9ItAexfbEGqulumV+UM3wqm9/JwTsAZf2QC5X0Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libsForQt5.qtbase
    spdlog
  ]
  ++ lib.optional withSystemd systemd;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_SYSTEMD" withSystemd)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
  ];

  meta = {
    description = "Simple, convinient and thread safe logger for Qt-based C++ apps";
    homepage = "https://github.com/linuxdeepin/dtklog";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.deepin ];
  };
})
