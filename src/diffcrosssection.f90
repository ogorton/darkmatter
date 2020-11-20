function diffCrossSection(v, q)
    ! Computes the differential cross section per recoil energy ds/dEr
    use kinds
    use masses
    use constants
    implicit none
    interface
         function transition_probability(q,v)
            use kinds
            implicit none
            REAL(doublep), INTENT(IN) :: q
            REAL(doublep), INTENT(IN) :: v
            real(doublep) :: transition_probability
        end function
    end interface
    real(doublep) :: diffCrossSection
    real(doublep) :: v ! velocity of DM particle in lab frame
    real(doublep) :: q


    diffCrossSection = (mtarget*mN/(2.0*pi*v*v)) * transition_probability(q,v)

end function diffCrossSection

function totalcrosssection(v,jchi,Mtiso)

end function totalcrosssection
