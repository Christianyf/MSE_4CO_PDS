import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer




@cocotb.coroutine
def reset(dut):
    dut.write_en <= 0
    dut.rst <= 1
    yield Timer(20, units='ns')
    yield RisingEdge(dut.clk)
    dut.rst <= 0
    dut.d_last <= 1
    yield RisingEdge(dut.clk)
    dut.rst._log.info("Reset complete")

@cocotb.test()
def test_piso(dut):
    data=[8,10,2147483648]

    cocotb.fork(Clock(dut.clk, 10, units='ns').start())
    yield reset(dut)

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    #dut.write_en <= 1

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.data_i <= data[0]
    dut.write_en <= 1
    
    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.data_i <= data[1]

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.data_i <= data[2]

    yield Timer(10, units='ns')
    yield RisingEdge(dut.clk)
    dut.write_en <= 0


    yield Timer(20, units='ns')
    yield RisingEdge(dut.clk)
    #dut.write_en <= 1
    for _ in range(100):
        yield RisingEdge(dut.clk)    

    
