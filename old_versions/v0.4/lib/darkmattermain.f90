
!  ctrlchar = 'c'  count up # of states
!  ctrlchar = 'f'  fill up info on states
!  ctrlchar = 'p'  fill up parent reference states
!  ctrlchar = 'd'  fill up daughter reference states

!================================================

program darkmattermain
    use response
    use spspace
    use stateinfo
    use masses
    implicit none

    interface
        subroutine openresults(resfile)
            use stateinfo
            implicit none
            integer resfile
            character(22):: filename
        end subroutine openresults
        function transition_probability(q,v,jchi,y,Mtiso)
            implicit none
            REAL(kind=8), INTENT(IN) :: q
            REAL(kind=8), INTENT(IN) :: v
            REAL(kind=8), INTENT(IN) :: jchi
            REAL(kind=8), INTENT(IN) :: y
            integer, intent(in) :: Mtiso
            real(kind=8) :: transition_probability
        end function
    end interface

    integer, parameter :: resfile = 33
    integer :: ap, an, Mtiso

    ! TEST BLOCK <<<<<<
    real(kind=8) :: transprob
    real(kind=8) :: q,v,jchi,y
    REAL(kind=8) :: nucResponse
    real(kind=8) :: femtometer, GeV

    GeV = 1.0
    femtometer = 5.0677/GeV
    q=1.*GeV
    v=1.
    jchi=.5
    mchi=50.

    allocate(cvec(1)%c(17))
    allocate(cvec(0)%c(17))
    cvec(0)%c = 0.0
    cvec(0)%c = 0.0

    call opencoeffmatrix(2)
    call readcoeffmatrix(2)
    call normalizecoeffs

    ! >>>>>>> END TEST BLOCK
    
    call GetSPS

    print*,' '
    print*,' Reading one-body density matrix from Bigstick .res file '
    print*,' '

    nsporb = norb(1)

    call openresults(resfile)
    call setupdensities
    call readheaderv2(resfile)
    call readalldensities(resfile)
!    call printdensities

    print*,' '
    print*,' Enter the neutron number '
    read(5,*)an
    print*,' '
    print*,' Enter the proton number '
    read(5,*)ap

    bfm = (41.467/(45.*(an+ap)**(-1./3) - 25.*(ap+an)**(-2./3)))**0.5 * femtometer
    y = (q*bfm/(2.0*0.197*GeV*femtometer))**2.0
!    y = (q*bfm/2.0)**2.0
    y = 19.9382 

    print*,'b[dimless]=',bfm/femtometer
    print*,'b[fm]=',bfm
    print*,'y=',y
    print*,'cpvec(3)',cvec(0)%c(3)
    print*,'mN',mN
    print*,'mchi',mchi

    Mtiso = (ap-an)
    Miso = ap+an
    muT = mchi * Miso * mN / (mchi+Miso*mN)
    print*,'Jiso, Tiso=',Jiso,Tiso

    print*,'Mtiso=',Mtiso
    print*,'Miso=',Miso
    print*,'muT=',muT

    transprob = transition_probability(q,v,jchi,y,Mtiso)/(4.0*mN*mchi)**2.0
   
    print*,"Transition probability =",transprob

end program  
