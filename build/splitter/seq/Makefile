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

EXE    = splitter

include src_dir_path.mk
include ../../config.mk

DEP_FILE=depend.mk

FMODDIRS= ../../cfl3d/seq  ../../cfl3d/libs
OFMODDIRS1 = $(wildcard ../../cfl3d/seq/*.o  ../../cfl3d/libs/*.o)

OFMODDIRS2= $(filter-out ../../cfl3d/seq/usrint.o, $(OFMODDIRS1))
OFMODDIRS4= $(filter-out ../../cfl3d/seq/sizer.o, $(OFMODDIRS2))
#OFMODDIRS4= $(filter-out ../../cfl3d/seq/setup.o, $(OFMODDIRS3))
OFMODDIRS5 = $(filter-out ../../cfl3d/seq/termn8.o, $(OFMODDIRS4))
OFMODDIRS6 = $(filter-out ../../cfl3d/libs/getdhdr.o, $(OFMODDIRS5))
OFMODDIRS = $(filter-out ../../cfl3d/seq/cfl3d.o, $(OFMODDIRS6))



FCMODINCFLAG = -I

FFILES  =  $(notdir $(wildcard $(srcdir)/*.F))
FFILES+= $(notdir $(wildcard $(srcdir)/*.F90))

OFILES1  =$(FFILES:.F=.o)
OFILES   =$(OFILES1:.F90=.o)

###########################################################################

all: $(EXE).x 

include ../../../rules.mk

$(EXE).x: $(OFILES) $(XOFILES)
	-rm main.o main_cmplx.o
	$(FTN) $(LDFLAGS) -o $(EXE)  $(srcdir)/main.F *.o  $(OFMODDIRS)


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

