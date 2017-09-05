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
include config.mk

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
       
SUBDIRS_CFL3D = cfl3d	
SUBDIRS_CFL3DCMPX = cfl3dcmplx	

SUBDIRS_MAG = maggie cfl3d/libs   cfl3d/seq
SUBDIRS_PRECF = precfl3d cfl3d/libs   cfl3d/seq
SUBDIRS_PRER = preron cfl3d/libs   cfl3d/seq
SUBDIRS_RON = ronnie cfl3d/libs   cfl3d/seq
SUBDIRS_SPLITT = splitter cfl3d/libs   cfl3d/seq
SUBDIRS_SPLIC = splitcmplx cfl3d/libs   cfl3d/seq
SUBDIRS_TOOLS = tools cfl3d/libs   cfl3d/seq

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


cfl3d: $(SUBDIRS_CFL3D:%=%.all) 

cfl3dcmplx: $(SUBDIRS_CFL3DCMPX:%=%.all) 

maggie: $(SUBDIRS_MAG:%=%.all) 
maggie.all: cfl3d/libs.all cfl3d/seq.all

precfl3d: $(SUBDIRS_PRECF:%=%.all) 
precfl3d.all: cfl3d/libs.all cfl3d/seq.all

preron: $(SUBDIRS_PRER:%=%.all) 
preron.all: cfl3d/libs.all cfl3d/seq.all

ronnie: $(SUBDIRS_RON:%=%.all) 
ronnie.all: cfl3d/libs.all cfl3d/seq.all

splitter: $(SUBDIRS_SPLITT:%=%.all) 
splitter.all: cfl3d/libs.all cfl3d/seq.all

splitcmplx: $(SUBDIRS_SPLITC:%=%.all) 
splitcmplx.all: cfl3d/libs.all cfl3d/seq.all

tools: $(SUBDIRS_TOOLS:%=%.all) 
tools.all:  cfl3d/libs.all cfl3d/seq.all

clean: $(SUBDIRS_CMP:%=%.clean)

depend: $(SUBDIRS:%=%.depend)

install: $(SUBDIRS_CMP:%=%.install)
