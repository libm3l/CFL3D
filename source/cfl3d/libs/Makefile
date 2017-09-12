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
include ../../config.mk

DEP_FILE=depend.mk

FMODDIRS=  $(EFMODDIRS)

ifneq ($(strip $(FMODDIRS)),)
  PYDEPDYRS = -d $(FMODDIRS) 
endif


FCMODINCFLAG = -I

FFILES  =  $(notdir $(wildcard $(srcdir)/*.F))
FFILES+= $(notdir $(wildcard $(srcdir)/*.F90))
FFILES+= $(notdir $(wildcard $(srcdir)/*.c))


OFILES1  =$(FFILES:.F=.o)
OFILES2   =$(OFILES1:.F90=.o)
OFILES   =$(OFILES2:.c=.o)

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
	DEP_FILE=depend_cmplx.mk
endif 


###########################################################################

all:  $(OFILES)
include ../../../rules.mk

clean:
	rm -f *.x *.o *.mod 
	find ./ -executable -type f | xargs rm -f

depend: $(FFILES)
	@echo "Making dependencies!"
	cd $(srcdir) && $(MAKEDEPEND) -r  $(PROJ_ROOT_PATH) $(PYDEPDYRS)  $(VERBOSE) -w -o $(srcdir)/$(DEP_FILE) -f $(FFILES) && cp depend.mk depend_cmplx.mk && sed -i 's|cfl3d/|cflcmplx/|g' depend_cmplx.mk


install: $(SUBDIRS:%=%.install)


-include $(srcdir)/$(DEP_FILE)
