#!sh_root/bin/sh

################################################################################
#
# Programme Name: ABSF
# Application Name: absf.sh
# Description: An automated build system framework to build Linux from Scratch
#              from source code.
#
# Module Name: bootable.sh
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
# Install boot scripts.
###############################################################################

finalise()
{
        echo "Installing boot scripts..."
	./stage/${STAGE}/bootscripts.sh
	sed -i s/BOOTABLE/#BOOTABLE/ ./absf.cfg
}

###############################################################################
# Call the appropriate handler (install_boot_scripts).
###############################################################################

case ${1} in
        finalise)
              	finalise  
                ;;
	*)
		echo "ERROR: Unrecognised option"
		exit 1
		;;
esac

