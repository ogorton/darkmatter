!-------------------------------------------------------------------------------
function MJ(y,np,lp,jp,n,l,j,bigJ)

    implicit none
    INTERFACE

      function BesselElement(y,np,lp,n,l,bigL)
          implicit none
          INTEGER, INTENT(IN) :: n, np, l, lp, bigL
          REAL(kind=8), INTENT(IN) :: y
          REAL(kind=8) :: BesselElement
      end function BesselElement

      function Jnorm(j)
          implicit none
          REAL(kind=8), INTENT(IN)  :: j
          REAL(kind=8) :: Jnorm
      end function Jnorm

    end INTERFACE

    INTEGER, INTENT(IN) :: np,lp,jp,n,l,j,bigJ
    REAL(kind=8), INTENT(IN) :: y
    REAL(kind=8) :: xjp,xj
    REAL(kind=8) :: Pi = 3.1415926535897932
    REAL(kind=8) :: Wigner_3j,Wigner_6j
    !REAL(kind=8) :: DBLEFacLOG
    REAL(kind=8) :: MJ

    xjp = dble(jp)/2.0
    xj  = dble(j )/2.0

    MJ = (-1)**(0.5d0+xj+dble(bigJ)) * SQRT(Jnorm(xj)*Jnorm(xjp) &
          * Jnorm(dble(l))*Jnorm(dble(lp))*Jnorm(dble(bigJ))/(4*Pi)) &
        & * Wigner_3j(2*lp,2*bigJ,2*l,0,0,0) * Wigner_6j(2*lp,jp,1,j,2*l,2*bigJ)   &
        & * BesselElement(y,np,lp,n,l,bigJ)

end function MJ


!-------------------------------------------------------------------------------
function MJLDivQoverall(lp,jp,l,j,bigJ,bigL)

    implicit none
    INTERFACE

        function Qnorm(j)
            implicit none
            REAL(kind=8), INTENT(IN)  :: j
            REAL(kind=8) :: Qnorm
        end function Qnorm

    end INTERFACE

    INTEGER, INTENT(IN) :: lp,jp,l,j,bigJ,bigL
    REAL(kind=8) :: xjp,xj
    REAL(kind=8) :: Pi = 3.1415926535897932
    REAL(kind=8) :: Wigner_6j
    REAL(kind=8) :: MJLDivQoverall

    xjp = dble(jp)/2.0
    xj  = dble(j )/2.0

    ! Error trap
    print*,bigL+j

    MJLDivQoverall = (-1.0)**(bigL+j)* Qnorm(dble(lp))*Qnorm(xjp) &
        *Qnorm(xj)*Qnorm(dble(bigJ))*Qnorm(dble(bigL)) &
        *Wigner_6j(2*lp,jp,1,j,2*l,2*bigJ)/SQRT(4*Pi)

end function MJLDivQoverall


!-------------------------------------------------------------------------------
function MJLDivQsummand1(y,np,lp,jp,n,l,j,bigJ,bigL)

    implicit none
    INTERFACE

        function Qnorm(j)
            implicit none
            REAL(kind=8), INTENT(IN)  :: j
            REAL(kind=8) :: Qnorm
        end function Qnorm

        function BesselElementminus(y,np,lp,n,l,bigL)
            implicit none
            INTEGER, INTENT(IN) :: n, np, l, lp
            integer, INTENT(IN) :: bigL
            REAL(kind=8),    INTENT(IN) :: y
            REAL(kind=8) :: BesselElementminus
        end function BesselElementminus

    end INTERFACE

    INTEGER, INTENT(IN) :: np,lp,jp,n,l,j,bigJ,bigL
    REAL(kind=8), INTENT(IN) :: y
    REAL(kind=8) :: Wigner_3j,Wigner_6j
    REAL(kind=8) :: MJLDivQsummand1

    MJLDivQsummand1 = -SQRT(dble(l)+1.0)*Qnorm(dble(l)+1.0)*Wigner_6j(2*bigL,2,2*bigJ,2*l,2*lp,2*(l+1))  &
        & *Wigner_3j(2*lp,2*bigL,2*(l+1),0,0,0)*BesselElementminus(y,np,lp,n,l,bigL)

end function MJLDivQsummand1


!-------------------------------------------------------------------------------
function MJLDivQsummand2(y,np,lp,jp,n,l,j,bigJ,bigL)

    implicit none
    INTERFACE

        function Qnorm(j)
            implicit none
            REAL(kind=8), INTENT(IN)  :: j
            REAL(kind=8) :: Qnorm
        end function Qnorm

        function BesselElementplus(y,np,lp,n,l,bigL)
            implicit none
            INTEGER, INTENT(IN) :: n, np, l, lp
            integer, INTENT(IN) :: bigL
            REAL(kind=8),    INTENT(IN) :: y
            REAL(kind=8) :: BesselElementplus
        end function BesselElementplus

    end INTERFACE

    INTEGER, INTENT(IN) :: np,lp,jp,n,l,j,bigJ,bigL
    REAL(kind=8), INTENT(IN) :: y
    REAL(kind=8) :: Wigner_3j,Wigner_6j
    REAL(kind=8) :: MJLDivQsummand2, tmp

    tmp = SQRT(dble(l))*Qnorm(dble(l)-1.0)
    print*,'mjl 135',Qnorm(dble(l)-1.0),dble(l),'-1=',dble(l)-1

    MJLDivQsummand2 = SQRT(dble(l))*Qnorm(dble(l)-1.0) &
        *Wigner_6j(2*bigL,2,2*bigJ,2*l,2*lp,2*(l-1))  &
        *Wigner_3j(2*lp,2*bigL,2*(l-1),0,0,0) &
        *BesselElementplus(y,np,lp,n,l,bigL)

end function MJLDivQsummand2


!-------------------------------------------------------------------------------
function MJLDivQ(y,np,lp,jp,n,l,j,bigJ,bigL)

    implicit none
    INTERFACE

        function MJLDivQoverall(lp,jp,l,j,bigJ,bigL)
            implicit none
            INTEGER, INTENT(IN) :: lp,jp,l,j,bigJ,bigL
            REAL(kind=8) :: Pi = 3.1415926535897932
            REAL(kind=8) :: MJLDivQoverall
        end function MJLDivQoverall

        function MJLDivQsummand1(y,np,lp,jp,n,l,j,bigJ,bigL)
            implicit none
            INTEGER, INTENT(IN) :: np,lp,jp,n,l,j,bigJ,bigL
            REAL(kind=8), INTENT(IN) :: y
            REAL(kind=8) :: MJLDivQsummand1
        end function MJLDivQsummand1

        function MJLDivQsummand2(y,np,lp,jp,n,l,j,bigJ,bigL)
            implicit none
            INTEGER, INTENT(IN) :: np,lp,jp,n,l,j,bigJ,bigL
            REAL(kind=8), INTENT(IN) :: y
            REAL(kind=8) :: MJLDivQsummand2
        end function MJLDivQsummand2

    end INTERFACE

     INTEGER, INTENT(IN) :: np,lp,jp,n,l,j,bigJ,bigL
     REAL(kind=8), INTENT(IN) :: y
     REAL(kind=8) :: MJLDivQ, tmp

     MJLDivQ = MJLDivQoverall(lp,jp,l,j,bigJ,bigL) &
         * (MJLDivQsummand1(y,np,lp,jp,n,l,j,bigJ,bigL) &
         +MJLDivQsummand2(y,np,lp,jp,n,l,j,bigJ,bigL))
     tmp = MJLDivQoverall(lp,jp,l,j,bigJ,bigL)
     tmp = MJLDivQsummand2(y,np,lp,jp,n,l,j,bigJ,bigL)
     print*,'mj L180',mjldivq,tmp

end function MJLDivQ



