#!sh_root/bin/sh

################################################################################
#
# Programme Name: ABSF
# Application Name: absf.sh
# Description: An automated build system framework to build Linux from Scratch
#              from source code.
#
# Module Name: fhs.sh
# Description: Create the subdirectory structure in accordance with the
#              Filesystem Hierarchy Standard 2.3 on the specified partition. 
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


if [ -z ${ABSF_BUILD_ROOT} ]
then
	echo "No target system specified"
	exit 1
fi

echo
echo "Filesystem Hierarchy Standard (FHS 2.3)"
echo "...installing directory structure on ${ABSF_BUILD_ROOT}" 
echo

if [ ! -e ${ABSF_BUILD_ROOT} ]
then
	mkdir ${ABSF_BUILD_ROOT}
fi

mkdir ${ABSF_BUILD_ROOT}/{bin,boot,dev,etc,lib,media,mnt,opt,proc,sbin,srv,tmp,usr,var}
mkdir ${ABSF_BUILD_ROOT}/{home,root}

mkdir ${ABSF_BUILD_ROOT}/etc/{opt,X11,sgml,xml}

mkdir ${ABSF_BUILD_ROOT}/lib/modules

mkdir ${ABSF_BUILD_ROOT}/media/{cdrecorder,cdrom,floppy,zip}

mkdir ${ABSF_BUILD_ROOT}/opt/{bin,doc,include,info,lib,man}

mkdir ${ABSF_BUILD_ROOT}/usr/{X11R6,X11R6/{bin,include,lib},bin,games,include,lib,local,local/{bin,games,include,lib,man,sbin,share,src},sbin,share,share/{dict,doc,games,info,locale,man,man/man{1,2,3,4,5,6,7,8,9},misc,nls,sgml,sgml/{docbook,html,mathml,tei},terminfo,tmac,zoneinfo},src}
ln -s ${ABSF_BUILD_ROOT}/usr/share/man ${ABSF_BUILD_ROOT}/usr/man

mkdir ${ABSF_BUILD_ROOT}/var/{account,backups,cache,cache/{fonts,man,www},crash,cron,games,lib,lib/{hwclock,misc,xdm},local,lock,log,mail,msgs,opt,preserve,run,spool,spool/{lpd,mqueue,news,rwho,uucp},tmp,yp}

if [[ ${STAGE} = 'MBE' ]]
then
	chmod -R 0755 ${ABSF_BUILD_ROOT}/.
fi
