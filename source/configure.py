#!/usr/bin/python
#  CFL3D is a structured-grid, cell-centered, upwind-biased, Reynolds-averaged
#  Navier-Stokes (RANS) code. It can be run in parallel on multiple grid zones
#  with point-matched, patched, overset, or embedded connectivities. Both
#  multigrid and mesh sequencing are available in time-accurate or
#  steady-state modes.
#
#  Copyright 2001 United States Government as represented by the Administrator
#  of the National Aeronautics and Space Administration. All Rights Reserved.
# 
#  The CFL3D platform is licensed under the Apache License, Version 2.0 
#  (the "License"); you may not use this file except in compliance with the 
#  License. You may obtain a copy of the License at 
#  http://www.apache.org/licenses/LICENSE-2.0. 
# 
#  Unless required by applicable law or agreed to in writing, software 
#  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
#  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
#  License for the specific language governing permissions and limitations 
#  under the License. 
#
# History:
# Version   Date       Author        Patch number  CLA  Comment
# -------   --------   --------      ------------  ---  -------
# 1.1       01/09/17   Adam Jirasek                     Rewrite original version
#
#
#
#
import os
import re
import glob
import fnmatch
import os
import sys
import errno
import copy
import platform
import tarfile
import shutil
import getpass
import time
from time import gmtime, strftime
#Definitions

def run(comp,build,execd,fll,cgns_dir,force=None, overwrite=None, init=None):
#
#  definition of parameters
#
    print_header()
    linkfiles =(['src_dir_path.mk', 'Makefile', 'depend.mk'])
    exclude =(['python_dep', 'config', '.git', '.svn'])     
#
#   get path of the source files, found from location of this script which is located in the root
#   directory of the source code
#
    path = os.path.dirname(os.path.abspath(__file__))
#
#   get current directory
#
    cwd = os.getcwd()
#
#  check if FLL exist
#
    fll_abspath = check_path(path=fll)
    fll_abspath = fll_abspath + 'data_util/'
#
#   if path for source does not exit, terminate
#
    path = check_path(path=path)
    if not os.path.isdir(path):
      print("  ")
      print("\033[031mERROR:\033[039m specified project source location \033[032m"+path+"\033[039m does not exist, terminating .... ") 
      
    cwd = check_path(path=cwd)
    
    if init:
#
#   initializing - developer
#
        if cwd == path:
           config_init(path=path, fll=fll, overwrite=overwrite)
        else:
            print("  ")
            print("\033[031mDIAG:\033[039m ./configure.py must be invoked from CFL3D/source directory:  \033[032m"+path+" \033[039m")  	
            print("\033[031mDIAG:\033[039m your current location is          \033[032m"+cwd+"\033[039m")  	
            print("       terminating .... ") 	
            
            
        sys.exit()

    print("  ")
    print("\033[031mDIAG:\033[039m project location is                  \033[032m"+path+"\033[039m")  	
    print("\033[031mDIAG:\033[039m Intended location of compillation is \033[032m"+cwd+"\033[039m")    
#
#   if pathe to source and path to location of compilation directory are the same
#   terminate, do not allow compilation in the source code directory
#
    if cwd == path:
        print(".....")
        print ("\033[031mError:\033[039m project location is the same as inteded location of compillation \033[032m"+path+"\033[039m")  	
        print ("\033[031m      \033[039m choose different location \033[032m"  "\033[039m")
        print("       terminating .... ") 	
        sys.exit()
#
#  cchek if FLL exist
#
    if not os.path.isdir(fll_abspath):
      print("  ")
      print("\033[031mERROR:\033[039m specified location of FLL libary \033[032m"+fll_abspath+"\033[039m does not exist, terminating .... ")
      print("       terminating .... ") 
      sys.exit()
#
#  creating config file
#
    print("  ")
    print("\033[031mDIAG:\033[039m creating configure file \033[032m \033[039m")  	
    print("  ")
#
#  make build directory where all executables will be located
#
    clean = None
    clean = False
    try:
          os.makedirs(build)
    except OSError as e:
         if e.errno != errno.EEXIST:
            raise  # raises the error again
         else:
           if(force):
             print ("\033[031mDIAG:\033[039m given build location already exist: \033[032m"+os.path.abspath(build)+"\033[039m")  	
             print ("\033[031m      \033[039m adding up to existing installation .... \033[032m"  "\033[039m") 
           elif(overwrite):
             print ("\033[031mDIAG:\033[039m given build location already exist: \033[032m"+os.path.abspath(build)+"\033[039m")  	
             print ("\033[031m      \033[039m cleaning up and making new installation .... \033[032m"  "\033[039m")             
             clean = True
           else:
             print ("\033[031mError:\033[039m given build location already exist: \033[032m"+os.path.abspath(build)+"\033[039m")  	
             print ("\033[031m      \033[039m choose different build location or\033[032m"  "\033[039m")
             print ("\033[031m      \033[039m use options \033[032m '-f' '--force' \033[039m or \033[032m '-o' '--overwrite' \033[039m")
             print("       terminating .... ")
             sys.exit()
#
#  got to build directory
#
    build_path = os.path.abspath(build)

    if(clean):
        print("\033[031mDIAG:\033[039m cleaning up existing installation ....  \033[039m")  	
        shutil.rmtree(build_path)
        os.makedirs(build_path)

    os.chdir(build_path)
#
#  specify exec directory where all executables will be located
#
    print("Specified exec is "+execd)
    if execd == '':
      print("  ")
      print("\033[031mDIAG:\033[039m Bild directory not specified, setting it to \033[032m "+build_path+platform.machine()+"/bin\033[039m")  	
      print("  ")
      exec_dir=build_path+'/'+platform.machine()+'/bin'
    else:
      exec_dir=execd

    print(exec_dir)
#
#  untar build_template.tar
#
    tarpath = path.replace("source/", "")
    fname =tarpath + "build_template.tar"
  
    print("  ")
    print("\033[031mDIAG:\033[039m untaring build template file \033[032m"  +fname + "\033[039m")  	
    print("  ")
    
    tar = tarfile.open(fname)
    tar.extractall()
    tar.extractall()
#
#  create configuration file config.mk
#
    ok = mkconfigfile(path=tarpath, cwd=build_path,version=comp,fll=fll_abspath,fll_lib=fll,exec_dir=exec_dir,cgns_dir=cgns_dir)
#
#  make exec directory
#
    if not os.path.isdir(exec_dir):
      print("  ")
      print("\033[031mDIAG:\033[039m Creating exec directory \033[032m"+exec_dir+"\033[039m .... ")
      os.makedirs(exec_dir)


def check_path(path):
    if not(path.endswith("/")):
        path=path + "/"

    return path

def config_init(path,fll, overwrite):

    fortdeppath = path.replace("source/", "")

    confname =  'config.mk'
    
    try:
        os.remove(confname)
        if(overwrite):
          print("  ")
          print ("\033[031mDIAG: \033[032m config.mk file \033[039m already exists")
          print ("\033[039m       removing and replacing by new config file ....")
          print("  ")
        else:
          print("  ")
          print ("\033[031mDIAG: \033[032m config.mk file \033[039m already exists")
          print ("\033[039m       do not create new config file, remove it or ")
          print ("\033[039m       specify option \033[032m-o  --overwrite \033[039m to overwrite by new config file")
          print ("\033[039m       terminating ....")
          print("  ")

    except OSError:
        pass
    
    fconfig = open(confname, 'w')    
#
#  header 
#
    username = getpass.getuser()
    fconfig.write("#\n")  
    fconfig.write("#  This file is created autimatically\n")
    fconfig.write("#\n")
    fconfig.write("#  Created by: "+username+"\n")
#    fconfig.write("#  Date: "+time.strftime("%d/%m/%Y")+"  "+time.strftime("%I:%M:%S")+"\n")
    fconfig.write("#  Date: "+strftime("%Y-%m-%d %H:%M:%S", gmtime()) + "\n")
    fconfig.write("#\n")
#
#  set some global parameters
#
    fconfig.write("#\n")  
    fconfig.write("#  CFL3D root directory\n")
    fconfig.write("#\n")
    fconfig.write("PROJ_ROOT_PATH="+path+"\n")
    fconfig.write("#\n")  
    fconfig.write("#  Python fortran dependency scritp location\n")
    fconfig.write("#\n")
    fconfig.write("MAKEDEPEND="+fortdeppath+"python_dep/fort_depend.py\n")
    fconfig.write("#\n")  
    fconfig.write("#  Python dependency verbosity\n")
    fconfig.write("#\n")
    fconfig.write("VERBOSE=-vvv\n")
    fconfig.write("#\n")
    fconfig.write("#  External modules\n")
    fconfig.write("#\n")
    fconfig.write("EFMODDIRS="+fll+"/data_util/\n")

    fconfig.close()




def mkconfigfile(path, cwd,version,fll,fll_lib,exec_dir,cgns_dir):
    filename = path+'/config/compset.'+version
    
    fortdeppath = path.replace("source/", "")


    if not(os.path.exists(filename)):
        print ("\033[031mError: \033[039m \033[031m"+version+"\033[039m verion of compiler is not available")
        print ("\033[031m       \033[039m available options are: \033[032m gfortran\033[039m")
        print ("\033[031m       \033[039m                        \033[032m gfortran_debug\033[039m")
        print ("\033[031m       \033[039m                        \033[032m x86_64\033[039m")
        print ("\033[031m       \033[039m                        \033[032m x86_64_debug\033[039m") 
        sys.exit()
            
    confname =  'config.mk'
    
    try:
        os.remove(confname)
        print ("\033[031mDIAG: \033[039m config.mk file \033[032m \033[039m already exists, removing ....")
    except OSError:
        pass
#
#  find FLL library location
#
    for root, dirnames, filenames in os.walk(fll_lib):
        if 'fll.a' in filenames:
            lpath = os.path.join(root, 'fll.a')
            break
    
    fconfig = open(confname, 'w')
#
#  header 
#
    username = getpass.getuser()
    fconfig.write("#\n")  
    fconfig.write("#  This file is created autimatically\n")
    fconfig.write("#\n")
    fconfig.write("#  Created by: "+username+"\n")
#    fconfig.write("#  Date: "+time.strftime("%d/%m/%Y")+"  "+time.strftime("%I:%M:%S")+"\n")
    fconfig.write("#  Date: "+strftime("%Y-%m-%d %H:%M:%S", gmtime()) + "\n")
    fconfig.write("#\n")
#
#  set some global parameters
#
    fconfig.write("#\n")  
    fconfig.write("#  CFL3D root directory\n")
    fconfig.write("#\n")
    fconfig.write("PROJ_ROOT_PATH="+path+"/source/\n")

    fconfig.write("#\n")  
    fconfig.write("#  Python fortran dependency scritp location\n")
    fconfig.write("#\n")
    fconfig.write("MAKEDEPEND="+fortdeppath+"python_de/fort_depend.py\n")

    fconfig.write("#\n")  
    fconfig.write("#  Python dependency verbosity\n")
    fconfig.write("#\n")
    fconfig.write("VERBOSE=-vvv\n")

    fconfig.write("#\n")    
    fconfig.write("SHELL  = /bin/bash\n")

    fconfig.write("#\n")
    fconfig.write("# Compiler settings\n")
    fconfig.write("#\n")
#
#  read config with compiler settings
#  and add to config file
#
    with open(filename) as f:
        for line in f:
           if ( not(line.startswith('#')) or not line.strip()): 
                print(line)
                fconfig.write(line)
    fconfig.write("#\n")
    fconfig.write("DOPTS= $(PREC_MPI)  $(MPI_INCDIR) $(SYSTEM) $(COMP) P3D_SINGLE\n")  
    fconfig.write("#\n")  
    fconfig.write("#  External modules location\n")
    fconfig.write("#\n")
    fconfig.write("EFMODDIRS="+ cgns_dir + " " +fll+"\n")  
    fconfig.write("#\n")
    fconfig.write("#  Libraries\n")
    fconfig.write("#\n")

    if(cgns_dir == ''):
    	fconfig.write("LIBS="+lpath+"\n")  
    else:
        fconfig.write("LIBS= -lcgns -lconfig "+lpath+"\n") 

    fconfig.write("#\n")
    fconfig.write("#  MACHINE identifies the host machine type\n")
    fconfig.write("#\n")
    fconfig.write("MACHINE="+platform.machine()+"\n")
    fconfig.write("#\n")
    fconfig.write("#  Install command (or cp -p if install is not found)\n")
    fconfig.write("#\n")
    fconfig.write("INSTALL = install -c\n")
    fconfig.write("#\n")
    fconfig.write("#  bin_dir is the base directory with installed executables\n")
    fconfig.write("#\n")
    fconfig.write('bin_dir='+exec_dir+"\n")

    f.close()
    fconfig.close()

    cwd = check_path(path=cwd)


def print_header():
     print("  ")
     print ("\033[031m**************************************************************** \033[039m")
     print ("\033[031m*                                                              * \033[039m")
     print ("\033[031m*\033[039m         this is a configure file for CFL3D  \033[031m            * \033[039m")
     print ("\033[031m*                                                              * \033[039m")
     print ("\033[031m**************************************************************** \033[039m")
#Script
if __name__ == "__main__":
    import argparse

    # Add command line arguments
    parser = argparse.ArgumentParser(description='CFL3D configure script')
    parser.add_argument('-b','--build',nargs=1,help='Build Directory (prepended to all files in output',
                        default='')
    parser.add_argument('-c','--compiler',nargs=1,help='Compiler configuration')
    parser.add_argument('-f','--force',action='store_true',help='Force updates to existing installation')
    parser.add_argument('-o','--overwrite',action='store_true',help='Overwrite existing installation')
    parser.add_argument('-L','--fll',nargs=1,help='Location of FLL utility')
    parser.add_argument('-i','--init',action='store_true',help='Initialize (only for developers)')
    parser.add_argument('-x','--executable',action='store_true',help='Location of executables')
    parser.add_argument('-C','--cgns',nargs=1,help='Location of cgns header files')

    # Parse the command line arguments
    args = parser.parse_args()

    init     = args.init if args.init else None
    build    = args.build[0] if args.build else ''
    compiler = args.compiler[0] if args.compiler else None
    fll = args.fll[0] if args.fll else ''
    execd    = args.executable[0] if args.executable else ''
    cgns_dir    = args.cgns[0] if args.cgns else ''
    
    if not init:
    
      if not compiler:
        print ("\033[031mError: \033[039m missing compiler settings, specify option \033[031m-c \033[032m")
        print ("\033[031m       \033[039m available options are: \033[032m gfortran\033[039m")
        print ("\033[031m       \033[039m                        \033[032m gfortran_debug\033[039m")
        print ("\033[031m       \033[039m                        \033[032m x86_64\033[039m")
        print ("\033[031m       \033[039m                        \033[032m x86_64_debug\033[039m") 
        sys.exit()
        
      if not build:
        print ("\033[031mError: \033[039m missing name of build directory,  specify option \033[031m-b \033[032m")
        sys.exit()
        
    if not fll:
        print ("\033[031mError: \033[039m missing location of FLL library,  specify option \033[031m-L \033[032m")
        print ("\033[031m       \033[039m FLL library is available for download at \033[032m https://gthub.com/libm3l/fll \033[039m")
        sys.exit()
        
    else:
        print ("\033[031mError: \033[039m Initializing ...  \033[031m-b \033[032m")

        if not fll:
          print ("\033[031mError: \033[039m missing location of FLL library,  specify option \033[031m-L \033[032m")
          print ("\033[031m       \033[039m FLL library is available for download at \033[032m https://gthub.com/libm3l/fll \033[039m")
          sys.exit()       
        

    run(comp=compiler,build=build,execd=execd,fll=fll,cgns_dir=cgns_dir,force=args.force, overwrite=args.overwrite, init=args.init)
