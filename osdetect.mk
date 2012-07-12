PLATFORM:=$(shell uname -s)

ifneq (,$(findstring MINGW32,$(PLATFORM)))
	OS_WIN:=TRUE
	PLATFORM:=win32
endif

ifeq ($(PLATFORM),Linux)
	OS_LINUX:=TRUE
	PLATFORM:=linux
endif

ifeq ($(PLATFORM),Darwin)
	OS_OSX:=TRUE
	PLATFORM:=osx
endif

ifdef OS_WIN
	ifdef PROCESSOR_ARCHITEW6432
		ARCH_TYPE?=$(PROCESSOR_ARCHITEW6432)
		ifeq ($(ARCH_TYPE),AMD64)
			ARCH_TYPE:=x86_64
		endif
	else
		ARCH_TYPE?=$(PROCESSOR_ARCHITECTURE)
	endif
else
	ARCH_TYPE?=$(shell uname -m)
endif
