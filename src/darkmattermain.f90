program darkmattermain
    use response
    use spspace
    use targetinfo
    use masses
    use kinds
    use constants
    use dmparticles
    use velocities
    use momenta
    use quadrature
    use espectra
    implicit none

    integer :: resfile = 100
    real(kind=8) :: output, v
    real(doublep) :: diffCrossSection
    real(doublep) :: transition_probability
    character :: yn
    integer :: computeoption

    print*,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print*,'Welcome to our FORTAN 90 implementation of the WIMP-nucleon scattering code.'
    print*,'Based on the Mathematica script described in arXiv:1308.6288 (2003).'
    print*,'  VERSION 1.1 UPDATED: 2020.05.23 @ SDSU'
    print*,'  Dev. contact: cjohnson@sdsu.edu'
    print*,'                 ogorton@sdsu.edu'
    print*,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    print*,''
    print*,'Select an option:'
    print*,'[1] Event rate per detector per target nucleus per unit recoil energy spectra'
    print*,'[2] Scattering probability'
    print*,'[3] Differential cross section per recoil energy'
    print*,'[4] (Future feature) Total cross section'
    print*,'[5] (Future feature) Total scattering rate per detector'
    print*,'[6] (Future feature) '
    read*,computeoption

    if (computeoption==2.or.computeoption==3) then
        print*,"Enter darkmatter velocity:"
        read*,v
    endif

    print*,' '
    print*,'Enter the target neutron number '
    read(5,*)num_n
    print*,' '
    print*,'Enter the target proton number '
    read(5,*)num_p

    call setparameters
    call setupcoef

    call opencontrolfile(2)
    call readcontrolfile(2)
    call normalizecoeffs
    call convertisospinform

    call GetSPS

    nsporb = norb(1)

    call openresults(resfile)
    call setupdensities
    call readheaderv2(resfile)
    call readalldensities(resfile)

    print*,'Fill core? [y/n]'
    read*,yn
    if (yn=='y') then
        call coredensity
    end if
  
    call printdensities
    call printparameters

    if (computeoption == 1) then
        call eventrate_spectra
    else if (computeoption == 2) then
        output = transition_probability(q,v,jchi,y)
        print*,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
        print*,'Scattering probability = ',output
        print*,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    else if (computeoption == 3) then
        output = diffCrossSection(v, q, jchi, y, Mtiso)
        print*,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
        print*,'Differential cross section = ',output
        print*,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
    endif

end program  