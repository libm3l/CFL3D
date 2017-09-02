PROJ_ROOT_PATH=/home/jka/CFL3D//
MAKEDEPEND=/home/jka/CFL3D/python_dep/fort_depend.py
FLLLOC = /home/jka/OSS_CFD/exec/
VERBOSE=-vvv



FTN          = gfortran
FFLAG        = -g -O2 -fdefault-real-8 -fdefault-double-8 -fbacktrace 
FFLAG_SPEC   = -g -O2 -fdefault-real-8 -fdefault-double-8 -fbacktrace 
PREC         =
PREC_MPI     = -DDBLE_PRECSN
LFLAG        = -g -O2 -fdefault-real-8 -fdefault-double-8 -fbacktrace
CPP          = cpp
CPPFLAG      = -P
CPPOPT       =  $(MPI_INCDIR) -DDIST_MPI $(PREC_MPI)
CPPOPT_SP    = -DP3D_SINGLE -DLINUX -DINTEL $(PREC_MPI) $(CGNS_INCDIR)
CPPOPT_CMPLX = -DCMPLX
FTN          = mpif90
CC           = mpicc

FCMODINCFLAG = -I


