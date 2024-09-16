#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# shellcheck shell=bash disable=SC1091,SC2039,SC2166
#
#  t
#  Created: 2024/09/16 - 01:43
#  Altered: 2024/09/16 - 01:43
#
#  Copyright (c) 2024-2024, Vilmar Catafesta <vcatafesta@gmail.com>
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#  1. Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#  2. Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AS IS'' AND ANY EXPRESS OR
#  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
#  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
#  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##############################################################################
#export LANGUAGE=pt_BR
export TEXTDOMAINDIR=/usr/share/locale
export TEXTDOMAIN=t

# Definir a variável de controle para restaurar a formatação original
reset=$(tput sgr0)

# Definir os estilos de texto como variáveis
bold=$(tput bold)
underline=$(tput smul)   # Início do sublinhado
nounderline=$(tput rmul) # Fim do sublinhado
reverse=$(tput rev)      # Inverte as cores de fundo e texto

# Definir as cores ANSI como variáveis
black=$(tput bold)$(tput setaf 0)
red=$(tput bold)$(tput setaf 196)
green=$(tput bold)$(tput setaf 2)
yellow=$(tput bold)$(tput setaf 3)
blue=$(tput setaf 4)
pink=$(tput setaf 5)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
gray=$(tput setaf 8)
orange=$(tput setaf 202)
purple=$(tput setaf 125)
violet=$(tput setaf 61)
light_red=$(tput setaf 9)
light_green=$(tput setaf 10)
light_yellow=$(tput setaf 11)
light_blue=$(tput setaf 12)
light_magenta=$(tput setaf 13)
light_cyan=$(tput setaf 14)
bright_white=$(tput setaf 15)

#debug
export PS4='${red}${0##*/}${green}[$FUNCNAME]${pink}[$LINENO]${reset}'
#set -x
#set -e
shopt -s extglob

#system
declare APP="${0##*/}"
declare _VERSION_="1.0.0-20240916"
declare distro="$(uname -n)"
declare DEPENDENCIES=(tput)
source /usr/share/fetch/core.sh

MostraErro() {
	echo "erro: ${red}$1${reset} => comando: ${cyan}'$2'${reset} => result=${yellow}$3${reset}"
}
trap 'MostraErro "$APP[$FUNCNAME][$LINENO]" "$BASH_COMMAND" "$?"; exit 1' ERR

configure_kernel() {
	echo "Configuring kernel: $KERNEL"
	case "$KERNEL" in
	oldLts)
		KERNEL_VER=$(curl -s https://www.kernel.org/feeds/kdist.xml | grep ": longterm" | sed 's/^.*<title>//' | sed 's/<\/title>.*$//' | cut -d ":" -f1 | rev | cut -d "." -f2,3 | rev | head -n2 | sed 's/\.//g' | tail -n1)
		;;
	atualLts)
		KERNEL_VER=$(curl -s https://www.kernel.org/feeds/kdist.xml | grep ": longterm" | sed 's/^.*<title>//' | sed 's/<\/title>.*$//' | cut -d ":" -f1 | rev | cut -d "." -f2,3 | rev | head -n1 | sed 's/\.//g')
		;;
	latest)
		KERNEL_VER=$(curl -s https://raw.githubusercontent.com/biglinux/linux-latest/stable/PKGBUILD | awk -F= '/kernelver=/{print $2}')
		echo "linux-latest" >>"$PROFILE_PATH/$EDITION/Packages-Root"
		;;
	xanmod*)
		echo "linux-firmware" >>"$PROFILE_PATH/$EDITION/Packages-Root"
		KERNEL_VER="-${KERNEL}"
		;;
	esac

	# Definir KERNEL_NAME
	if [[ "$KERNEL" != "xanmod" ]]; then
		KERNEL_NAME="linux${KERNEL_VER}"
	else
		local xan_ver
		xan_ver=$(find /var/cache/manjaro-tools/iso -type f -name "*-pkgs.txt" -exec stat -c '%Y %n' {} + |
			sort -nr |
			awk 'NR==1 {print $2}' |
			xargs grep linux-xanmod |
			grep -v headers |
			awk '{print $2}' |
			cut -d "-" -f1 |
			sed 's/\.//')
		KERNEL_NAME="linux-${KERNEL//-/}${xan_ver}"
	fi
	echo "KERNEL_VER  set to: $KERNEL_VER"
	echo "KERNEL_NAME set to: $KERNEL_NAME"

	# Adicione o pacote do kernel ao Packages-Root
	echo "${KERNEL_NAME}" >>"$PROFILE_PATH/$EDITION/Packages-Root"
	echo "Added ${KERNEL_NAME} to Packages-Root"
}
