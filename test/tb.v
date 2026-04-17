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

  // =========================
  // DUT
  // =========================
  tt_um_arfanghani_design3_top dut (
      .ui_in(ui_in),
      .uio_in(uio_in),
      .uo_out(uo_out),
      .uio_out(uio_out),
      .uio_oe(uio_oe),
      .ena(ena),
      .clk(clk),
      .rst_n(rst_n)
  );

  // =========================
  // CLOCK
  // =========================
  always #10 clk = ~clk;

  // =========================
  // WAVE DUMP
  // =========================
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // =========================
  // STIMULUS
  // =========================
  initial begin
    clk = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;
    rst_n = 0;

    // safe reset delay
    repeat (5) @(posedge clk);
    rst_n = 1;

    // FNIRSI-like pulse input
    repeat (40) begin
      ui_in[0] = 1;
      #20;
      ui_in[0] = 0;
      #40;
    end

    #200;
    $finish;
  end

  // =========================
  // MONITOR
  // =========================
  initial begin
    $monitor("t=%0t | pulse=%b | uo_out=%d",
      $time, ui_in[0], uo_out);
  end

endmodule
