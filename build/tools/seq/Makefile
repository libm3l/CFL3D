# ---------------------------------------------------------------------------
# CFL3D is a structured-grid, cell-centered, upwind-biased, Reynolds-averaged
# Navier-Stokes (RANS) code. It can be run in parallel on multiple grid zones
# with point-matched, patched, overset, or embedded connectivities. Both
# multigrid and mesh sequencing are available in time-accurate or
# steady-state modes.
#
# Copyright 2001 United States Government as represented by the Administrator
# of the National Aeronautics and Space Administration. All Rights Reserved.
# 
# The CFL3D platform is licensed under the Apache License, Version 2.0 
# (the "License"); you may not use this file except in compliance with the 
# License. You may obtain a copy of the License at 
# http://www.apache.org/licenses/LICENSE-2.0. 
#
# Unless required by applicable law or agreed to in writing, software 
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
# License for the specific language governing permissions and limitations 
# under the License.
# ---------------------------------------------------------------------------
#
#
#
# Description: Makefile 
#
# 
# History:
# Version   Date       Author              Patch number  CLA     Comment
# -------   --------          --------               ----------------    -----      -------------
# 1.1       01/09/17     Adam Jirasek                                        Initial implementation
#
#
#

EXEC1  = grid_perturb_cmplx
EXEC2  = grid_perturb
EXEC3  = Get_FD
EXEC4  = moovmaker
EXEC5  = plot3dg_to_cgns
EXEC6  = XINTOUT_to_ovrlp
EXEC7  = p3d_to_INGRID
EXEC8  = INGRID_to_p3d
EXEC9  = cfl3d_to_pegbc
EXEC10 = everyother_xyz
EXEC11 = initialize_field
EXEC12 = p3d_to_cfl3drst
EXEC13 = v6_restart_mod
EXEC14 = v6inpdoubhalf
EXEC15 = cgns_to_cfl3dinput
EXEC16 = cgns_readhist
EXEC17 = v6_ronnie_mod
EXEC18 = cfl3d_to_nmf
EXEC19 = cfl3dinp_to_FVBND
EXEC20 = nmf_to_cfl3dinput
EXEC21 = gridswitchijk
EXEC22 = v6inpswitchijk

include src_dir_path.mk
include ../../config.mk

DEP_FILE=depend.mk

FMODDIRS= ../../cfl3d/seq  ../../cfl3d/libs

OFMODDIRS=   ../../cfl3d/seq/umalloc_r.o\
        ../../cfl3d/seq/umalloc_c.o\
        ../../cfl3d/libs/my_flush.o\
        ../../cfl3d/seq/termn8.o\
	../../cfl3d/libs/readkey.o\
        ../../cfl3d/libs/global0.o\
        ../../cfl3d/libs/parser.o\
        ../../cfl3d/libs/outbuf.o\
        ../../cfl3d/libs/cgnstools.o 


FCMODINCFLAG = -I

FFILES  =  $(notdir $(wildcard $(srcdir)/*.F))
FFILES+= $(notdir $(wildcard $(srcdir)/*.F90))

OFILES1  =$(FFILES:.F=.o)
OFILES   =$(OFILES1:.F90=.o)

###########################################################################

all: $(EXE).x 

include ../../../rules.mk

$(EXE).x:
	$(FTN) $(LDFLAGS) -o $(EXEC1)  $(srcdir)/$(EXEC1).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC2)  $(srcdir)/$(EXEC2).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC3)  $(srcdir)/$(EXEC3).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC4)  $(srcdir)/$(EXEC4).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC5)  $(srcdir)/$(EXEC5).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC6)  $(srcdir)/$(EXEC6).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC7)  $(srcdir)/$(EXEC7).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC8)  $(srcdir)/$(EXEC8).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC9)  $(srcdir)/$(EXEC9).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC10)  $(srcdir)/$(EXEC10).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC11)  $(srcdir)/$(EXEC11).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC12)  $(srcdir)/$(EXEC12).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC13)  $(srcdir)/$(EXEC13).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC14)  $(srcdir)/$(EXEC14).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC15)  $(srcdir)/$(EXEC15).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC16)  $(srcdir)/$(EXEC16).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC17)  $(srcdir)/$(EXEC17).F90    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC18)  $(srcdir)/$(EXEC18).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC19)  $(srcdir)/$(EXEC19).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC20)  $(srcdir)/$(EXEC20).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC21)  $(srcdir)/$(EXEC21).F    $(OFMODDIRS)
	$(FTN) $(LDFLAGS) -o $(EXEC22)  $(srcdir)/$(EXEC22).F    $(OFMODDIRS)


clean:
	rm -f *.x *.o *.mod $(EXEC)

depend: $(FFILES)
	@echo "Making dependencies!"
	echo $(srcdir)
	echo $(FFILES)
	cd $(srcdir) && $(MAKEDEPEND) -r  $(PROJ_ROOT_PATH) $(VERBOSE) -w -o $(srcdir)/$(DEP_FILE) -f $(FFILES)


install: $(EXE).x $(EXE).py
	$(INSTALL) $(EXE).x $(bin_dir)/$(EXE)$(POSTFIX).x
	$(INSTALL) $(EXE).py $(bin_dir)/$(EXE)$(POSTFIX).py

-include $(srcdir)/$(DEP_FILE)

