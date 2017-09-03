#
#     Copyright (C) 2016  Adam Jirasek
# 
#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU Lesser General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
# 
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU Lesser General Public License for more details.
# 
#     You should have received a copy of the GNU Lesser General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.
#     
#     contact: libm3l@gmail.com
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
	cp $(srcdir)/main.F  main.F
	$(FTN) -c $(FFLAGS) $(FMODDIRS:%=$(FCMODINCFLAG)%) main.F 
	$(FTN) $(LFLAGS) -o cfl3d_seq main.o libs/*.o  seq/*.o $(FLLLOC)/*.o
	@echo '************************************************'
	@echo '*'
	@echo '* sequential complex version of CFL3D built successfully!'
	@echo '*'
	@echo '************************************************'
	rm main.o
	
$(MPIEXE).x:   $(srcdir)/main.F $(wildcard libs/*.o mpi/*.o)
	cp $(srcdir)/main.F  main.F
	$(MPI_FTN) -c $(FFLAGS) $(FMODDIRS:%=$(FCMODINCFLAG)%) main.F 
	$(MPI_FTN) $(MPI_LFLAGS) -o cfl3d_mpi main.o libs/*.o  mpi/*.o $(FLLLOC)/*.o
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
