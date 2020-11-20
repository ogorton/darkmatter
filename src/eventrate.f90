function EventRate(q)
    ! Computes the differential cross section per recoil energy ds/dEr
    use quadrature
    use kinds
    use dmparticles
    use targetinfo
    use velocities
    use masses
        ! Uses: 
        !    mchi : Dark matter mass
        !    mtarget : nuclear isotope mass
    use constants ! pi
    
    implicit none
    interface
         function transition_probability(q,v)
            use kinds
            implicit none
            REAL(doublep), INTENT(IN) :: q
            REAL(doublep), INTENT(IN) :: v
            real(doublep) :: transition_probability
        end function
        function maxwell_boltzmann(v,v0)
            use kinds
            real(doublep), intent(in) :: v
            real(doublep), intent(in) :: v0
            real(doublep) :: maxwell_boltzmann            
        end function
    end interface
    real(doublep) :: EventRate
    real(doublep) :: q

    real(doublep) :: v  ! DM velocity variable
    real(doublep) :: dv ! DM differential velocity / lattive spacing
    !real(doublep),allocatable :: v_lattice(:) ! velocity domain
    real(doublep), allocatable :: EventRate_integrand(:)
    integer :: i
    real(doublep) :: diffcrosssection

    vdist_min = q/(2d0*muT)
    print*,'Integrating dv from',vdist_min,'to',vdist_max
    dv = (vdist_max-vdist_min)/lattice_points

    allocate(EventRate_integrand(lattice_points))
   
!$OMP parallel do private(v) 
    do i = 1, lattice_points
 
        v = vdist_min + (i-1) * dv
 
        EventRate_integrand(i) = diffCrossSection(v, q)&
                    * v * v * ( maxwell_boltzmann(v-ve,v0) &
                            - maxwell_boltzmann(v+ve,v0) ) 
    end do
!$OMP end parallel do
!$OMP barrier

    print*,'Calling quadrature routine.'
    if (quadrature_type == 1) then    
        call boole(lattice_points,EventRate_integrand,dv,EventRate)
    else
        EventRate = -1
    end if

    EventRate = Nt * (rhochi/Mchi) * EventRate *  (pi*v0**2/(ve))
  
end function EventRate