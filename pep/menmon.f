      subroutine MENMON(jd, fract, ylun, nn)

      use iso_fortran_env, only: real32, int32

      implicit none


c*** start of declarations inserted by spag
      real      a, asc, casc, cecc, cinc, cpci, cper, danom, dasc, dper,
     .          e, e22, ert, ert2, erta, erte, per, qq1, qq2, qq3
      real      qq4, qq5, sasc, secc, sinc, spci, sper
      integer   i, nnint, int1, iswtch, j, jd, k, nn, ntop

c*** end of declarations inserted by spag


c
c ash/zimnoch   feb 1971    subroutine menmon
c determination of position,velocity in browns mean lunar orbit
c
      real*10 fract, ylun(6)
c        jd = julian day number (jed of noon on given day)
c      fract= fraction of day from midnight
c        nn = 0 position determined
c        nn = 1 position,velocity determined
c           ylun(i),i=1,6 position,velocity in mean lunar orbit
c                         referrred to mean equinox and equator of
c                         reference epoch (output)
c
      include 'aacoff.inc'
      include 'fcntrl.inc'
      include 'funcon.inc'
c
c miscellaneous specification statements
      real*4    b(3,2), db(3,2), aa(3,3), c(3,2), dc(3,2)
      real*4    stuff(2), v(2), dv(2), angle
      real*10 ppp, tt, qq, t
c
c setup for menmon
      data iswtch/0/
      if(iswtch.le.0) then
         iswtch = 1
         data e/5.4900489E-2/
         a    = real(60.2665*4.263529034E-5_10, real32)
         e22  = real(e/2._10, real32)
         ert2 = 1. - e*e
         ert  = sqrt(ert2)
         erta = a*ert
         erte = e/ert
c given that sin(inc/2) =4.4886967e-2
         cinc = real(9.959730260464257E-1_10, real32)
         sinc = real(8.9653395852723849E-2_10, real32)
         Kepoch = 1
         if(Jct(13).eq.1) Kepoch = 2
      endif
c
c determination of time
      nnint = jd - 2415020
      qq  = fract - 0.5_10
      tt  = nnint + qq
c
c determination of mean anomaly
      nnint  = 1306*nnint
      int1 = nnint/36000
      ppp  = nnint - int1*36000
      ppp  = ((ppp-6.3895392E3_10) + qq*1.306E3_10 +
     . tt*(0.49924465_10+tt*(6.889E-10_10+tt*2.99E-17_10)))/3.6E4_10
      nnint = int(ppp, int32)
      angle = real((ppp - nnint)*Twopi, real32)
c
c determination of eccentric anomaly (solution of kepler eq)
      secc = angle + e*(sin(angle) + e22*sin(angle*2))
   50 cecc = (angle - secc + e*SIN(secc))/(1. - e*COS(secc))
      secc = secc + cecc
      if(ABS(cecc).gt.1E-5) goto 50
      cecc = COS(secc)
      secc = SIN(secc)
c
c determination of ascending node and perigee
      ppp = 7.1995354166666667E-1_10 + tt*(-1.4709422833333333E-4_10 +
     .      tt*(4.325E-15_10+tt*1.3888888888888889E-22_10))
      nnint = int(ppp, int32)
      asc = real((ppp - nnint)*Twopi, real32)
      ppp = 2.08739669444444444444E-1_10 +
     . tt*(4.56550006944444444444E-4_10 -
     . tt*(2.58222222222222222222E-14_10+
     . tt*8.61111111111111111111E-22_10))
      nnint = int(ppp, int32)
      per = real((ppp - nnint)*Twopi, real32)
c
c determination of derivatives of mean anomaly, ascending
c node and perigee
      if(nn.ne.0) then
         danom = real(2.2802713493961401E-1_10 +
     .    tt*(2.404714643398E-13_10 + tt*1.5655603390389E-20_10),
     .       real32)
         dasc  = real(-9.24220294234919E-4_10 +
     .    tt*(5.434955290710E-14_10 + tt*2.617993877991E-21_10), real32)
         dper  = real(2.868588295626071E-3_10 -
     .    tt*(3.2449161453178E-13_10 + tt*1.62315620435472E-20_10),
     .       real32)
      endif
c
c determine position,velocity in mean lunar orbital plane
      qq   = 1._10 - e*cecc
      qq1  = cecc - e
      qq2  = real(a/qq, real32)
      qq3  = -secc*qq2
      qq4  = real(erta/qq, real32)
      qq5  = cecc*qq4
      v(1) = a*qq1
      v(2) = erta*secc
      ntop = 1
      if(nn.ne.0) then
         ntop  = 2
         dv(1) = qq3*danom
         dv(2) = qq5*danom
      endif
c
c     determination of AA matrix (transformation matrix from
c     coordinates referred to the mean equinox and ecliptic of
c     date to those referred to the mean equinox and equator
c     of reference epoch)
      t = tt - 18262.423_10
      if(Kepoch.eq.2) t = tt - 36524.5_10
      do j = 1, 3
         do i = 1, 3
            aa(i,j) = real(t*(Aa1(1,i,j,Kepoch)
     .       +t*(Aa1(2,i,j,Kepoch)+t*(Aa1(3,i,j,Kepoch)
     .       +t*(Aa1(4,i,j,Kepoch)+t*(Aa1(5,i,j,Kepoch)))))), real32)
            end do
         end do
      aa(1,1) = real(aa(1,1) + 1._10, real32)
      aa(2,2) = real(aa(2,2) + Cob0(Kepoch), real32)
      aa(2,3) = real(aa(2,3) + Sob0(Kepoch), real32)
      aa(3,2) = real(aa(3,2) - Sob0(Kepoch), real32)
      aa(3,3) = real(aa(3,3) + Cob0(Kepoch), real32)
c
c determination of b matrix
      casc   = COS(asc)
      sasc   = SIN(asc)
      cper   = COS(per)
      sper   = SIN(per)
      spci   = sper*cinc
      cpci   = cper*cinc
      b(1,1) = casc*cper - sasc*spci
      b(1,2) = -casc*sper - sasc*cpci
      b(2,1) = sasc*cper + casc*spci
      b(2,2) = -sasc*sper + casc*cpci
      b(3,1) = sper*sinc
      b(3,2) = cper*sinc
c
c determination of derivatives of b matrix
      if(nn.ne.0) then
         db(1,1) = -b(2,1)*dasc + b(1,2)*dper
         db(1,2) = -b(2,2)*dasc - b(1,1)*dper
         db(2,1) = b(1,1)*dasc + b(2,2)*dper
         db(2,2) = b(1,2)*dasc - b(2,1)*dper
         db(3,1) = b(3,2)*dper
         db(3,2) = -b(3,1)*dper
      endif
c
c determination of c matrix and its derivatives
      do i = 1, 3
         do j = 1, 2
            c(i,j) = 0._10
            dc(i,j) = 0._10
            do k = 1, 3
               c(i,j) = c(i,j) + aa(k,i)*b(k,j)
               if(nn.ne.0) dc(i,j) = dc(i,j) + aa(k,i)*db(k,j)
               end do
            end do
         end do

      do nnint = 1, 3
c
c determination of position,velocity for mean
c lunar orbit in coordinate system referred to mean equinox
c and equator of reference epoch

c matrix transformation
         stuff(1) = 0._10
         stuff(2) = 0._10
         do k = 1, 2
            stuff(1) = stuff(1) + c(nnint,k)*v(k)
            if(nn.ne.0) stuff(2) = stuff(2)
     .          + (c(nnint,k)*dv(k) + dc(nnint,k)*v(k))
            end do

         do i = 1, ntop
            j = 3*(i - 1) + nnint
            ylun(j) = stuff(i)
            end do

         end do
      return

      end
