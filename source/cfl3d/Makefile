# ---------------------------------------------------------------------------
# CFL3D is a structured-grid, cell-centered, upwind-biased, Reynolds-averaged
# Navier-Stokes (RANS) code. It can be run in parallel on multiple grid zones
# with point-matched, patched, overset, or embedded connectivities. Both
# multigrid and mesh sequencing are available in time-accurate or
# steady-state modes.
#
# Copyright 2001 United States Government as represented by the Administrator
# of the National Aeronautics and Space Administration. All Rights Reserved.
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

FMODDIRS  = $(EFMODDIRS)

SUBDIR_COMP = \
	libs\
	seq\

ifneq ($(strip $(MPI_FTN)),)
  SUBDIR_COMP+= mpi
endif


SUBDIRS= \
	libs\
	dist

EXE_SEQ = cfl3d_seq
EXE_MPI = cfl3d_mpi

#
# Use MPI compilation if required
#
DIR = $(PWD)

ifneq (,$(findstring mpi,$(DIR)))
	FTN          =$(MPI_FTN)
	FFLAGS :=$(MPI_FFLAGS) $(FINCFLAGS)
	LFLAGS :=$(MPI_LFLAGS)
	DOPTS   +=  DIST_MPI
endif 
#
# Use complex version  compilation if required
#
ifneq (,$(findstring cmplx,$(DIR)))
	DOPTS   +=  CMPLX
	EXE_SEQ = cfl3d_cmplx_seq
	EXE_MPI = cfl3d_cmplx_mpi
endif

FMODDIRS  =  $(EFMODDIRS)
	
EXEC = SEQ

COMPILETIME :=$(shell date || echo Unknown time )
BUILDSYSTEM :=$(shell echo `uname -s`-`uname -m` || echo Unknown system )
BUILDHOST   :=$(shell echo `hostname` || echo Unknown host )
BUILDUSER   :=$(USER)
BKERNEL     :=$(shell echo `uname -o`-`uname -r` || echo Unknown kernel )
BFORT       :=$(shell echo `$(FTN) --version | head -n 1  `|| echo Unknown fortran )
BC          :=$(shell echo `$(CC)  --version | head -n 1  `|| echo Unknown fortran )
BFORTMPI    :=$(shell echo `$(MPI_FTN) --version | head -n 1  `|| echo Unknown fortran )
BCMPI       :=$(shell echo `$(CC)  --version | head -n 1  `|| echo Unknown fortran )



###########################################################################

all: $(SUBDIR_COMP:%=%.all) $(EXEC).x  $(if $(strip $(MPI_FTN)), $(MPIEXE).x ) 
include ../../rules.mk

seq.all: libs.all
mpi.all: libs.all

$(EXEC).x: $(srcdir)/main.F $(wildcard libs/*.o seq/*.o)
	sed -e "s|COMPILETIME|$(COMPILETIME)|g" \
	    -e "s|BUILDHOST|$(BUILDHOST)|g" \
	    -e "s|BUILDSYSTEM|$(BUILDSYSTEM)|g" \
	    -e "s|BUILDUSER|$(BUILDUSER)|g" \
	    -e "s|BUILDFC|$(BFORT)|g" \
	    -e "s|BUILDCC|$(BC)|g" \
	    -e "s|BKERNEL|$(BKERNEL)|g" \
	    $(srcdir)/main.F > main.F

	$(FTN) -c $(FFLAGS) $(FMODDIRS:%=$(FCMODINCFLAG)%) $(DOPTS:%=-D%) main.F 
	$(FTN) $(LFLAGS) -o $(EXE_SEQ).x main.o libs/*.o  seq/*.o $(LIBS)

	@echo '************************************************'
	@echo '*'
	@echo '* sequential complex version of CFL3D built successfully!'
	@echo '*'
	@echo '************************************************'
	rm main.o
	
$(MPIEXE).x:   $(srcdir)/main.F $(wildcard libs/*.o mpi/*.o)
	sed -e "s|COMPILETIME|$(COMPILETIME)|g" \
	    -e "s|BUILDHOST|$(BUILDHOST)|g" \
	    -e "s|BUILDSYSTEM|$(BUILDSYSTEM)|g" \
	    -e "s|BUILDUSER|$(BUILDUSER)|g" \
	    -e "s|BUILDFC|$(BFORTMPI)|g" \
	    -e "s|BUILDCC|$(BCMPI)|g" \
	    -e "s|BKERNEL|$(BKERNEL)|g" \
	    $(srcdir)/main.F > main.F

	$(MPI_FTN) -c $(FFLAGS) $(FMODDIRS:%=$(FCMODINCFLAG)%) $(DOPTS:%=-D%) -DDIST_MPI main.F 
	$(MPI_FTN) $(MPI_LFLAGS) -o $(EXE_MPI).x main.o libs/*.o  mpi/*.o $(LIBS)

	@echo '************************************************'
	@echo '*'
	@echo '* MPI complex version of CFL3D built successfully!'
	@echo '*'
	@echo '************************************************'
	rm main.o


clean: $(SUBDIR_COMP:%=%.clean)
	rm -f *.x *.o *.mod
	find ./ -executable -type f | xargs rm -f

depend: $(SUBDIRS:%=%.depend)

install:
	$(INSTALL) $(EXE_SEQ).x  $(bin_dir)/$(EXE_SEQ).x
	$(INSTALL) $(EXE_MPI).x  $(bin_dir)/$(EXE_MPI).x

