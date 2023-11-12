      SUBROUTINE VDUMP
      IMPLICIT NONE
C        ALL LINES BETWEEN LN AND IP ARE TO BE PRINTED AS NON-MATCHING
C        LN IS UPDATED TO INDICATE LAST MATCH
      include 'buffer.inc'
      include 'chars.inc'
      include 'ibfl.inc'
      include 'pgfba.inc'
      include 'ptrs.inc'
      include 'undscr.inc'
C
      CHARACTER*1 NUM(11)
      CHARACTER*4 IST/'---*'/,IEND/'*END'/,NONE/'NONE'/
      CHARACTER*12 IHED(3)/'-FILE 1 LINE',' FILE 2 LINE','            '/
      CHARACTER*4 QLIN/'LINE'/
      INTEGER*4 I,IH,IINC,IPM1,IUDIF,IUND,I1,I2,J,LIN,LNAU,LNM,LNM1,
     .          LNN,LPG
C
C*  START=100
      IF(IP(1).EQ.LN(1)+1 .AND. IP(2).EQ.LN(2)+1 .AND.
     1 JP(1).GE.IP(1) .AND. JP(2).GE.IP(2)) then
         LN(1)=IP(1)
         LN(2)=IP(2)
         RETURN
      endif
      IDMP=IDMP+1
      IF(IPUN.LE.0) GOTO 1000
C        SKIP CHANGE CARDS  FOR LAST *END,*END
      IF(LN(1).GE.JP(1).AND.LN(2).GE.JP(2)) GOTO 1000
      I2=5
      LNM1=LN(1)
      IPM1=IP(1)-1
      IF(IEF(1).EQ.1.AND.IPM1.GT.JP(1)) IPM1=JP(1)
      IF(LNM1.GE.IPM1) GOTO 110
      LNM1=LNM1+1
C        WRITE LINE NUMBER INTO ARRAY
      IF(ISQN.EQ.0) IPM1=IPM1*10
      IF(IPM1.GT.99999) IPM1=99999
      CALL EBCDI(IPM1,NUM(6),6)
      NUM(6)=COMMA
      I2=6
      DO 100 I=7,11
        IF(NUM(I).EQ.BLANK) GOTO 100
        I2=I2+1
        NUM(I2)=NUM(I)
  100 END DO
C        NOW ENCODE THE FIRST LINE NUMBER
  110 IF(ISQN.EQ.0) LNM1=LNM1*10
      CALL EBCDI(LNM1,NUM,5)
      DO 120 I1=1,5
        IF(NUM(I1).NE.BLANK) GOTO 130
  120 END DO
      I1=5
  130 WRITE(IPUN,140) (NUM(I),I=I1,I2)
  140 FORMAT('-',11A1)
C*  START=1000
 1000 CONTINUE
C        SET UP UNDERSCORE SWITCH
      IUND=IP(1)-LN(1)-IP(2)+LN(2)
      LNAU=MOD(LN(1),ISIZ)*JSIZ+ISUB1(1)
      DO 1500 I=1,2
      IF(LN(I).LT.IP(I)) LN(I)=LN(I)+1
      IH=I
C        GET INDEX FOR FIRST CARD
      LNM=MOD(LN(I)-1,ISIZ)*JSIZ+ISUB1(I)
      IF(IRFM.NE.0) GOTO 1020
      IF(LN(I).LT.IP(I)) GOTO 1100
      IF(NOPRNT.GT.1) GOTO 1500
      WRITE(6,1010) IHED(IH),LN(I),NONE
 1010 FORMAT(A12,I5,1X,A4,(T24,100A1))
      GOTO 1500
C           PRINT FILE SETUP
 1020 LIN=LN(I)
      LPG=0
      IIP=1
      IF(LIN.LE.KPGP(I,1)) GOTO 1030
      LIN=LN(I)-KPGP(I,1)
      LPG=IPGN(I)+1-IPNP(I)
      IIP=2
C           TEST FOR NO NON-MATCHING LINES HERE
 1030 IF(LN(I).LT.IP(I)) GOTO 1050
      IF(NOPRNT.GT.1) GOTO 1500
      WRITE(6,1040) IHED(IH),I,LPG,QLIN,LIN,NONE,IST
 1040 FORMAT(A1,'*--- FILE',I2,' PAGE',I3,1X,A4,I4,2(1X,A4))
      GOTO 1500
 1050 IF(NOPRNT.LE.1) WRITE(6,1040) IHED(IH),I,LPG,QLIN,LIN,IST
C
C*  START=1100
 1100 IF(LN(I).GE.IP(I)) GOTO 1500
      IF(IRFM.EQ.0) GOTO 1120
      IF(IIP.GT.IPNP(I).OR.LN(I).LE.KPGP(I,IIP)) GOTO 1120
C           DIFFERENT PAGE NOW
 1110 LPG=IPGN(I)+IIP-IPNP(I)
      IF(NOPRNT.LE.1) WRITE(6,1040) BLANK,I,LPG,IST
      IIP=IIP+1
      IF(IIP.LE.IPNP(I).AND.LN(I).GT.KPGP(I,IIP)) GOTO 1110
C        SEE IF END OF FILE
 1120 IF(LN(I).GT.JP(I)) GOTO 1400
C        WATCH FOR END OF BUFFER
      IF(LNM.GT.IBFLL(I)) LNM=ISUB1(I)
      LNN=LNM+JSIZ-1
      IF(NOPRNT.GT.1) GOTO 1200
      IF(IRFM.NE.0) GOTO 1130
      WRITE(6,1010) IHED(IH),LN(I),IST,(CBF(J),J=LNM,LNN)
      GOTO 1150
C           PRINT JUST THE LINE FOR A PRINT FILE
 1130 WRITE(6,1140) (CBF(J),J=LNM,LNN)
 1140 FORMAT(1X,2(250A1))
 1150 IF(IUND.NE.0.OR.I.NE.2) GOTO 1200
C           PRINT UNDERLINING IF LINES SEEM ALMOST THE SAME
      CALL UDIFF(CBF(LNAU),CBF(LNM),UBUF(IU1),IULB,IUDIF)
      IF(IUDIF.EQ.1) THEN
         IF(IRFM.NE.0) THEN
            WRITE(6,1160) (UBUF(J),J=1,IUL)
 1160       FORMAT('+',2(250A1))
         ELSE
            IF(IUL.LE.100) THEN
               WRITE(6,1170) (UBUF(J),J=1,IUL)
 1170          FORMAT('+',(T24,100A1))
            ELSE
               WRITE(6,1180) (UBUF(J),J=1,IUL)
 1180          FORMAT(' (DIFFS)',(T24,100A1))
            ENDIF
         ENDIF
      ENDIF
      LNAU=IINC(LNAU,1)
C*  START=1200
 1200 IF(IPUN.LE.0.OR.I.NE.2) GOTO 1220
C        PUNCH CHANGE CARDS
      WRITE(IPUN,1210) (CBF(J),J=LNM,LNN)
 1210 FORMAT(4(255A1))
 1220 LN(I)=LN(I)+1
      LNM=LNN+1
      IH=3
      IF(IP(I).LT.99999999) GOTO 1100
C        INDEFINITE PRINT
      CALL CRD(I)
      IF(IEF(I).EQ.1) IP(I)=JP(I)+2
      GOTO 1100
C*  START=1400
 1400 IF(IRFM.NE.0) GOTO 1410
      WRITE(6,1010) IHED(IH),LN(I),IEND
      GOTO 1500
 1410 WRITE(6,1420)
 1420 FORMAT(' *--- END ---*')
C*  START=1500
 1500 CONTINUE
      RETURN
      END
