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
      MODULE ADDNONEQSTR_M
      CONTAINS
      subroutine ADDNONEQSTR(PGLOB,MSEQ,NGRID,NBLOCK,IDIMG,JDIMG,KDIMG)
c
c     $Id$
c
c**********************************************************************
c     Purpose:  allocate additional arrays for non-equilibrium model
c               and for time relaxation
c**********************************************************************
c
c      input arrays   : PBGLOB
c
c**********************************************************************
c
      USE FLL_MODS_M
      IMPLICIT NONE
c
      TYPE(DNODE), POINTER :: PGLOB,PTMP,PGRID,PBLOCK
      TYPE(FUNC_DATA_SET)  :: FPAR

      INTEGER :: IHDM,MSEQ,NGRID,NBLOCK,I,J,K
      INTEGER(LINT) :: DIMS, NDIMS
      INTEGER :: IDIMG(*),JDIMG(*),KDIMG(*)
!
!  specify if non-equilibrium model (1) or not
!
       PTMP => FLL_MK('IHDM','I',1_LINT,1_LINT, FPAR)
       PTMP%I0 = 1
       IF(.NOT.FLL_MV(PTMP, PGLOB, FPAR))STOP' ERROR MOVING NODE'
!
!  this is a switch which determines when mbglk.F call shift  (pglob) routine
!  this routine shifts some additinal data needed by non-equilibrium model
!
       PTMP => FLL_MK('shift','I',1_LINT,1_LINT, FPAR)
       PTMP%I0 = 0
       IF(.NOT.FLL_MV(PTMP, PGLOB, FPAR))STOP' ERROR MOVING NODE'
!
!  relaxaction factor, specifies how long it takes
!  to get to full time step for turbulent equations
!
       PTMP => FLL_MK('TRELAX','D',1_LINT,1_LINT, FPAR)
       PTMP%D0 = 1.
       IF(.NOT.FLL_MV(PTMP, PGLOB, FPAR))STOP' ERROR MOVING NODE'
!
!  factor specifying how much large residuals are relaxed
!  currently not used
!
       PTMP => FLL_MK('WRELAX','D',1_LINT,1_LINT, FPAR)
       PTMP%D0 = 0.
       IF(.NOT.FLL_MV(PTMP, PGLOB, FPAR))STOP' ERROR MOVING NODE'
       PTMP => FLL_MK('KRELAX','D',1_LINT,1_LINT, FPAR)
       PTMP%D0 = 0.
       IF(.NOT.FLL_MV(PTMP, PGLOB, FPAR))STOP' ERROR MOVING NODE'


       IHDM = FLL_GETNDATA_I0(PGLOB, 'IHDM', 1_LINT, FPAR)

       IF(IHDM /= 1)THEN
!
!   if not non-eq model, leave
!
         CALL FLL_CAT(PGLOB, 6, .FALSE.,FPAR)
         RETURN
       END IF

       PTMP => FLL_MK('SLIMITER','D',1_LINT,1_LINT, FPAR)
       PTMP%D0 = 1.
       IF(.NOT.FLL_MV(PTMP, PGLOB, FPAR))STOP' ERROR MOVING NODE'


!       DO J = 1,1   !MSEQ
!
!         IF(IDIMG(J) == 2)THEN
!           NDIMS = 2*2
!         ELSE
!           NDIMS = 3*3
!         END IF
!       
!         WRITE(*,*)'======================= ',  MSEQ,NGRID, NBLOCK

         DO K=1,NBLOCK


           PBLOCK => FLL_MK("block","DIR",0_LINT, 0_LINT,FPAR)
           IF(.NOT.FLL_MV(PBLOCK, PGLOB, FPAR))STOP' ERROR MOVING NODE'
           PTMP => FLL_MK('cfl3d-level','I',1_LINT,1_LINT, FPAR)
           PTMP%I0 = NBLOCK - K + 1
           IF(.NOT.FLL_MV(PTMP, PBLOCK, FPAR))STOP'ERROR MOVING NODE'
           PTMP => FLL_MK('level','I',1_LINT,1_LINT, FPAR)
           PTMP%I0 = K
           IF(.NOT.FLL_MV(PTMP, PBLOCK, FPAR))STOP'ERROR MOVING NODE'

           DO I = 1,NGRID  ! NBLOCK

             PGRID => FLL_MK("grid","DIR",0_LINT, 0_LINT,FPAR)
             IF(.NOT.FLL_MV(PGRID,PBLOCK,FPAR))STOP'ERROR MOVING NODE'

             PTMP => FLL_MK('grid-number','I',1_LINT,1_LINT, FPAR)
             PTMP%I0 = J
             IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'

             PTMP => FLL_MK('dimensions','L',3_LINT,1_LINT, FPAR)
             PTMP%L1(1) = idimg(k)
             PTMP%L1(2) = jdimg(k)
             PTMP%L1(3) = kdimg(k)
             IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'

             DIMS = IDIMG(K)*JDIMG(K)*KDIMG(K)

             IF(K == 1)THEN
!
!  save velocity in three time levels, shift in shift.F
!  value of velcoity calculated in twoeqn.F
!
               PTMP => FLL_MK('velocity','D',dims,3_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
               PTMP => FLL_MK('velocity_nn','D',dims,3_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
               PTMP => FLL_MK('velocity_nn1','D',dims,3_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
             
!
!  save DS/Dt and D2S/Dt2, value calculated
!  in twoeqn.F
!
               PTMP => FLL_MK('SSGRAD','D',dims,18_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
               PTMP => FLL_MK('SS2GRAD','D',dims,54_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
!
!  save strain rate
!  in three time steps, shift in shift.F, value calculated
!  in twoeqn.F
!
               PTMP => FLL_MK('ST','D',dims,6_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
               PTMP => FLL_MK('STN1','D',dims,6_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
               PTMP => FLL_MK('STN2','D',dims,6_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
!
!  these is a temproray term, value calculated
!  in twoeqn.F
!
               PTMP => FLL_MK('DSDT_N','D',dims,12_LINT, FPAR)
               PTMP%D2 = 0.
               IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
              END IF
!
!  extra term in strain rate, needed in viscous fluces, value calculated
!  in twoeqn.F
!
              PTMP => FLL_MK('Extra_Strain','D',dims,6_LINT, FPAR)
              PTMP%D2 = 0.
              IF(.NOT.FLL_MV(PTMP, PGRID, FPAR))STOP'ERROR MOVING NODE'
           END DO
         END DO
!       END DO

       CALL FLL_CAT(PGLOB, 6, .FALSE.,FPAR)

      END SUBROUTINE ADDNONEQSTR

      END MODULE ADDNONEQSTR_M
