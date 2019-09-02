
export COCOTB_REDUCED_LOG_FMT
export PYTHONPATH:=$(realpath tests):$(PYTHONPATH)

LANG=vhdl
SIM=ghdl

VHDL_SOURCES= $(PWD)/branch.vhd $(PWD)/piso.vhd $(PWD)/encoder.vhd $(PWD)/mapping.vhd
			 
TOPLEVEL=rama

SIM_ARGS= --wave=rama_mine.ghw
MODULE ?= test

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.inc
include $(COCOTB)/Makefile.sim

GTK_SAVEFILE := $(wildcard sim_build/*.gtkw)

gtkwave:
	gtkwave sim_build/rama_mine.ghw $(GTK_SAVEFILE)
