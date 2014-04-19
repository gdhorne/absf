#!sh_root/bin/sh

################################################################################
#
# Programme Name: ABSF
# Application Name: absf.sh
# Description: An automated build system framework to build Linux from Scratch
#              from source code. 
#
# Module Name: groundbreaking.sh
# Description: Handles the pre-condition and post-condition actions for the
#              stage.
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


source ./absf.cfg
source ./stage.cfg


###############################################################################
# Break ground at the build site.
###############################################################################

initialise()
{
        echo "Creating subdirectory hierarchy..."
        ./fhs.sh > ${ABSF_MBE_ROOT}/dev/null 2>&1

        chmod 0750 /root
        chmod 1777 /var /var/tmp

        ln -s ${ABSF_MBE_ROOT}/bin/{bash,cat,grep,pwd,stty} /bin > /dev/null 2>&1
        ln -s ${ABSF_MBE_ROOT}/bin/perl /usr/bin > /dev/null 2>&1
        ln -s ${ABSF_MBE_ROOT}/lib/libgcc_s.so{,.1} /usr/lib > /dev/null 2>&1
        ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib > /dev/null 2>&1
        ln -s bash /bin/sh > /dev/null 2>&1

        touch /etc/mtab

cat > /etc/passwd << "EOF"
root::0:0:root:/root:/bin/bash
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
mail:x:34
nogroup:x:99
EOF

        touch /var/run/utmp /var/log/{btmp,lastlog,wtmp}
        chgrp utmp /var/run/utmp /var/log/lastlog
        chmod 664 /var/run/utmp /var/log/lastlog

	sed -i 's/GROUNDBREAKING/#GROUNDBREAKING/' ./absf.cfg
	sed -i 's/#FOUNDATION/FOUNDATION/' ./absf.cfg
	sed -i 's/\${ABSF_MBE_ROOT}/\/usr/' ./builder.sh

        exec ${ABSF_MBE_ROOT}/bin/bash --login +h
}
 
###############################################################################
# Call the appropriate handler (initialise).
###############################################################################

case ${1} in
        initialise)
		initialise                
                ;;
	*)
		echo "ERROR: Unrecognised option"
		exit 1
		;;
esac
