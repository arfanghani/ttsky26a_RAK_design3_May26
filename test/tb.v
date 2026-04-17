`default_nettype none
`timescale 1ns / 1ps

module tb;

  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;

  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // DUT
  tt_um_top dut (
      .ui_in(ui_in),
      .uio_in(uio_in),
      .uo_out(uo_out),
      .uio_out(uio_out),
      .uio_oe(uio_oe),
      .ena(ena),
      .clk(clk),
      .rst_n(rst_n)
  );

  // clock
  always #10 clk = ~clk;

  // VCD dump
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    $dumpvars(1, dut);
  end

  initial begin
    clk = 0;
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;

    #25;
    rst_n = 1;

    // simulate pulse input (like FNIRSI)
    repeat (40) begin
      ui_in[0] = 1;
      #20;
      ui_in[0] = 0;
      #40;
    end

    #200;
    $finish;
  end

  initial begin
    $monitor("Time=%0t | pulse=%b | count=%d | state=%d",
      $time, ui_in[0], dut.counter, uo_out);
  end

endmodule
