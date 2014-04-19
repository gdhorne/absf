#!sh_root/bin/sh

################################################################################
#
# Programme Name: ABSF
# Application Name: absf.sh
# Description: An automated build system framework to build Linux from Scratch
#              from source code. 
#
# Module Name: mbe.sh
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


###############################################################################
# Initialize the minimal build environment by preparing the partition on which
# the build environment will be created, initializing the directory structure,
# creating a temporary workspace for the build process, unpacking the archive
# containing the Linux from Scratch (LFS) packages, and finally assigning
# ownership to user.
###############################################################################

initialise()
{
        echo "Preparing the build environment"
        echo

        echo "Setting up the partition scheme"

        if [ ! -e ${ABSF_ROOT} ]
        then
                mkdir -p ${ABSF_ROOT}
        fi

        if [ -e ${ABSF_ROOT}/lost+found ]
        then
                umount ${ABSF_ROOT}
        fi

	#echo "Wiping ${ABSF_PARTITION}"
	#dd if=/dev/zero of=${ABSF_PARTITION}

	echo "Creating file system on ${ABSF_PARTITION}"
        mkfs -L LFS -t ext2 ${ABSF_PARTITION} > /dev/null 2>&1
        mkdir -p ${ABSF_ROOT}
        mount -t ext2 ${ABSF_PARTITION} ${ABSF_ROOT} > /dev/null 2>&1


        echo "Setting up build environment"

        if [ -e ${ABSF_BUILD_ROOT} ]
        then
                rm -rf ${ABSF_BUILD_ROOT}
        fi

        mkdir ${ABSF_ROOT}${ABSF_BUILD_ROOT}
	ln -sf ${ABSF_ROOT}${ABSF_BUILD_ROOT} /

        echo "Creating subdirectory hierarchy"
        ./fhs.sh

	if [ -z ${ABSF_ROOT}${ABSF_BUILD_ROOT}/root ]
	then
		mkdir ${ABSF_ROOT}${ABSF_BUILD_ROOT}/root
	fi

        echo "Creating workspace for MBE"
        mkdir ${ABSF_PACKAGES}
        mkdir ${ABSF_WORK}
        chmod a+wt ${ABSF_WORK}

        echo "Extracting LFS packages from ${ABSF_PACKAGE_ARCHIVE}"

        CWD=${PWD}
        cd ${ABSF_PACKAGES}
        for archive in `echo ${ABSF_PACKAGE_ARCHIVE}`
        do
                tar xf ${CWD}/${archive}
        done
        cd ${CWD}

        if [ ! -z ${ABSF_PACKAGE_PATCHES} ]
        then
                echo
                echo "Copying patches"
                cp ${ABSF_PACKAGE_PATCHES}/*.patch ${ABSF_PACKAGES}
        fi

        echo "Changing ownership to lfs user"
	echo ${ABSF_USER}
        chown -R ${ABSF_USER}:${ABSF_USER} ${ABSF_BUILD_ROOT}
        chown -R ${ABSF_USER}:${ABSF_USER} ${ABSF_ROOT}
        chown -R ${ABSF_USER}:${ABSF_USER} ${ABSF_ROOT}${ABSF_BUILD_ROOT}
}

###############################################################################
# Finalize the minimial build environment by assigning ownership to user
# 'root'.
###############################################################################

finalise()
{
	sed -i 's/MBE /#MBE /' ./absf.cfg

	echo "Changing ownership to super user (root)"
        su -c "chown -R root:root ${ABSF_ROOT}${ABSF_BUILD_ROOT}"
}

###############################################################################
# Call the appropriate handler (initialize, finalize).
###############################################################################

case ${1} in
        initialise)
               	initialise 
                ;;
        finalise)
                finalise
                ;;
	*)
		echo "ERROR: Unrecognised option"
		exit 1
		;;
esac
