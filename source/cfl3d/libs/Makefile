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

include src_dir_path.mk
include ../../../config.mk

DEP_FILE=depend.mk

FMODDIRS= ../libs

FFILES= $(notdir $(wildcard $(srcdir)/*.F))


OFILES=$(FFILES:%.F=%.o)
XOFILES=$(wildcard ../../data_util/*.o)

###########################################################################


include ../../../rules.mk

depend: $(FFILES)
	@echo "Making dependencies!"
	cd $(srcdir) && $(MAKEDEPEND) -r $(PROJ_ROOT_PATH) $(VERBOSE) -w -o $(srcdir)/$(DEP_FILE) -d $(FMODDIRS) -f $(FFILES)

	sed -i 's|source/cfl3d|build/cfl|' depend.mk

-include $(srcdir)/$(DEP_FILE)

