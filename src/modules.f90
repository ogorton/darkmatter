!===============================================================================
module kinds
    implicit none
    integer,parameter :: doublep = kind(1.d0)
    integer :: keylength = 20

end module kinds

!===============================================================================
module parameters

    use kinds

    implicit none

    integer :: num_response_coef
    
    ! Nonrelativistic operator coefficients
    type coeff
        real(kind=8), dimension(:), allocatable :: c
    end type coeff
 
    type eftheory
        type(coeff) :: isoc(0:1) !c0 = (cp+cn)/2   c1 = (cp-cn)/2
        type(coeff) :: xpnc(0:1) !0 = protons, 1 = neutrons
    end type eftheory
    
    !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ! Dark matter particles
    type particle
        real(doublep) :: j = 0.5d0! darkmatter spin
        real(doublep) :: mass = 50.0d0
        real(doublep) :: localdensity = 0.3d0
    end type particle

   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   ! Target nucleus
   logical :: fillcore = .true.
   logical :: evenA
   integer nlocalstates !,maxlocalstates
   integer nsporb   ! # of single-particle orbits
   integer jt, tt   ! spin, isospin of transition operator
   logical ::  pndens ! true: proton-neutron format density matrices.
                      ! false: isospin-conserving format density matrices

   type onebdenmat
       logical good
       real(doublep), allocatable :: rho(:,:,:,:)
       real(doublep), allocatable :: rhop(:,:,:),rhon(:,:,:)  ! added in version 9
   end type onebdenmat
   !type (onebdenmat) :: densitymats

   type state
       integer Jx2 ! spin times 2
       integer Tx2 ! isospin times 2
   end type state

   type nucleus
       integer :: Z
       integer :: N
       integer :: Mt
       real(doublep) :: mass
       real(doublep) :: Nt ! Number of target nuclei
       type(state) :: groundstate

       type (onebdenmat) :: densitymats
       logical :: evenA
   end type nucleus

end module parameters

!===============================================================================
module spspace
    implicit none
    ! Harmonic oscillator parameter
    real(kind=8) :: bfm = 0.0
    !------------------SINGLE-PARTICLE STATES---------------------------   

    integer norb(2)                ! # of single-particle j-orbits
                                   ! 1 = p,  2 = n
    integer nsps(2)                ! # of single-particle m-states
                                   ! 1 = p, 2 = n
    integer ncore(2)               ! # of single-particle j-orbits in the core
                                   ! 1 = p,  2 = n
    integer ntotal(2)
    integer,allocatable  :: jorb(:)     ! 2 x J of orbit (note: p,n different)
    integer,allocatable  :: lorb(:)
    integer,allocatable  :: nrorb(:)    ! radial quantum number N of j-orbit
    integer,allocatable  :: torb(:)     ! 2 x Tz of orbit ( p/n = +/-1 )
    integer,allocatable  :: nprincipal(:)
    integer,allocatable  :: nodal(:)
    logical spinless
end module spspace

!===============================================================================
module momenta
    use kinds
    implicit none

    logical :: usemomentum = .false.
    logical :: useenergyfile = .false.

end module momenta


!===============================================================================
module constants
    use kinds
    implicit none
    real(doublep) :: pi = 3.14159265358979323846264338327950288419716939937510
    real(doublep) :: GeV = 1d0
    real(doublep) :: kev = 10d0**(-6)
    real(doublep) :: femtometer = 5.0677d0 ! /GeV
    real(doublep) :: centimeter = 5.0677d0*10d0**13d0
    real(doublep) :: kilometerpersecond = 3.33564d0 * 10d0**(-6d0)
    real(doublep) :: kilogramday = 7.3634d0*10d0**55d0
    real(doublep) :: mn = 0.938272d0
    real(doublep) :: mv = 246.2d0
    type vdist
        real(doublep) :: vearth !km/s
        REAL(kind=8) :: vescape ! km/s
        REAL(kind=8) :: vscale ! km/s 
    end type vdist
    type(vdist) :: vdist_t
            
end module constants

!===============================================================================
module quadrature
    use kinds
    implicit none

    integer :: quadrature_type
    integer :: lattice_points
    real(doublep) :: vdist_min
    real(doublep) :: vdist_max

end module quadrature

!===============================================================================
module keywords
    implicit none

    ! Do not change the order of these keywords!!! Their order determines which
    ! parameters are modified when the string is found in the control file.
    character(len=20), dimension(18) :: keyword_array = [character(20) :: &
        "coefnonrel","vearth","dmdens","quadtype","intpoints","gev","femtometer",&
        "wimpmass","vescape","ntarget","weakmscale","vscale","mnucleon","dmspin",&
        "usemomentum","maxwellv0","useenergyfile","fillnuclearcore"]

end module keywords
