#    ---------------------------------------------------------------------------
#    CFL3D is a structured-grid, cell-centered, upwind-biased, Reynolds-averaged
#    Navier-Stokes (RANS) code. It can be run in parallel on multiple grid zones
#    with point-matched, patched, overset, or embedded connectivities. Both
#    multigrid and mesh sequencing are available in time-accurate or
#    steady-state modes.
#
#    Copyright 2001 United States Government as represented by the Administrator
#    of the National Aeronautics and Space Administration. All Rights Reserved.
# 
#    The CFL3D platform is licensed under the Apache License, Version 2.0 
#    (the "License"); you may not use this file except in compliance with the 
#    License. You may obtain a copy of the License at 
#    http://www.apache.org/licenses/LICENSE-2.0. 
# 
#    Unless required by applicable law or agreed to in writing, software 
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
#    License for the specific language governing permissions and limitations 
#    under the License.
#    ---------------------------------------------------------------------------
# 
#
#
# Description: Makefile 
#
# 
# History:
# Version   Date       Patch number  CLA     Comment
# -------   --------   --------      ---     -------
# 1.1       10/10/16                         Initial implementation
#
#
#

include config.mk

SUBDIRS= \
        source\


###########################################################################

include rules.mk

depend: $(SUBDIRS:%=%.depend)

init:
	echo PROJ_ROOT_PATH=$(PWD) > config.mk
	echo MAKEDEPEND=$(PWD)/python_dep/fort_depend.py >> config.mk
	echo VERBOSE=-vvv >> config.mk
	echo FLLLOC = /home/jiraseka/LL/fll_exec



