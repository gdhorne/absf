#!sh_root/bin/sh

################################################################################
#
# Programme Name: ABSF
# Application Name: absf.sh
# Description: An automated build system framework to build Linux from Scratch
#              from source code.
#
# Module Name: builder.sh
# Description: Generic build process functionality with automatic override
#              for package-specific handling.
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
# Unpack the source code for the package. The system builder can override this
# default action by including a user_unpack() routine in the package build
# (*.build) specification.
###############################################################################

user_unpack()
{
        if [ -e ${ABSF_WORK}/${PROGRAMME} ]
        then
                builder_clean
        fi

        if [ ! -e ${ABSF_PACKAGES}/${ARCHIVE} ]
        then
                echo "${ARCHIVE} does not exist."
                exit 1
        fi

        CWD=${PWD}
        cd ${ABSF_WORK}

        if [ ${ARCHIVE##*.} = gz ] || [ ${ARCHIVE##*.} = tgz ]
        then
                echo "...unpacking"
                tar xzf ${ABSF_PACKAGES}/${ARCHIVE}
        elif [ ${ARCHIVE##*.} = bz2 ]
        then
                echo "...unpacking"
                tar xjf ${ABSF_PACKAGES}/${ARCHIVE}
        elif [ ${ARCHIVE##*.} = tar ]
        then
                echo "...unpacking"
                tar xf ${ABSF_PACKAGES}/${ARCHIVE}
        else
                echo "Unknown package archive type (${ARCHIVE##*.})"
                exit 1
        fi

        cd ${CWD}
}

###############################################################################
# Unpack the source code for the package.
###############################################################################

builder_unpack()
{
        user_unpack
}

###############################################################################
# Patch the source code for the package. The system builder can override this
# default action by including a user_patch() routine in the package build
# (*.build) specification.
###############################################################################

user_patch()
{
        local CWD=${PWD}
        cd ${ABSF_WORK}/${PROGRAMME}

        for delta in `echo ${PATCH}`
        do
                patch -Np1 -i ${ABSF_PACKAGES}/${delta} > /dev/null 2>&1
        done > /dev/null 2>&1

        cd ${CWD}
}

###############################################################################
# Patch the source code for the package.
###############################################################################

builder_patch()
{
        echo "...patching"
        user_patch
}

###############################################################################
# Configure the source code for the package. The system builder can override
# this default action by including a user_configure() routine in the package
# build (*.build) specification.
###############################################################################

user_configure()
{
        local CWD=${PWD}
        cd ${ABSF_WORK}/${PROGRAMME}

        CC=${MODE} ./configure --prefix=${ABSF_BUILD_ROOT} > /dev/null 2>&1

        cd ${CWD}
}

###############################################################################
# Configure the source code for the package.
###############################################################################

builder_configure()
{
        echo "...configuring"
        user_configure
}

###############################################################################
# Compile the source code for the package. The system builder can override
# this default action by including a user_compile() routine in the package
# build (*.build) specification.
###############################################################################

user_compile()
{
	local CWD=${PWD}
	cd ${ABSF_WORK}/${PROGRAMME}

	make -j ${COUNT} > /dev/null 2>&1

	cd ${CWD}
}

###############################################################################
# Compile the source code for the package.
###############################################################################

builder_compile()
{
        echo "...compiling"
        user_compile
}

builder_fixup()
{
	echo "...applying package-specific fix (not a patch)"
	user_fixup
}

###############################################################################
# Install the files associated with the package. The system builder can
# override this default action by including a user_install() routine in the
# package build (*.build) specification.
###############################################################################

user_install()
{
        local CWD=${PWD}
        cd ${ABSF_WORK}/${PROGRAMME}

        make install > /dev/null 2>&1

        cd ${CWD}
}

###############################################################################
# Install the files associated with the package.
###############################################################################

builder_install()
{
        echo "...installing"
        user_install
}

###############################################################################
# Uninstall the files from the build environment associated with the package.
# The system builder can override this default action by including a
# user_uninstall() routine in the package build (*.build) specification.
# NOT IMPLEMENTED
###############################################################################

user_uninstall()
{
        echo "Define an installation routine (user_uninstall) for ${PROGRAMME}"
        exit 1
}

###############################################################################
# Uninstall the files from the build environment associated with the package.
# NOT IMPLEMENTED
###############################################################################

builder_uninstall()
{
        echo "...uninstalling"
        user_uninstall
}

###############################################################################
# Delete the unpacked source code for the package from the build environment.
# The system builder can override this default action by including a
# user_clean() routine in the package build (*.build) specification.
###############################################################################

user_clean()
{
        if [ -e ${ABSF_WORK}/${PROGRAMME} ]
        then
                rm -rf ${ABSF_WORK}/${PROGRAMME} > /dev/null 2>&1
		rm -rf ${ABSF_WORK}/${PROGRAMME}-build > /dev/null 2>&1
        fi
}

###############################################################################
# Delete the unpacked source code for the package from the build environment.
###############################################################################

builder_clean()
{
        echo "...cleaning"
        user_clean
} 

###############################################################################
# Direct the activities of the builder by taking the appropriate actions
# (clean, compile, configure, install, patch, uninstall) based on the
# requirements of each package. The available actions can be extended by the
# system builder.
###############################################################################

process_package()
{
	if [ ! -e ${1} ]
	then
        	echo "builder file ${1} not found"
        	exit 1
	fi

	case ${2} in
       		clean)
               		builder_clean
               		;;
       		unpack)
               		builder_unpack
               		;;
       		patch)
                	builder_patch
                	;;
        	configure)
                	builder_configure
                	;;
        	compile)
                	builder_compile
                	;;
        	install)
                	builder_install
                	;;
        	uninstall)
                	builder_uninstall
                	;;
        	*)
                	user_${2}
                	;;
	esac
}

###############################################################################


###############################################################################
# Read each package build (*.build) specification from the building plan
# (*.plan) and take the appropriate actions (clean, compile, configure,
# install, patch, uninstall) based on the requirements of each package. The
# building plan is structured as a set of building stages which can be extended
# by the system builder. 
###############################################################################

for action in `echo ${1} | sed s/\@/\ /g`
do
	if [ ${action##*.} = build ]
	then
        	package=${action}
                echo
                echo "Processing package" ${package}
                echo at `date`
                source ./stage/${STAGE}/${package}
	else
                process_package ./stage/${STAGE}/${package} ${action}
        fi
done
