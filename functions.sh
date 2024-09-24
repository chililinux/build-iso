configurar_manjaro_tools_para_usuario_builduser() {
  # Configurar o ambiente para o usuário builduser
  sudo -u vcatafesta bash -c '
    echo "PACKAGER=\"Vilmar Catafesta <vcatafesta@gmail.com>\"" >> /home/vcatafesta/.makepkg.conf
    echo "GPGKEY=\"A0D5A8312A83940ED8B04B0F4BAC871802E960F1\"" >> /home/vcatafesta/.makepkg.conf
    mkdir -p /home/vcatafesta/.config/manjaro-tools
    #cp -R /etc/manjaro-tools /home/vcatafesta/.config
    echo run_dir=\$WORK_PATH_ISO_PROFILES > /home/vcatafesta/.config/manjaro-tools/iso-profiles.conf
  '
}
export -f configurar_manjaro_tools_para_usuario_builduser
configurar_manjaro_tools_para_usuario_builduser
configurar_manjaro_tools_para_usuario_builduser() {
  if ! id "builduser" &>/dev/null; then
    useradd -m builduser
  fi

  # Configurar o ambiente para o usuário builduser
  sudo -u builduser bash -c '
    echo "PACKAGER=\"Vilmar Catafesta <vcatafesta@gmail.com>\"" >> /home/builduser/.makepkg.conf
    echo "GPGKEY=\"A0D5A8312A83940ED8B04B0F4BAC871802E960F1\"" >> /home/builduser/.makepkg.conf
    mkdir -p /home/builduser/.config/manjaro-tools
    cp -R /etc/manjaro-tools /home/builduser/.config
    echo "run_dir=\$WORK_PATH_ISO_PROFILES" > /home/builduser/.config/manjaro-tools/iso-profiles.conf
  '
}
export -f configurar_manjaro_tools_para_usuario_builduser
