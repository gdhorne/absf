#!sh_root/bin/sh

################################################################################
#
# Programme Name: ABSF
# Application Name: absf.sh
# Description: An automated build system framework to build Linux from Scratch
#              from source code.
#
# Module Name: bootscripts.sh
# Description: Bootscripts for the newly built system.
#
# Copyright (c) 2003 Gregory D. Horne (horne at member dot fsf dot org)
#
################################################################################
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License (version 2), or
#    (at your option) any later version, as published by the Free Software
#    Foundation.
#
#    The software is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with the software; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA.
#
################################################################################

cat > /etc/sysconfig/clock << "EOF"
# Begin /etc/sysconfig/clock
# Set UTC=0 if hardware clock is NOT configured as UTC/GMT
UTC=1

# End /etc/sysconfig/clock
EOF

cat > /etc/sysconfig/console << "EOF"
#KEYMAP=""
#KEYMAP_CORRECTIONS=""
#FONT=""
#LEGACY_CHARSET=""
LOGLEVEL="7"
UNICODE="0"
EOF

cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# End /etc/inputrc
EOF

cat > /etc/profile << "EOF"
# Begin /etc/profile

export LANG=en_US.iso88591

# End /etc/profile
EOF

echo "HOSTNAME=LFS" > /etc/sysconfig/network

cat > /etc/hosts << "EOF"
# Begin /etc/hosts (no network card version)

127.0.0.1	lfs localhost

# End /etc/hosts (no network card version)
EOF

#local CWD=${PWD}
#cd /etc/sysconfig/network-devices
#mkdir -v ifconfig.eth0
#cat > ifconfig.eth0/ipv4 << "EOF"
#ONBOOT=yes
#SERVICE=ipv4-static
#IP=192.168.1.10
#GATEWAY=192.168.1.1
#PREFIX=24
#BROADCAST=192.168.1.255
#EOF
#cd ${CWD}

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

#domain <Your Domain Name>
#nameserver	192.168.1.1
#nameserver	192.168.1.2

# End /etc/resolv.conf
EOF

cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type   options         dump  fsck
#                                                        order

/dev/hdb1    /             ext2   defaults        1     1
#/dev/<yyy>     swap         swap   pri=1           0     0
proc           /proc        proc   defaults        0     0
sysfs          /sys         sysfs  defaults        0     0
devpts         /dev/pts     devpts gid=4,mode=620  0     0
#shm            /dev/shm     tmpfs  defaults        0     0
# End /etc/fstab
EOF
