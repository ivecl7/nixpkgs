{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  doxygen,
  libsForQt5,
  dtkcore,
  lxqt,
  librsvg,
  extra-cmake-modules,
  libraw,
  qt6Packages,
  treeland-protocols,
  wayland,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "dtkgui";
  version = "5.7.21";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-QgyY6vVWfivB+M/L9lfN/hiWBY3VEv0DsVgFC+/e3lw=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  postPatch = ''
    substituteInPlace src/util/dsvgrenderer.cpp \
      --replace-fail 'QLibrary("rsvg-2", "2")' 'QLibrary("${lib.getLib librsvg}/lib/librsvg-2.so")'
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    lxqt.libqtxdg
    librsvg
    extra-cmake-modules
    libraw
    qt6Packages.qwlroots
    treeland-protocols
    wayland
    wayland-scanner
  ];

  propagatedBuildInputs = [
    dtkcore
    libsForQt5.qtimageformats
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DBUILD_DOCS=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/${libsForQt5.qtbase.qtDocPrefix}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${libsForQt5.qtbase.bin}/${libsForQt5.qtbase.qtPluginPrefix}
  '';

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postFixup = ''
    for binary in $out/libexec/dtk5/DGui/bin/*; do
      wrapQtApp $binary
    done
  '';

  meta = with lib; {
    description = "Deepin Toolkit, gui module for DDE look and feel";
    homepage = "https://github.com/linuxdeepin/dtkgui";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.deepin ];
  };
}
