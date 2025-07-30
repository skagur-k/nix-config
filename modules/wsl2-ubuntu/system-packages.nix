{ pkgs }:

with pkgs;
[
  # Development tools
  gcc
  gnumake
  cmake
  pkg-config
  python3
  nodejs
  yarn

  # System utilities
  inotify-tools
  procps
  psmisc
  lsof
  strace
  ltrace

  # Network tools
  nmap
  netcat
  socat
  mtr
  traceroute

  # File management
  rsync
  unzip
  zip
  tar
  gzip
  bzip2
  xz

  # Text processing
  jq
  yq
  xmlstarlet
  csvkit

  # Monitoring
  iotop
  iftop
  nethogs
  glances

  # Security
  openssl
  gnupg
  pass
  sshfs

  # Media
  ffmpeg
  imagemagick
  poppler_utils

  # Database
  sqlite
  postgresql

  # Container tools
  docker
  docker-compose
  podman
]
