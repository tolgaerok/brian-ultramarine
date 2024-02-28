#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# Jan 20 2024

#   《˘ ͜ʖ ˘》
#
#  ██╗   ██╗██╗  ████████╗██████╗  █████╗ ███╗   ███╗ █████╗ ██████╗ ██╗███╗   ██╗███████╗    ██████╗ ██╗  ██╗ ██████╗ ███████╗
#  ██║   ██║██║  ╚══██╔══╝██╔══██╗██╔══██╗████╗ ████║██╔══██╗██╔══██╗██║████╗  ██║██╔════╝    ██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
#  ██║   ██║██║     ██║   ██████╔╝███████║██╔████╔██║███████║██████╔╝██║██╔██╗ ██║█████╗      ██████╔╝█████╔╝ ██║  ███╗███████╗
#  ██║   ██║██║     ██║   ██╔══██╗██╔══██║██║╚██╔╝██║██╔══██║██╔══██╗██║██║╚██╗██║██╔══╝      ██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
#  ╚██████╔╝███████╗██║   ██║  ██║██║  ██║██║ ╚═╝ ██║██║  ██║██║  ██║██║██║ ╚████║███████╗    ██║     ██║  ██╗╚██████╔╝███████║
#   ╚═════╝ ╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=Ultramarine%20Pkgs

sudo dnf install -y shotwell syncthing syncthing-tools blender gimp gimp-help krita scribus telegram vlc inkscape inkscape-docs discord power-profiles-daemon-docs fastfetch variety rclone rclone-browser grep ugrep vgrep ripgrep meld pandoc neofetch

#sudo dnf install -y transmission transmission-{remote-gtk,gtk,qt}

sudo dnf install -y flameshot


####

download_and_install_code_tv() {
	local download_url="$1"
	local download_location="$2"

	# Check if the application is already installed
	if command -v "$3" &>/dev/null; then
		display_message "$3 is already installed. Skipping installation."
		sleep 1
	else
		# Download and install the application
		display_message "[${GREEN}✔${NC}]  Downloading $3..."
		wget -O "$download_location" "$download_url"

		display_message "[${GREEN}✔${NC}]  Installing $3..."
		sudo dnf install "$download_location" -y

		# Cleanup
		display_message "[${GREEN}✔${NC}]  Cleaning up /tmp..."
		rm "$download_location"
		gum spin --spinner dot --title "Stand-by..." -- sleep 2

		display_message "[${GREEN}✔${NC}]  $3 installation completed."
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	fi

}

# Function to install a package
for_exit() {
	package_name="$1"

	# Check if the package is already installed
	if command -v "$package_name" &>/dev/null; then
		# If the package is already installed, do nothing
		echo "$package_name is already installed. Exiting."
		# sleep 1
		clear
	else
		# Install the package
		sudo dnf install -y "$package_name"
		echo "$package_name has been installed."
		# sleep 1
		clear
	fi
}

# Function to download and install a package
download_and_install() {
	url="$1"
	location="$2"
	package_name="$3"

	# Check if the package is already installed
	if sudo dnf list installed "$package_name" &>/dev/null; then
		display_message "[${RED}✘${NC}] $package_name is already installed. Skipping installation."
		sleep 1
		return
	fi

	# Download the package
	wget "$url" -O "$location"

	# Install the package
	sudo dnf install -y "$location"
}

# Function to check port 22
check_port22() {
	if pgrep sshd >/dev/null; then
		display_message "[${GREEN}✔${NC}] SSH service is running on port 22"
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
	else
		display_message "${RED}[✘]${NC} SSH service is not running on port 22. Install and enable SSHD service.\n"
		gum spin --spinner dot --title "Stand-by..." -- sleep 2
		check_error
	fi
}

# Function to check if a service is active
is_service_active() {
	systemctl is-active "$1" &>/dev/null
}

# Function to check if a service is enabled
is_service_enabled() {
	systemctl is-enabled "$1" &>/dev/null
}

# Function to print text in yellow color
print_yellow() {
	echo -e "\e[93m$1\e[0m"
}

function remove_libreoffice() {
	echo ""
	read -p "Do you want to remove LibreOffice and its core components? (y/n): " answer

	if [ "$answer" != "y" ]; then
		echo "Aborted by user."
		return 1
	fi

	# Remove LibreOffice
	sudo dnf group remove libreoffice -y

	# Remove LibreOffice core
	sudo dnf remove libreoffice-core -y

	echo "LibreOffice and its core components have been removed."
	return 0
}

install_apps() {
	display_message "[${GREEN}✔${NC}]  Installing afew personal apps..."

	remove_libreoffice

	sudo dnf -y up
	sudo dnf -y autoremove
	sudo dnf -y clean all

	# Enable trim support
	sudo systemctl enable fstrim.timer

	# Install Apps
	sudo dnf install rpmfusion-free-release-tainted
	sudo dnf install rpmfusion-nonfree-release-tainted
	sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"

	# Incase removed by libreoffice purge
	packages=(
		cjson-1.7.15-2.fc39.x86_64
		codec2-1.2.0-2.fc39.x86_64
		dbus-glib-0.112-6.fc39.x86_64
		gtk2-immodule-xim-2.24.33-15.fc39.x86_64
		gtk3-immodule-xim-3.24.39-1.fc39.x86_64
		ibus-gtk4-1.5.29~rc2-6.fc39.x86_64
		libXext-1.3.5-3.fc39.i686
		libfreeaptx-0.1.1-5.fc39.x86_64
		libgcab1-1.6-2.fc39.x86_64
		librabbitmq-0.13.0-3.fc39.x86_64
		librist-0.2.7-2.fc39.x86_64
		libvdpau-1.5-4.fc39.i686
		llvm16-libs-16.0.6-5.fc39.x86_64
		lpcnetfreedv-0.5-3.fc39.x86_64
		mbedtls-2.28.5-1.fc39.x86_64
		ostree-2023.8-2.fc39.x86_64
		pipewire-codec-aptx-1.0.0-1.fc39.x86_64
		xorg-x11-fonts-ISO8859-1-100dpi-7.5-36.fc39.noarch
	)

	for package in "${packages[@]}"; do
		sudo dnf install "$package" -y
	done

	packages=(
		cjson-1.7.15-2.fc39.x86_64
		codec2-1.2.0-2.fc39.x86_64
		dbus-glib-0.112-6.fc39.x86_64
		gtk2-immodule-xim-2.24.33-15.fc39.x86_64
		gtk3-immodule-xim-3.24.39-1.fc39.x86_64
		ibus-gtk4-1.5.29~rc2-6.fc39.x86_64
		libXext-1.3.5-3.fc39.i686
		libfreeaptx-0.1.1-5.fc39.x86_64
		libgcab1-1.6-2.fc39.x86_64
		librabbitmq-0.13.0-3.fc39.x86_64
		librist-0.2.7-2.fc39.x86_64
		libvdpau-1.5-4.fc39.i686
		llvm16-libs-16.0.6-5.fc39.x86_64
		lpcnetfreedv-0.5-3.fc39.x86_64
		mbedtls-2.28.5-1.fc39.x86_64
		ostree-2023.8-2.fc39.x86_64
		pipewire-codec-aptx-1.0.0-1.fc39.x86_64
		xorg-x11-fonts-ISO8859-1-100dpi-7.5-36.fc39.noarch
	)

	sudo dnf install "${packages[@]}"

	# Essential Packages
	if [ -f /usr/bin/nala ]; then
		sudo nala install --assume-yes \
			flatpak neofetch nano htop zip un{zip,rar} tar ffmpeg ffmpegthumbnailer tumbler sassc \
			fonts-noto gtk2-engines-murrine gtk2-engines-pixbuf ntfs-3g wget curl git openssh-client \
			intel-media-va-driver i965-va-driver webext-ublock-origin-firefox

	elif [ -f /usr/bin/dnf ]; then
		sudo dnf install --assumeyes --best --allowerasing \
			flatpak neofetch nano htop zip un{zip,rar} tar ffmpeg ffmpegthumbnailer tumbler sassc \
			google-noto-{cjk,emoji-color}-fonts gtk-murrine-engine gtk2-engines ntfs-3g wget curl git openssh \
			libva-intel-driver intel-media-driver mozilla-ublock-origin easyeffects pulseeffects
	fi

	# Audio
	[ -f /usr/bin/easyeffects ] && [ -f $HOME/.config/easyeffects/output/default.json ] && easyeffects -l default
	[ -f /usr/bin/pulseeffects ] && [ -f $HOME/.config/PulseEffects/output/default.json ] && pulseeffects -l default

	sudo dnf install -y PackageKit dconf-editor digikam direnv duf earlyoom espeak ffmpeg-libs figlet gedit gimp gimp-devel git gnome-font-viewer
	sudo dnf install -y grub-customizer kate libdvdcss libffi-devel lsd mpg123 neofetch openssl-devel p7zip p7zip-plugins pip python3 python3-pip
	sudo dnf install -y mesa-libGL mesa-libGLw mesa-libGLU mesa-libGLU-devel mesa-filesystem mesa-va-drivers mesa-libEGL mesa-libglapi mesa-libGL-devel mesa-vulkan-drivers mesa-libd3d-devel mesa-libOpenCL mesa-libOSMesa
	sudo dnf install -y rhythmbox rygel shotwell sshpass sxiv timeshift unrar unzip cowsay fortune-mod

	# NOT SURE ABOUT THIS sudo dnf install -y sshfs fuse-sshfs

	sudo dnf install -y rsync openssh-server openssh-clients wsdd
	sudo dnf install -y variety virt-manager wget xclip zstd fd-find fzf gtk3 rygel
	sudo dnf install dnf5 dnf5-plugins dnfdragora

	# Configure fortune
	# If you want to display a specific fortune file or category, you can use the -e option followed by the file or category name. For example:
	# fortune -e art ascii-art bofh-excuses computers cookie definitions disclaimer drugs education fortunes humorists kernelnewbies knghtbrd law linux literature miscellaneous news people riddles science
	# or to see a list:
	# fortune -f

	sudo dnf install --assumeyes --best --allowerasing \
		flatpak neofetch nano htop zip un{zip,rar} tar ffmpeg ffmpegthumbnailer tumbler sassc \
		google-noto-{cjk,emoji-color}-fonts gtk-murrine-engine gtk2-engines ntfs-3g wget curl git openssh \
		libva-intel-driver intel-media-driver mozilla-ublock-origin easyeffects pulseeffects

	sudo dnf install -y 'google-roboto*' 'mozilla-fira*' fira-code-fonts

	# Execute rygel to start DLNA sharing
	/usr/bin/rygel-preferences

	# Install profile-sync: it to manage browser profile(s) in tmpfs and to periodically sync back to the physical disc (HDD/SSD)
	sudo dnf install profile-sync-daemon
	/usr/bin/profile-sync-daemon preview
	# sudo dnf remove profile-sync-daemon
	# psd profile located in $HOME/.config/psd/psd.conf

	## Networking packages
	sudo dnf -y install iptables iptables-services nftables

	## System utilities
	sudo dnf -y install bash-completion busybox crontabs ca-certificates curl dnf-plugins-core dnf-utils gnupg2 nano screen ufw unzip vim wget zip

	## Programming and development tools
	sudo dnf -y install autoconf automake bash-completion git libtool make pkg-config python3 python3-pip

	## Additional libraries and dependencies
	sudo dnf -y install bc binutils haveged jq libsodium libsodium-devel PackageKit qrencode socat

	## Miscellaneous
	sudo dnf -y install dialog htop net-tools

	sudo dnf swap -y libavcodec-free libavcodec-freeworld --allowerasing
	sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing

	display_message "[${GREEN}✔${NC}]  Installing GUM"

	echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
	sudo yum install gum -y

	gum spin --spinner dot --title "GUM installed" -- sleep 2
