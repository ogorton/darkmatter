subroutine setparameters

    use constants
    use masses
    use dmparticles
    use velocities
    use targetinfo
    use quadrature 
    use momenta
    use spspace

    implicit none


    print*,'Setting default parameter values.'

    ! Constants
    GeV = 1.0
    femtometer = 5.0677/GeV


    ! Masses
    mV = 246.2
    mN = 0.938272 
    mchi = 50.0
    Mtiso = num_p-num_n
    mtarget = num_p+num_n
    muT = mchi * mtarget * mN / (mchi+mtarget*mN)

    ! Velocities
    ve = 232.0 !km/s earths velocity in the galactic rest frame.
    v0 = 220.0 !km/s velocity distribution scaling
    vesc = 12.0 * v0 !km/s ! infinity

    bfm = (41.467/(45.*(num_n+num_p)**(-1./3) - 25.*(num_n+num_p)**(-2./3)))**0.5 * femtometer 

    ! dm particles
    Nt = 1.0
    jchi=0.5
    rhochi = 1.0

    ! Quadrature
    quadrature_type = 1
    lattice_points = 1000
    vdist_min = q/(2.0*muT)
    vdist_max = 12*v0

end subroutine setparameters

subroutine printparameters

    use constants
    use masses
    use dmparticles
    use velocities
    use targetinfo
    use quadrature
    use momenta
    use spspace

    implicit none

    print*,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print*,'Parameters used in this calculation:'
    print*,'femtometer =',femtometer
    print*,'GeV = ',gev
    print*,'kev = ',kev
    print*,'b[dimless]=',bfm/femtometer
    print*,'b[fm]=',bfm
    print*,'y=',y
    print*,'mN',mN
    print*,'jchi',jchi
    print*,'mchi',mchi
    print*,'J_target=',Jiso
    print*,'T_target=',Tiso
    print*,'Mt_targe=',Mtiso
    print*,'Target Z,N',num_p,num_n
    print*,'mtarget=',mtarget
    print*,'muT=',muT
    print*,'q=',q
    print*,'vdist_max = ',vdist_max
    print*,'Nt',nt
    print*,'rhochi',rhochi
    print*,'v0=',v0
    print*,'ve=',ve
    print*,'Integral lattice size = ',lattice_points
    print*,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

end subroutine printparameters
