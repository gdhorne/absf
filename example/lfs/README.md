## Automated Build System Framework

### Constructing a GNU/Linux Distribution using Automated Build System Framework

A self-sufficient bootable system can be built from the ground up using the instructions in this section. Firstly, a bootstrapping, minimal build environment (MBE) is constructed; think of the minimal build environment as the toolbox needed by the system builder. Secondly, the building site is prepared in two steps: gain ownership of the building site and break ground. Thirdly, the foundation is laid upon which the system builder can construct the interior and exterior to the builder's preferences. Finally, the system is made bootable. After the basic system is constructed additional features can be added by creating a build specification for the next stage.

A step-by-step guide to the system is presented in a walk-through format suitable for almost anyone with an interest in constructing their own basic GNU/Linux distribution. By the end of the walk-through, you will have a bootable though minimal command-line-oriented system.

### Tutorial: Building Process Walk-through

*Disclaimer: The Linux From Scratch (LFS) (Version 6.3) was used to test the Automated Build System Framework. Automated Build System Framework is not a derivative work of LFS, nor is Automated Build System Framework endorsed by the Linux From Scratch Project.*

Step 1: Using Git clone the Automated Build System Framework repository into a subdirectory to which you have write permission.

	$ git clone https://github.com/gdhorne/absf.git

Step 2: Make the subdirectory ./absf the current default subdirectory.

Step 3: List the contents of the subdirectory to verify the cloning process was successful.

Step 4: Switch to the superuser account (root) and create a regular user account (lfs-user) for the build process. This will protect your existing account profile. Copy the contents of example/lfs from the repository to the lfs-user home subdirectory.

Step 5: Switch back to your account.

Step 6: Switch to the previously created regular user account lfs-user.

Step 8: Make the subdirectory ./lfs the current default subdirectory.

Step 9: List the contents of the subdirectory.

Step 10: Edit the configuration file (absf.cfg) to enable the MBE and SITE stages by removing the hash symbol (#) from those entries of
STAGES="#MBE #SITE #GROUNDBREAKING #FOUNDATION #BOOTABLE". Initially, only remove the hash symbol from MBE until you confirm the minimal build is successful.

Step 11: Verify the changes to the configuration file.

Step 12: Execute absf.sh. Enter the superuser account (root) password if prompted.

Stage: MBE - Minimal Build Environment (MBE)

Password: 

Preparing the build environment

Setting up the partition scheme
Setting up build environment
Creating subdirectory hierarchy

Filesystem Hierarchy Standard (FHS 2.3)
...installing directory structure on /mnt/lfs

Creating workspace for MBE
Extracting LFS packages from ../lfs-packages-6.3.tar
Changing ownership to lfs user

Processing package binutils-2.17.static.build
at Sat Mar 15 14:12:39 ADT 2004
...cleaning
...unpacking
...configuring
...compiling
...installing
...cleaning

...

Processing package util-linux-2.12r.build
at Sat Mar 15 21:08:55 Local time zone must be set--see zic manual page 2004
...cleaning
...unpacking
...configuring
...compiling
...installing
...cleaning
Changing ownership to super user (root)
Password:

Stage: SITE - Access build site(SITE)

Password:

Access build site (/tools) as user root
I have no name!:/#


Step 13: List the contents of the root (/) subdirectory.

Step 14: Make the subdirectory /tools the current default subdirectory.

Step 15: List the contents of the /tools subdirectory.

Step 16: Make the subdirectory /tools/root the current default subdirectory.

Step 17: List the contents of the /tools/root subdirectory.

Step 18: Unpack the archive into a subdirectory to which the superuser account (root) has write permission.

Step 19: List the contents of the /tools/root subdirectory.

Step 20: Make the subdirectory ./igloo the current default subdirectory.

Step 21: Verify the the configuration file (igloo.cfg) has been updated as follows:
1. The MBE stage and SITE stage have been disabled by adding a hash symbol (#) to STAGES="#MBE #SITE #GROUNDBREAKING #FOUNDATION #BOOTABLE".
2. The GROUNDBREAKING stage has been enabled by removing the hash symbol (#) from STAGES="#MBE #SITE #GROUNDBREAKING #FOUNDATION #BOOTABLE".
3. The LFS and LFS_ROOT environment variables have been changed from /tool to /.

Step 22: Verify the symbolic link (sh_root) now points to /tools instead of /.

Step 23: Execute absf.sh.


Stage: GROUNDBREAKING - Groundbreaking

Creating subdirectory hierarchy...
bash-3.2# 

Step 24: Verify the the configuration file (igloo.cfg) has been updated as follows:
1. The GROUNDBREAKING stage has been disabled by adding a hash symbol (#) to STAGES="#MBE #SITE #GROUNDBREAKING #FOUNDATION #BOOTABLE".
2. The FOUNDATION stage has been enabled by removing the hash symbol (#) from STAGES="#MBE #SITE #GROUNDBREAKING #FOUNDATION #BOOTABLE".

Step 25: Execute absf.sh.

Stage: FOUNDATION - Foundation

Pouring the foundation...

Processing package linux-2.6.22.5.build
at Sat Mar 15 21:24:51 Local time zone must be set--see zic manual page 2004
...cleaning
...unpacking
...installing
...cleaning

...

Processing package vim-7.1.build
at Sat Mar 15 21:29:56 ADT 2004
...cleaning
...unpacking
...patching
...configuring
...compiling
...installing
...cleaning

Step 26: Edit the configuration file (absf.cfg) to enable the BOOTABLE stage by removing the hash symbol (#) from that entry of
STAGES="#MBE #SITE #GROUNDBREAKING #FOUNDATION #BOOTABLE".

Step 27: Verify the changes to the configuration file.

Step 28: Execute absf.sh.

Stage: BOOTABLE - Make installed system bootable

Processing package lfs-bootscripts-6.3.build
at Sun Mar 16 12:08:54 ADT 2004
...cleaning
...unpacking
...installing
...cleaning

Processing package linux-2.6.22.5.build
at Sun Mar 16 12:08:54 ADT 2004
...cleaning
...unpacking
...configuring

Note: Simply choose 'Exit' to accept the default kernel configuration which has been used to test ABSF.


...compiling
...installing
...cleaning

Step 29: Make the system bootable using Grand Unified Boot Loader (GRUB). The sample /boot/grub/menu.lst is provided for illustrative purposes and does not cover all possible configurations.

Step 30: The File Hierarchy Standard (FHS) mandates that a symbolic link be provided for /boot/grub from /etc/grub.

Step 31: Now exit the Igloo Builder system and reboot the host computer after updating the boot loader of the host system to included an entry for the newly built system.

Step 32. Reboot the computer system. If everything works properly you should be able to choose your freshly built operating system.
