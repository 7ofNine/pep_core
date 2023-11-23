      subroutine ZFILL(array, length)
c
c  j.f.chandler - 1983 feb
c
c  subroutine for zeroing core
c
c  array  - name of array or array element
c  length - size in bytes of region to zero
c
c
c  extremely dirty way of initializing arrays to 0
c
      implicit none
 
      integer*4 length, i, izero/0/
      character*1 array(length), zero
 
      equivalence (izero,zero)

      write(*,2001) length , sizeof(array)
 2001 format("---------------------------20 SR zfill", I5,
     .'array length = ', I5)
      do i = 1, length
c         write(*,2000) i
c2000  Format("---------------------------22 SR zfill", I5)
         array(i) = zero
c         write(*,2002) i, length
c 2002 Format("---------------------------23 SR zfill", I6,"/",I6)
         enddo
c      write(*,*) "---------------------------26 SR zfill"
      end
