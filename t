   # Configurar o ambiente para o usuário builduser
        sudo -u builduser bash << -EOF
          mkdir -p /home/builduser/.config/manjaro-tools
          echo 'PACKAGER="Community Package/ISO Build <talesam@gmail.com>"' >> /home/builduser/.makepkg.conf
          echo "run_dir=/__w/builduser/build-iso/iso-profiles" > /home/builduser/.config/manjaro-tools/iso-profiles.conf
        EOF
