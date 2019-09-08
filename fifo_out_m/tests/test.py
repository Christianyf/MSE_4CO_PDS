import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer




@cocotb.coroutine
def reset(dut):
    dut.read_en <= 0
    dut.rst <= 1
    yield Timer(20, units='ns')
    yield RisingEdge(dut.clk)
    dut.rst <= 0
    #dut.en <= 1
    yield RisingEdge(dut.clk)
    dut.rst._log.info("Reset complete")

@cocotb.test()
def test_fifo(dut):

    cocotb.fork(Clock(dut.clk, 10, units='ns').start())
    yield reset(dut)
    dut.bit_i <= 0
    dut.read_en <= 1


    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.bit_i <= 1

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.bit_i <= 0

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.bit_i <= 1

    yield Timer(280, units='ns')
    yield RisingEdge(dut.clk)
    #dut.read_en <= 0
    #dut.bit_i <= 0

    # termina la primera palabra
    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.bit_i <= 0
    #dut.read_en <= 0

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.bit_i <= 0

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.bit_i <= 1

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.bit_i <= 0

    yield Timer(280, units='ns')
    yield RisingEdge(dut.clk)
    dut.bit_i <= 0

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.read_en <= 0

    #for x in range(5):
        #yield RisingEdge(dut.clk)
        #dut.bit_i <= x 

    for _ in range(100):
        yield RisingEdge(dut.clk) 
    
  

    
