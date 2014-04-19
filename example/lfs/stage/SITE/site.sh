#!sh_root/bin/sh

################################################################################
#
# Programme Name: ABSF
# Application Name: absf.sh
# Description: An automated build system framework to build Linux from Scratch
#              from source code. 
#
# Module Name: site.sh
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
# Access the build site on which the distribution will be constructed. 
###############################################################################

initialise()
{
        echo -n "Access build site (${ABSF_BUILD_ROOT})"

        mkdir -p ${ABSF_ROOT}/{dev,proc,sys} > /dev/null 2>&1

        mknod -m 600 ${ABSF_ROOT}/dev/console c 5 1 > /dev/null 2>&1
        mknod -m 666 ${ABSF_ROOT}/dev/null c 1 3 > /dev/null 2>&1

        mount --bind /dev ${ABSF_ROOT}/dev > /dev/null 2>&1

        mount -t devpts devpts ${ABSF_ROOT}/dev/pts > /dev/null 2>&1

        #if [ ! -e ${ABSF_BUILD_ROOT}/dev/shm ]
        #then
	mount -t tmpfs shm ${ABSF_BUILD_ROOT}/dev/shm > /dev/null 2>&1
        #fi

        mount -t proc proc ${ABSF_BUILD_ROOT}/proc < /dev/null 2>&1
        mount -t sysfs sysfs ${ABSF_BUILD_ROOT}/sys > /dev/null 2>&1

        sed -i 's/ABSF_BUILD_ROOT=\/tools/ABSF_BUILD_ROOT=\//' ./absf.cfg
	sed -i 's/SITE/#SITE/' ./absf.cfg
	sed -i 's/#GROUNDBREAKING/GROUNDBREAKING/' ./absf.cfg

        rm -f sh_root > /dev/null 2>&1
        ln -sf /tools sh_root > /dev/null 2>&1

	tar -cf ${ABSF_MBE_ROOT}/root/base.tar ../lfs > /dev/null 2>&1

	rm -f sh_root > /dev/null 2>&1
	ln -sf / sh_root > /dev/null 2>&1

	sed -i 's/ABSF_BUILD_ROOT=\//ABSF_BUILD_ROOT=\/tools/' ./absf.cfg
	sed -i 's/GROUNDBREAKING/#GROUNDBREAKING/' ./absf.cfg

        echo -n " as user " && whoami

        chroot ${ABSF_ROOT} ${ABSF_BUILD_ROOT}/bin/env -i \
                HOME=/root TERM=${TERM} PS1='\u:\w\$ ' \
                PATH=/bin:/usr/bin:/sbin:/usr/sbin:${ABSF_BUILD_ROOT}/bin \
                ${ABSF_BUILD_ROOT}/bin/bash --login +h
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
