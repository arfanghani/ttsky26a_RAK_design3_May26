import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_heat_alert(dut):

    # FIXED LINE
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    for _ in range(5):
        await RisingEdge(dut.clk)

    dut.rst_n.value = 1

    for i in range(40):
        dut.ui_in.value = 1
        await RisingEdge(dut.clk)

        dut.ui_in.value = 0
        await RisingEdge(dut.clk)

        if dut.uo_out.value.is_resolvable:
            state = int(dut.uo_out.value)
            dut._log.info(f"step={i} state={state}")
