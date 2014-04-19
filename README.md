## ABSF: Automated Build System Framework for Linux From Scratch
(version 1.0)


Automated Build System Framework (ABSF) is a suite of UNIX shell scripts (BASH) to automate the building, in stages, of a GNU/Linux distribution.
Firstly, a minimal build environment (MBE) is constructed; think of the minimal build environment as the toolbox needed by the system builder.
Secondly, the building site is prepared in two steps: gain ownership of the building site and break ground. Thirdly, the foundation is laid upon
which the system builder can later construct the remainder of the system to the builder's preferences. Finally, the system is made bootable.

While reading an article, by Daniel Robbins, the inspiration to develop a UNIX shell script-driven automated build system for a GNU/Linux
distribution germinated. The traditional configure, compile, and install sequence for source code builds, by itself, lacked sufficient structure
to separate implementation details from the envisioned generic building plans. Therefore, the core of Automated Build System Framework
was structured to emulate the stages of construction at a real world building project. However, a reference build was needed to validate the
output of Automated Build System Framework. Fortunately, the Linux From Scratch (http://www.linuxfromscratch.org) created Gerard Beekmans was
well-established and provided an excellent introduction to building, entirely from source code, a complete bootable GNU/Linux system.

In summary, Automated Build System Framework is a development framework which provides the means to produce a highly-customizable GNU/Linux
distribution. Hopefully, Automated Build System Framework proves useful as both a means of learning about development of a GNU/Linux
distribution and more generally as an introduction to using BASH for moderately complex software projects.
