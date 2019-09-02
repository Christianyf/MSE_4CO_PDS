
export COCOTB_REDUCED_LOG_FMT
export PYTHONPATH:=$(realpath tests):$(PYTHONPATH)

LANG=vhdl
SIM=ghdl

VHDL_SOURCES= $(PWD)/encoder.vhd
			 
TOPLEVEL=encoder

SIM_ARGS= --wave=encoder_mine.ghw
MODULE ?= test

COCOTB=$(shell cocotb-config --makefiles)
include $(COCOTB)/Makefile.inc
include $(COCOTB)/Makefile.sim

GTK_SAVEFILE := $(wildcard sim_build/*.gtkw)

gtkwave:
	gtkwave sim_build/encoder_mine.ghw $(GTK_SAVEFILE)
