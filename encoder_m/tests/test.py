import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer

@cocotb.coroutine
def reset(dut):
    dut.en <= 0
    dut.rst <= 1
    yield Timer(20, units='ns')
    yield RisingEdge(dut.clk)
    dut.rst <= 0
    #dut.en <= 1
    yield RisingEdge(dut.clk)
    dut.rst._log.info("Reset complete")

@cocotb.test()
def test_encoder(dut):

    cocotb.fork(Clock(dut.clk, 10, units='ns').start())
    yield reset(dut)
    
    dut.b_in <= 1

    yield Timer(20, units='ns')
    yield RisingEdge(dut.clk)
    dut.en <= 1
    for _ in range(10):
        yield RisingEdge(dut.clk)    

    
