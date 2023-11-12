C|CPYOBS   MAIN PROGRAM TO COPY AND POSSIBLY MODIFY OBSLIB TAPE
C           J.F.CHANDLER   1979 APRIL 5
C           MODIFIED TO USE OBSIO 1980 OCT 10
C           MODIFIED TO USE OBSFRM 1992 OCT

      IMPLICIT NONE

      include 'pepglob.inc'
C
C        COMMON
      include 't1a.inc'
      include 't2a.inc'
      include 't3a.inc'
      include 't4a.inc'
C
C        LOCAL
      CHARACTER*4 VERSN/' 2.4'/, CPYNAM/'EDIT'/, TEST(10), NULTST,
     1 QCUT(3)/'** ','   ','OUT'/
      INTEGER*4 NUM(2),NUM1,NUM2, IDP(2)/1,2/
      EQUIVALENCE (NUM(1),NUM1),(NUM(2),NUM2), (NULTST,IDP(1))
      REAL*4 CUT(2)
      REAL*10 ERWT(2),EPRMS(10),TERM
      REAL*8 A(5),S(5),F,CM(3),RMA,RMB,CC,X
      INTEGER*4 I,ICD,ICO,ICUT,IP,IPDP,J,JP,JT,K,N,NCUT,NTAPE,
     1  PRINT,OBSLIB,OBSOUT,RNDMDT,LIMIT,CUMOBS
      LOGICAL*4 PRNT,NOPART,COPY,STATS,CRDIN,CRDOUT
      CHARACTER*3 MONTHS(12)/'JAN','FEB','MAR','APR','MAY','JUN','JUL',
     . 'AUG','SEP','OCT','NOV','DEC'/
C
      COMMON/RANDDAT/ ISEED
      INTEGER*4 ISEED

      REAL*8 RANDOM,GAUSSIAN

      NAMELIST/INPUT/ COPY,CRDIN,CRDOUT,CUT,ERWT,IP,NOPART,NTAPE,
     1 PRNT,STATS,TEST,EPRMS,RNDMDT,LIMIT
C
C           INPUT VARIABLES
C COPY   IF .T., THEN COPY EACH INPUT OBSLIB TAPE (DEFAULT)
C CRDIN  IF T, THEN INPUT TAPES ARE IN CARD-IMAGE FORMAT (DEFAULT F)
C CRDOUT IF T, THEN OUTPUT TAPES ARE IN CARD-IMAGE FORMAT (DEFAULT F)
C CUT    EXCLUDE FROM STATS ANY OBS WITH DERIV(2,.).GT.CUT(.)*ERROR(.)
C        DEFAULT: 20.,20. (0 MEANS DON'T CUT ANY)
C EPRMS  ARRAY OF TEN PARAMETERS FOR SPECIAL EDITING FUNCTIONS, IF ANY
C ERWT   CHANGE ERRORS FOR ALL OBSERVATIONS OF SERIES BY ERWT(.)
C        DEFAULT: 1D0, 1D0
C IP     SELECT OBSERVABLE FOR PRINTING AND STATISTICS
C        DEFAULT: 1
C LIMIT  MAXIMUM NUMBER OF OBSERVATIONS TO COPY, DEFAULT=0 (NO LIMIT).
C NOPART IF .T., THEN SUPPRESS PARTIALS ON COPY, DEFAULT=F
C NTAPE  NUMBER OF INPUT OBSLIB TAPES (ON UNITS 11 THROUGH NTAPE+10)
C        DEFAULT: 1
C PRNT   IF .T., THEN PRINT OBSERVATIONS, DEFAULT=F
C RNDMDT IF NON-ZERO, ADD GAUSSIAN NOISE OF QUOTED SIGMA, WITH SEED=RNDMDT
C STATS  IF .T., THEN ACCUMULATE ERROR STATISTICS FOR EACH SERIES,
C        DEFAULT=F
C TEST   UP TO TEN SERIES NAMES FOR SPECIAL EDIT PROCESSING (SEE BELOW),
C        OR DO ALL SERIES IF TEST(1) IS 'ALL'
C
C           DEFAULT VALUES
      PRINT=6
      COPY=.TRUE.
      CRDIN=.FALSE.
      CRDOUT=.FALSE.
      CUT(1)=20.
      CUT(2)=20.
      DO I=1,10
         EPRMS(I)=0D0
      END DO
      ERWT(1)=1D0
      ERWT(2)=1D0
      IP=1
      LIMIT=0
      NOPART=.FALSE.
      NTAPE=1
      OBSOUT=0
      PRNT=.FALSE.
      RNDMDT=0
      STATS=.FALSE.
      DO I=1,10
         TEST(I)=NULTST
      END DO
      WRITE(PRINT,10) VERSN
   10 FORMAT('1* * OBSLIB COPIER VERSION',A4,' * *'//)
      READ(5,INPUT,END=20)
   20 WRITE(PRINT,INPUT)
      IF(RNDMDT.NE.0) THEN
         ISEED=IABS(RNDMDT)
         X=RANDOM(ISEED)
         X=RANDOM(ISEED)
         X=RANDOM(ISEED)
         X=RANDOM(ISEED)
         X=RANDOM(ISEED)
         X=RANDOM(ISEED)
      ENDIF
      CUMOBS=0
      DO 220 I=1,NTAPE
      OBSLIB=I+10
      IF(COPY) OBSOUT=I+20
      IF(CRDIN) THEN
         CALL OBSFRM(OBSLIB,OBSOUT,1,-1,ICD)
      ELSE
         CALL OBSIO(OBSLIB,OBSOUT,1,-1,ICD)
      ENDIF
      IF(ICD.LT.1) GOTO 210
      LNKLVA=CPYNAM
      IF(CRDOUT) THEN
         CALL OBSFRM(OBSLIB,OBSOUT,1,1,ICD)
      ELSE
         CALL OBSIO(OBSLIB,OBSOUT,1,1,ICD)
      ENDIF
      WRITE(PRINT,30) OBSLIB,R1A
   30 FORMAT('-INPUT OBSLIB TAPE',I3,' HAS TITLE: ',11A8/)
      IF(CRDIN) THEN
         CALL OBSFRM(OBSLIB,OBSOUT,2,-1,ICD)
      ELSE
         CALL OBSIO(OBSLIB,OBSOUT,2,-1,ICD)
      ENDIF
      IF(NOPART) CALL ZERPAR(2)
      IF(CRDOUT) THEN
         CALL OBSFRM(OBSLIB,OBSOUT,2,1,ICD)
      ELSE
         CALL OBSIO(OBSLIB,OBSOUT,2,1,ICD)
      ENDIF
C
C           START NEXT SERIES
   40 IF(CRDIN) THEN
         CALL OBSFRM(OBSLIB,OBSOUT,3,-1,ICD)
      ELSE
         CALL OBSIO(OBSLIB,OBSOUT,3,-1,ICD)
      ENDIF
      IF(ICD.LT.0) GOTO 210
      IF(NOPART) CALL ZERPAR(3)
C * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
C * * * * * * * * * SPECIAL EDITING STUFF * * * * * * * * * * * * * * *
C      DO JT=1,10
C         IF(SERA.EQ.TEST(JT) .OR. TEST(1).EQ.'ALL') THEN
CC INSERT POINTERS FOR PARTIALS W.R.T. A SINE WAVE
C            JP=1
C            DO WHILE (LPSRCA(JP).NE.0 .AND. JP.LT.15 .AND. JP.LE.N9A)
C               JP=JP+1
C            END DO
C            IF(JP.GT.15) STOP 10
C            LPSRCA(JP)=15
C            LPSRCA(JP+1)=16
C            IF(N9A.LT.JP+1) N9A=JP+1
C            GOTO 46
C         ENDIF
C      END DO
C   46 CONTINUE
C * * * * * * * * * END SPECIAL EDITING * * * * * * * * * * * * * * * *
C * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      IF(CRDOUT) THEN
         CALL OBSFRM(OBSLIB,OBSOUT,3,1,ICO)
      ELSE
         CALL OBSIO(OBSLIB,OBSOUT,3,1,ICO)
      ENDIF
      IF(ICD.LT.1) GOTO 210
      WRITE(PRINT,50) NSEQA,SERA,SITA,RITA,NPLNTA,NCENTA,SPOTA,SPOT2A
   50 FORMAT('-SERIES HEADER'/ ' SEQ NO  NAME  SENDSITE  RECVSITE  ',
     1 'NPLNT  NCENTR     SPOTS'/ I7,2X,A4,2X,A8,2X,A8,I7,I8,2(2X,A4) )
      IF(PRNT) WRITE(PRINT,60) IP,IP
   60 FORMAT('0NCODE   JD',7X,'HR  MIN  SEC',6X,
     1  'ERROR(',I1,')   RESULT(',I1,')'/)
C        INITIALIZE STATISTICS
      NCUT=0
      N=0
      DO 70 K=1,5
        S(K)=0D0
   70 END DO

   80 IF(CRDIN) THEN
         CALL OBSFRM(OBSLIB,0,4,-1,ICD)
      ELSE
         CALL OBSIO(OBSLIB,0,4,-1,ICD)
      ENDIF
      IF(ICD.LE.0) GOTO 150
      IF(CUMOBS.GE.LIMIT .AND. LIMIT.GT.0) THEN
         NCODEA=0
         ICD=-1
         GOTO 150
      ENDIF
      CUMOBS=CUMOBS+1
C
C * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
C * * * * * * * * * SPECIAL EDITING STUFF * * * * * * * * * * * * * * *
C ADD (OR SUBTRACT) NOISE ACROSS THE BOARD
      IF(RNDMDT.NE.0) THEN
         DO JT=1,NUM1A
            K=JT
            IF(MOD(NCODEA+3,3).EQ.0) K=2
            X=GAUSSIAN(ISEED)*ERRORA(K)
            IF(RNDMDT.LT.0) X=-X
            RESLTA(K)=RESLTA(K)+X
            DERIVA(2,JT)=DERIVA(2,JT)+X
         END DO
      ENDIF
      DO JT=1,10
         IF(SERA.EQ.TEST(JT) .OR. TEST(1).EQ.'ALL') THEN
CC INSERT PARTIALS W.R.T. A SINE WAVE (ASSUMES THESE ARE AT THE END!!)
C            TERM=6.2831853071795865D0*(JDA+CTRECA-EPRMS(1))/EPRMS(2)
C            DERIVA(NUMPRA+1,1)=SIN(TERM)
C            DERIVA(NUMPRA+2,1)=COS(TERM)
C            NUMPRA=NUMPRA+2
C1 ADD 1 SEC TO THE RECEIVE TIME         
C1            SECA=SECA+1.0
C1            IF(CTRECA.NE.0D0) CTRECA=CTRECA+1._10/864D2
C1            IF(NSAVA.GE.40) SAVA(40)=SAVA(40)+1D0
C PRINT VIKING RANGE WITH PROPAGATION DELAYS REMOVED
            WRITE(6,105) SPOTA(4:4),RITA(1:2),SITA(1:2),
     .       1900+IYEARA+100*(ITIMA/10),MONTHS(IMNTHA),IDAYA,
     .       IHRA,IMINA,IFIX(SECA+.5),RESLTA(1)-SUMCRA(1),ERRORA(1)
  105       FORMAT(1X,A1,2(1X,A2),I5,1X,A3,I3,I3.2,2(':',I2.2),6PF17.3,
     .       3X,6PF4.3,5X,'.0')
            GOTO 106
         ENDIF
      END DO
  106 CONTINUE
C * * * * * * * * * END SPECIAL EDITING * * * * * * * * * * * * * * * *
C * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
C
C           GET POINTERS TO PROPER DERIVA TO MATCH RESULT AND ERROR
      IF(NCODEA.GT.3) NCODEA=NCODEA-3
      IF(NOPART) CALL ZERPAR(4)
      NUM1=(NCODEA-1)/2+1
      NUM2=NCODEA/2+1
      IDP(2)=2
      IDP(NUM1)=1
C           APPLY ERROR WEIGHTS
      DO 110 J=NUM1,NUM2
      IF(ERWT(J).EQ.1D0) GOTO 110
      JP=IDP(J)
      DERIVA(1,JP)=DERIVA(1,JP)*ERWT(J)
      ERRORA(J)=ERRORA(J)*ERWT(J)
  110 CONTINUE
C           SEE IF REQUESTED OBSERVABLE IS THERE
      IF(NUM(IP).NE.IP) GOTO 150
      IPDP=IDP(IP)
      N=N+1
C           TEST FOR INCLUSION
      ICUT=2
      IF(CUT(IP).LE.0.) GOTO 120
      IF(CUT(IP)*ERRORA(IP).GE.DERIVA(2,IPDP)) GOTO 120
      ICUT=1
      NCUT=NCUT+1
  120 CONTINUE
      IF(PRNT) WRITE(PRINT,130) NCODEA,JDSA,IHRA,IMINA,SECA,
     1 DERIVA(1,IPDP),RESLTA(IP),QCUT(ICUT)
  130 FORMAT(I6,I8,I4,I5,F7.2,1PE11.1,D24.15,10X,A3)
C           ACCUMULATE STATISTICS
      IF(.NOT.STATS) GOTO 150
      IF(ICUT.NE.2) GOTO 150
      A(1)=RESLTA(IP)
      A(2)=DERIVA(2,IPDP)
      A(3)=A(1)**2
      A(4)=A(1)*A(2)
      A(5)=A(2)**2
      DO 140 K=1,5
        S(K)=S(K)+A(K)
  140 END DO

  150 IF(CRDOUT) THEN
         CALL OBSFRM(OBSLIB,OBSOUT,4,1,ICO)
      ELSE
         CALL OBSIO(OBSLIB,OBSOUT,4,1,ICO)
      ENDIF
      IF(NCODEA.GT.0) GOTO 80
C           DO FINAL COMPUTATION
      WRITE(PRINT,170) N,NCUT
  170 FORMAT('0',I9,' OBSERVATIONS READ/COPIED,',I9,' OBSERVATIONS CUT')
      IF(.NOT.STATS) GOTO 200
      N=N-NCUT
      IF(N.LE.0) GOTO 200
      F=1D0/N
      DO 180 K=1,5
        A(K)=S(K)*F
  180 END DO

      CM(1)=A(3)-A(1)**2
      CM(2)=A(4)-A(1)*A(2)
      CM(3)=A(5)-A(2)**2
      RMA=SQRT(CM(1))
      RMB=SQRT(CM(3))
      CC=CM(2)/RMA/RMB
C           PRINT RESULTS
      WRITE(PRINT,190) A,CM,RMA,RMB,CC
  190 FORMAT(' MEAN 1,2,1*1,1*2,2*2 =',1P,5D20.10 /
     1       ' * * CORRELATION',1PD20.12/16X,2D20.12/' RMS(O,O-C)=',
     2 2D20.12,'  CORR.=',D20.12)
  200 IF(ICD.GE.0) GOTO 40
  210 CONTINUE
      REWIND OBSLIB
      IF(OBSOUT.GT.0) REWIND OBSOUT
  220 CONTINUE
      STOP
      END
