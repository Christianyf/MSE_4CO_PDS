
export COCOTB_REDUCED_LOG_FMT
export PYTHONPATH:=$(realpath tests):$(PYTHONPATH)

LANG=vhdl
SIM=ghdl

VHDL_SOURCES= $(PWD)/Cordic.vhd $(PWD)/cordic_mine.vhd
			 
TOPLEVEL=cordic

SIM_ARGS= --wave=cordic_mine.ghw
MODULE ?= test

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.inc
include $(COCOTB)/Makefile.sim

GTK_SAVEFILE := $(wildcard sim_build/*.gtkw)

gtkwave:
	gtkwave sim_build/cordic_mine.ghw $(GTK_SAVEFILE)
