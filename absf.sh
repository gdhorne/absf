#!sh_root/bin/sh

################################################################################
#
# Programme Name: ABSF
# Application Name: absf.sh
# Description: An automated build system framework to build Linux from Scratch
#              from source code.
#
# Module Name: absf.sh
# Description: The driver of the building process.
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
# For each stage of the build process follow the build plan.
###############################################################################

for stage in `echo ${STAGES}`
do
	if [[ `echo ${stage} | grep ^[^\#]` ]]
	then
        	echo STAGE=${stage} > ./stage.cfg
        	source ./stage.cfg

        	source ./stage/${STAGE}/stage${STAGE}.cfg

        	echo
        	echo -n "Stage: ${STAGE}"
        	echo " - ${DESCRIPTION}"
        	echo

        	eval ${PRE}

		for package in `grep ^[^\#] ./stage/${STAGE}/stage${STAGE}.plan | sed s/\ /\@/g`
		do
			./builder.sh ${package} 
		done

        	eval ${POST}

        	echo
	fi
done

exit 0
