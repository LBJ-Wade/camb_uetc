#CAMB Makefile

NAG_DIR = /opt/NAG/fll6i23dcl
#CERN_LIB = /usr/lib64/cernlib/2006/lib
#CERN_LIB = /usr/lib64/cernlib/2006/x86_64-slc5-gcc43-opt/lib
#CERN_INC = /usr/include/cernlib/2006
#CERN_INC = /home/adammoss/cernlib/tmp/2006b/include

#Set FISHER=Y to compile bispectrum fisher matrix code
FISHER=Y

#Edit for your compiler
#Note there are many old ifc versions, some of which behave oddly

#Intel , -openmp toggles mutli-processor:
#note version 10.0 gives wrong result for lensed when compiled with -openmp [fixed in 10.1]
F90C     = ifort
FFLAGS = -openmp -O3 -W0 -WB -fpp2 -vec_report0 
ifneq ($(FISHER),)
FFLAGS += -mkl
endif
FFLAGS += -I$(NAG_DIR)/nag_interface_blocks  
FFLAGS += -lcfitsio
LIBS   =  $(NAG_DIR)/lib/libnag_mkl.a \
                    -Wl,--start-group $(NAG_DIR)/mkl_intel64/libmkl_intel_lp64.a \
                                      $(NAG_DIR)/mkl_intel64/libmkl_intel_thread.a \
                                      $(NAG_DIR)/mkl_intel64/libmkl_core.a -Wl,--end-group \
				-liomp5 -lpthread 

#Gfortran compiler:
#The options here work in v4.5, delete from RHS in earlier versions (15% slower)
#if pre v4.3 add -D__GFORTRAN__
#With v4.6+ try -Ofast -march=native -fopenmp
#On my machine v4.5 is about 20% slower than ifort
#F90C     = gfortran
#FFLAGS =  -O3 -fopenmp -ffast-math -march=native -funroll-loops


#Old Intel ifc, add -openmp for multi-processor (some have bugs):
#F90C     = ifc
#FFLAGS = -O2 -Vaxlib -ip -W0 -WB -quiet -fpp2
#some systems can can also add e.g. -tpp7 -xW

#GFortran compiler
#F90C   = gfortran
#FFLAGS = -O2 -lblas -llapack

#SGI, -mp toggles multi-processor. Use -O2 if -Ofast gives problems.
#F90C     = f90
#FFLAGS  = -Ofast -mp

#Digital/Compaq fortran, -omp toggles multi-processor
#F90C    = f90
#FFLAGS  = -omp -O4 -arch host -math_library fast -tune host -fpe1

#Absoft ProFortran, single processor:
#F90C     = f95
#FFLAGS = -O2 -cpu:athlon -s -lU77 -w -YEXT_NAMES="LCS" -YEXT_SFX="_"

#NAGF95, single processor:
#F90C     = f95
#FFLAGS = -DNAGF95 -O3

#PGF90
#F90C = pgf90
#FFLAGS = -O2 -DESCAPEBACKSLASH -Mpreprocess

#Sun V880
#F90C = mpf90
#FFLAGS =  -O4 -openmp -ftrap=%none -dalign -DMPI

#Sun parallel enterprise:
#F90C     = f95
#FFLAGS =  -O2 -xarch=native64 -openmp -ftrap=%none
#try removing -openmp if get bus errors. -03, -04 etc are dodgy.

#IBM XL Fortran, multi-processor (run gmake)
#F90C     = xlf90_r
#FFLAGS  = -DESCAPEBACKSLASH -DIBMXL -qsmp=omp -qsuffix=f=f90:cpp=F90 -O3 -qstrict -qarch=pwr3 -qtune=pwr3

#Settings for building camb_fits
#Location of FITSIO and name of library
FITSDIR       = /home/cpac/cpac-tools/lib
FITSLIB       = cfitsio
#Location of HEALPIX for building camb_fits
HEALPIXDIR    = /home/cpac/cpac-tools/healpix

ifneq ($(FISHER),)
FFLAGS += -DFISHER
EXTCAMBFILES = Matrix_utils.o
else
EXTCAMBFILES =
endif

include ./Makefile_main
