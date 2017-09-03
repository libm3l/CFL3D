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
include src_dir_path.mk
include ../config.mk

FMODDIRS  = $(FLLLOC)

SUBDIR_COMP = \
	libs\
	seq \
	mpi

SUBDIRS= \
	libs\
	dist
	
EXEC = SEQ

###########################################################################

all: $(SUBDIR_COMP:%=%.all) $(EXEC).x  $(if $(strip $(MPI_FTN)), $(MPIEXE).x  $(MPIEXE)) 
include ../../rules.mk

#seq.all: libs.all
#mpi.all: libs.all

$(EXEC).x: $(srcdir)/main.F $(wildcard libs/*.o seq/*.o)
	echo Serial version
	cp $(srcdir)/main.F  main.F
	$(FTN) -c $(FFLAGS) $(FMODDIRS:%=$(FCMODINCFLAG)%) main.F 
	$(FTN) $(LFLAGS) -o cfl3d_seq  main.o libs/*.o  seq/*.o $(FLLLOC)/*.o
	@echo '************************************************'
	@echo '*'
	@echo '* sequential complex version of CFL3D built successfully!'
	@echo '*'
	@echo '************************************************'
	rm main.o
	
$(MPIEXE).x:   $(srcdir)/main.F $(wildcard libs/*.o mpi/*.o)
	cp $(srcdir)/main.F  main.F
	$(MPI_FTN) -c $(FFLAGS) $(FMODDIRS:%=$(FCMODINCFLAG)%) main.F 
	$(MPI_FTN) $(MPI_LFLAGS) -o cfl3d_mpi  main.o libs/*.o  mpi/*.o $(FLLLOC)/*.o
	@echo '************************************************'
	@echo '*'
	@echo '* MPI complex version of CFL3D built successfully!'
	@echo '*'
	@echo '************************************************'
	rm main.o


clean: $(SUBDIR_COMP:%=%.clean)
	rm -f *.x *.o *.mod cfl3d_mpi  cfl3d_seq 

depend: $(SUBDIRS:%=%.depend)

install: $(SUBDIR_COMP:%=%.install)
