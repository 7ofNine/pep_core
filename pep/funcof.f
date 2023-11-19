      real*10 function FUNCOF(t, a, intb, b, c, d)

      use iso_fortran_env, only: int32
 
      implicit none
 
 
c*** start of declarations inserted by spag
      integer   nnint, intb
 
c*** end of declarations inserted by spag
 
 
c
c m.e.ash  sept 1967   function subroutine funcof
c third order polynomials for fundamental arguments of brown lunar
c theory are evaluated
c
      real*10 t, a, b, c, d, tint, tt, ab, bb, poly
c
c reduce number of revolutions
      nnint  = int(t, int32)
      tint = nnint
      tt   = t - tint
      nnint  = nnint*intb
      ab   = nnint - ((nnint/10000)*10000)
      bb   = intb
c
c evaluate polynomial
      poly = a + (ab + bb*tt)*1.0E-4_10 + t*(b + t*(c+t*d))
c
c get between -1 and 1 revolutions
      nnint    = int(poly, int32)
      tint   = nnint
      FUNCOF = poly - tint
      return
      end
