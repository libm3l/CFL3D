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

SUBDIRS= \
	cfl3d\
	maggie\
	precfl3d\
	ronnie\
	splitter\
	tools


SUBDIRS_CMP = \
       cfl3d\
       cflcmplx\
       maggie\
       precfl3d\
       preron\
       ronnie\
       splitter\
       splitcmplx\
       tools
       
	

###########################################################################

include ../rules.mk


all: $(SUBDIRS_CMP:%=%.all) 

maggie.all: cfl3d.all
precfl3d.all: cfl3d.all
precfl3d.all: cfl3d.all
preron.all: cfl3d.all
ronnie.all: cfl3d.all
splitter.all: cfl3d.all
splitcmplx.all: cfl3d.all
tools.all: cfl3d.all


cfl3d:

clean: $(SUBDIRS_CMP:%=%.clean)

depend: $(SUBDIRS:%=%.depend)

install: $(SUBDIRS_CMP:%=%.install)
