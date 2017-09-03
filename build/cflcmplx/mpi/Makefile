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
include ../../config.mk

# Use MPI compilation in this file
FTN          =$(MPI_FTN)
FFLAGS :=$(MPI_FFLAGS) $(FINCFLAGS)
LFLAGS :=$(MPI_LFLAGS)

DEP_FILE=depend.mk

FMODDIRS= $(FLLLOC)
FMODDIRS+=../libs

FCMODINCFLAG = -I

FFILES  =  $(notdir $(wildcard $(srcdir)/*.F))
FFILES+= $(notdir $(wildcard $(srcdir)/*.F90))

OFILES1  =$(FFILES:.F=.o)
OFILES   =$(OFILES1:.F90=.o)

XOFILES+=$(wildcard ../libs/*.o)
XOFILES+=$(wildcard $(FLLLOC)/*.o)

###########################################################################

all: $(OFILES)
include ../../../rules.mk

clean:
	rm -f *.x *.o *.mod 

depend: $(FFILES)
	@echo "Making dependencies!"
	echo $(srcdir)
	echo $(FFILES)
	cd $(srcdir) && $(MAKEDEPEND) -r  $(PROJ_ROOT_PATH) -d $(FMODDIRS)  $(VERBOSE) -w -o $(srcdir)/$(DEP_FILE) -f $(FFILES)


install: $(EXE).x $(EXE).py
	$(INSTALL) $(EXE).x $(bin_dir)/$(EXE)$(POSTFIX).x
	$(INSTALL) $(EXE).py $(bin_dir)/$(EXE)$(POSTFIX).py

-include $(srcdir)/$(DEP_FILE)

