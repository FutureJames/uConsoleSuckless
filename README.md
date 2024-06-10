
## Getting the Base system installed
Flash to SD card:

[uConsole_CM4_v1.3g_64bit.img](http://dl.clockworkpi.com/uConsole_CM4_v1.3g_64bit.img.7z)

```
md5sum 9dbd07a50967f4015ad9c13795cd71c6
```


First Boot and setup wifi, then open a terminal and run:
```
sudo raspi-config

Option 8: Update

Option 3: Interface options
Option 2: ssh (enable)
<Yes>

Option 6: Advanced Options
Option A3: Compositor
<No>

Option 6: Advanced Options
Option A1: Expand Filesystem

<Finish>
<Yes> (reboot now)
```

Get IP address
```
ifconfig
```

SSH from laptop (using the ip address you just got) and accept fingerprint
```
The authenticity of host '192.168.xxx.yyy (192.168.xxx.yyy)' can't be established.
ED25519 key fingerprint is SHA256:eFKkasdDY90/IFasdasdasdW07cbMNXasdU7boP/jQ.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

Update apt
```
sudo apt update
```

Install basic packages

```
sudo apt -y install git neovim tmux evtest
```

Disable network MAC randomization by creating this file:
```
sudo vim /etc/NetworkManager/conf.d/100-disable-wifi-mac-randomization.conf
```
And adding these contents:
```
[connection]
wifi.mac-address-randomization=1
 
[device]
wifi.scan-rand-mac-address=no
```

Note: you may need to edit your LAPTOP's known_hosts file since the IP address has changed.  If you don't know what this means, then you can just reset the file with this command:

```
rm ~/.ssh/known_hosts
```

Fix charging speed when running:
```
echo 'KERNEL=="axp20x-battery", ATTR{constant_charge_current_max}="2200000", ATTR{constant_charge_current}="2000000"' | sudo tee /etc/udev/rules.d/99-uconsole-charging.rules
```

Fix issue with temp monitoring
```
sudo mkdir /opt/vc &&
sudo mkdir /opt/vc/bin &&
sudo ln -s /usr/bin/vcgencmd /opt/vc/bin/vcgencmd
```

Install PipX
```
pip install pipx
~/.local/bin/pipx ensurepath
```

Install DWM dependencies
```
sudo apt -y install libx11-dev libxft-dev libxinerama-dev libimlib2-dev picom feh rofi stterm dash fonts-inconsolata
```

Install Nerd Fonts
```
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip &&
cd ~/.local/share/fonts &&
unzip JetBrainsMono.zip && 
rm JetBrainsMono.zip &&
fc-cache -fv &&
cd
```

Clone this repo for suckless apps
```
git clone https://github.com/FutureJames/ucsl.git ~/.ucsl
```

Make sure scripts are executable
```
cd ~/.ucsl &&
chmod 777 autostart_blocking.sh &&
chmod 777 autostart.sh 
```

Update paths:
```
vim ~/.ucsl/dwm/config.def.h
```

Scroll down to line 34 and update these with your username
```
static const char *light_up[] =   {"/home/YOUR-USER-NAME/.ucsl/brightness.sh", "-up", NULL};
static const char *light_down[] = {"/home/YOUR-USER-NAME/.ucsl/brightness.sh", "-down", NULL};
```

compile DWM and ST
```
cd ~/.ucsl/dwm/ &&
sudo make clean install &&
cd ~/.ucsl/st/ &&
sudo make clean install
```

Add DWM to options in update-alternatives
```
sudo update-alternatives --install $(which x-session-manager) x-session-manager $(which dwm) 20
```

Choose DWM to be our default
```
sudo update-alternatives --config x-session-manager
```

You will see something like this, select the option that has "/usr/local/bin/dwm"
```
There are 6 choices for the alternative x-session-manager (providing /usr/bin/x-session-manager).

  Selection    Path                      Priority   Status
------------------------------------------------------------
  0            /usr/bin/startlxde-pi      90        auto mode
  1            /usr/bin/gnome-session     50        manual mode
* 2            /usr/bin/lxsession         49        manual mode
  3            /usr/bin/openbox-session   40        manual mode
  4            /usr/bin/startlxde         50        manual mode
  5            /usr/bin/startlxde-pi      90        manual mode
  6            /usr/local/bin/dwm         20        manual mode

Press <enter> to keep the current choice[*], or type selection number: 6
```

Reboot device
```
sudo reboot
```

Final Software update? (you might have to reconnect to wifi)
```
sudo apt update
sudo apt upgrade

##update wifi settings
sudo raspi-config
```

## Finished with the basics!
