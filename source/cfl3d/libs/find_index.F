c  ---------------------------------------------------------------------------
c  CFL3D is a structured-grid, cell-centered, upwind-biased, Reynolds-averaged
c  Navier-Stokes (RANS) code. It can be run in parallel on multiple grid zones
c  with point-matched, patched, overset, or embedded connectivities. Both
c  multigrid and mesh sequencing are available in time-accurate or
c  steady-state modes.
c
c  Copyright 2001 United States Government as represented by the Administrator
c  of the National Aeronautics and Space Administration. All Rights Reserved.
c 
c  The CFL3D platform is licensed under the Apache License, Version 2.0 
c  (the "License"); you may not use this file except in compliance with the 
c  License. You may obtain a copy of the License at 
c  http://www.apache.org/licenses/LICENSE-2.0. 
c 
c  Unless required by applicable law or agreed to in writing, software 
c  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT 
c  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the 
c  License for the specific language governing permissions and limitations 
c  under the License.
c  ---------------------------------------------------------------------------
c
      MODULE FIND_INDEX_M
      CONTAINS
      FUNCTION FIND_INDEX(I,J,K,IM,JM,KM) RESULT(IND)
c
c     $Id$
c
c**********************************************************************
c     Purpose:  get 1D index from 3D indexes
c
c     CHANGELOG
c
c     Version   Date       Author               Comment
c     -------   --------   -------              -------
c**********************************************************************
       IMPLICIT NONE

       INTEGER :: I,IM,J,JM,K,KM,IND

       IND = I*JM*KM+J*KM+K
       RETURN

      END 

      END MODULE FIND_INDEX_M
