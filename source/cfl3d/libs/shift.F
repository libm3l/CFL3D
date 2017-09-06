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
      MODULE SHIFT_M
      CONTAINS
      subroutine SHIFT(PGLOB)
c
c     $Id$
c
c**********************************************************************
c     Purpose:  shift strain rate tensor and other variables used
c               in non-equilibrium model
c**********************************************************************
c
c      input arrays   : PBGLOB
c
c**********************************************************************
c
      USE FLL_MODS_M
      IMPLICIT NONE
c
      TYPE(DNODE), POINTER :: PGLOB,PTMP,PGRID,PTMP1,PTMP2,PBLOCK
      TYPE(FUNC_DATA_SET)  :: FPAR

      INTEGER(LINT) :: IGRID,NGRID,IBLOCK,NBLOCK
      INTEGER :: IHDM

      IHDM = FLL_GETNDATA_I0(PGLOB, 'IHDM', 1_LINT, FPAR)
      IF(IHDM /= 1)RETURN

      NBLOCK =  FLL_NNODES(PGLOB,'block','DIR',-1_lint,.false.,FPAR)
      DO IBLOCK=1,NBLOCK
         PBLOCK => FLL_LOCATE(PGLOB,'block','DIR',-1_LINT,
     .                       IBLOCK,.FALSE.,FPAR)

         NGRID =  FLL_NNODES(PBLOCK,'grid','DIR',-1_lint,.false.,FPAR)
         DO IGRID=1,NGRID
            PGRID => FLL_LOCATE(PBLOCK,'grid','DIR',-1_LINT,
     .                       IGRID,.FALSE.,FPAR)
!
!  strain rate
!
            PTMP => FLL_LOCATE(PGRID,'ST','D',-1_LINT,
     .                       1_LINT,.FALSE.,FPAR) 
            IF(ASSOCIATED(PTMP))THEN
              PTMP1 => FLL_LOCATE(PGRID,'STN1','D',-1_LINT,
     .                       1_LINT,.FALSE.,FPAR) 
              PTMP2 => FLL_LOCATE(PGRID,'STN2','D',-1_LINT,
     .                       1_LINT,.FALSE.,FPAR) 

              PTMP2%D2 = PTMP1%D2
              PTMP1%D2 = PTMP%D2
            END IF
!
!  velocities
!
            PTMP => FLL_LOCATE(PGRID,'velocity','D',-1_LINT,
     .                       1_LINT,.FALSE.,FPAR) 
            IF(ASSOCIATED(PTMP))THEN
              PTMP1 => FLL_LOCATE(PGRID,'velocity_nn','D',-1_LINT,
     .                       1_LINT,.FALSE.,FPAR) 
              PTMP2 => FLL_LOCATE(PGRID,'velocity_nn1','D',-1_LINT,
     .                       1_LINT,.FALSE.,FPAR) 

              PTMP2%D2 = PTMP1%D2
              PTMP1%D2 = PTMP%D2
            END IF
         END DO
       END DO

      END SUBROUTINE SHIFT

      END MODULE SHIFT_M
