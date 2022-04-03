#!/bin/bash
# encoding: utf-8

##################################################
#		    Variaveis 			 #
##################################################

# Nome do Computador
HOSTN=NOME

# Localização. Verifique o diretório /usr/share/zoneinfo/<Zone>/<SubZone>
LOCALE=America/Sao_Paulo

# Senha de Root do sistema após a instalação
ROOT_PASSWD=SENHA

# Usário comum
USER=USUÁRIO
USER_PASSWD=SENHA

######## Variáveis menos suscetíveis a mudanças
KEYBOARD_LAYOUT=us-acentos
LANGUAGE=pt_BR

##################################################
#		    functions 			 #
##################################################

function configurando_pacman
{
	if [ "$(uname -m)" = "x86_64" ]
	then
		cp /etc/pacman.conf /etc/pacman.conf.bkp
		# Adiciona o Multilib
		sed '/^#\[multilib\]/{s/^#//;n;s/^#//;n;s/^#//}' /etc/pacman.conf > /tmp/pacman
		mv /tmp/pacman /etc/pacman.conf

	fi
}

function instalando_sistema
{
	ERR=0
	echo "Rodando pactrap linux linux-firmware base base-devel"
	pacstrap /mnt base linux linux-firmware base-devel || ERR=1
	echo "Rodando pactrap grub-UEFI"
	pacstrap /mnt grub efibootmgr intel-ucode ntfs-3g os-prober || ERR=1
	echo "Rodando genfstab"
	genfstab -U /mnt >> /mnt/etc/fstab || ERR=1

	if [[ $ERR -eq 1 ]]; then
		echo "Erro ao instalar sistema"
		exit 1
	fi
}

##################################################
#		    Script 			 #
##################################################

#### Instalação
configurando_pacman
instalando_sistema

#### Entra no novo sistema (chroot)
arch-chroot /mnt << EOF
echo $HOSTN > /etc/hostname

echo >> /etc/hosts
echo -e 127.0.0.1'\t'localhost.localdomain'\t'$HOSTN >> /etc/hosts
echo -e ::1'\t\t'localhost.localdomain'\t'$HOSTN >> /etc/hosts

echo 'KEYMAP='$KEYBOARD_LAYOUT > /etc/vconsole.conf

sed 's/^#'$LANGUAGE'.UTF-8/'$LANGUAGE.UTF-8/ /etc/locale.gen > /tmp/locale
mv /tmp/locale /etc/locale.gen
locale-gen

export LANG=$LANGUAGE'.utf-8'
echo 'LANG='$LANGUAGE'.utf-8' > /etc/locale.conf

rm /etc/localtime
ln -s /usr/share/zoneinfo/$LOCALE /etc/localtime
echo $LOCALE > /etc/timezone
hwclock --systohc --utc

pacman -S wireless_tools wpa_supplicant dialog networkmanager acpi acpid xorg-xinit xorg-server xf86-video-nouveau mesa-demos nvidia nvidia-settings nvidia-utils ttf-dejavu ttf-liberation ttf-bitstream-vera ttf-droid ttf-opensans ttf-ubuntu-font-family ttf-roboto ttf-fantasque-sans-mono ttf-croscore ttf-carlito ttf-caladea neofetch git p7zip unrar unzip alsa-utils alsa-plugins alsa-lib bluez bluez-tools bluez-utils nano sudo gdm gnome-tweaks gnome-control-center gnome-keyring xdg-user-dirs-gtk gvfs-google gvfs-gphoto2 gvfs-mtp gvfs-smb gnome-terminal mousetweaks gnome-backgrounds file-roller nautilus gnome-system-monitor gnome-photos gnome-calculator gnome-calendar gnome-weather eog epiphany --noconfirm

systemctl enable NetworkManager.service
systemctl enable acpid.service
systemctl enable bluetooth.service
systemctl enable gdm.service

echo -e '\nGRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck
grub-mkconfig -o /boot/grub/grub.cfg

echo "root:$ROOT_PASSWD" | chpasswd

useradd -m -g users -G wheel -s /bin/bash $USER
echo "$USER:$USER_PASSWD" | chpasswd
echo "$USER ALL=(ALL) ALL" >> /etc/sudoers

gpasswd -a $USER users
gpasswd -a $USER audio
gpasswd -a $USER video
gpasswd -a $USER daemon
gpasswd -a $USER dbus
gpasswd -a $USER disk
gpasswd -a $USER games
gpasswd -a $USER rfkill
gpasswd -a $USER lp
gpasswd -a $USER network
gpasswd -a $USER optical
gpasswd -a $USER power
gpasswd -a $USER scanner
gpasswd -a $USER storage
EOF

echo "Umounting partitions"
umount /mnt/{boot,home,}
poweroff
