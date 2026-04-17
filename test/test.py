import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


@cocotb.test()
async def test_heat_alert(dut):

    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await ClockCycles(dut.clk, 2)
    dut.rst_n.value = 1

    # generate pulses (simulate FNIRSI frequency)
    for i in range(30):
        dut.ui_in.value = 1
        await RisingEdge(dut.clk)

        dut.ui_in.value = 0
        await RisingEdge(dut.clk)

        state = int(dut.uo_out.value)
        dut._log.info(f"Cycle {i} | State={state}")

    # clean finish
    dut.ui_in.value = 0
    await ClockCycles(dut.clk, 5)
