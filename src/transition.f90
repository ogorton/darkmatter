function transition_probability(q,v)
    use kinds
    use masses
    use dmresponse
    use dmparticles
    use targetinfo 
    use spspace
    implicit none
    interface 
        function nucResponse(tau1,tau2,ioption,y)
            use kinds
            integer :: tau1, tau2
            integer :: ioption
            real(doublep) :: y
            REAL(doublep) :: nucResponse
        end function
        function dmresponsecoef(ifunc, tau1, tau2, q, v, jchi)
            use kinds
            integer :: ifunc
            integer :: tau1, tau2
            real(doublep) :: q, v, jchi
            REAL(doublep) :: dmresponsecoef
        end function
    end interface
    REAL(doublep) :: q
    REAL(doublep) :: v
    REAL(doublep) :: y
    REAL(doublep) :: transition_probability
    real(doublep) :: pi = 3.14159265358979, tmp, tmp2

    integer :: tau1, tau2, ifunc

    y = (q*bfm/2d0)**2d0

    transition_probability = 0.0

    do tau1 = 0, 1
        do tau2 = 0, 1
            do ifunc = 1, 8
                transition_probability = transition_probability &
                    + dmresponsecoef(ifunc, tau1, tau2, q, v, jchi) &
                    * nucResponse(tau1,tau2,ifunc,y)
            end do ! ifunc
        end do ! tau2
    end do ! tau1

!    print*,'denom',(4.0*mN*mchi)**2.0
    transition_probability = transition_probability * (4.0*pi/(Jiso+1)) / ((4.0*mN*mchi)**2.0)
    
end function transition_probability
