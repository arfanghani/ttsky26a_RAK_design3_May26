`default_nettype none

module tt_um_top (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // =========================
    // INPUT SIGNAL
    // =========================
    wire pulse = ui_in[0];   // FNIRSI input

    // =========================
    // EDGE DETECTOR
    // =========================
    reg pulse_d;
    wire rising_edge;

    assign rising_edge = pulse & ~pulse_d;

    // =========================
    // COUNTER (frequency proxy)
    // =========================
    reg [7:0] counter;

    // =========================
    // STATE OUTPUT
    // =========================
    reg [7:0] result;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pulse_d <= 0;
            counter <= 0;
            result  <= 0;
        end else if (ena) begin
            pulse_d <= pulse;

            // count pulses
            if (rising_edge)
                counter <= counter + 1;

            // classify heat level
            if (counter < 8'd5)
                result <= 8'd0;      // SAFE
            else if (counter < 8'd10)
                result <= 8'd1;      // WARM
            else if (counter < 8'd20)
                result <= 8'd2;      // HIGH RISK
            else
                result <= 8'd3;      // CRITICAL
        end
    end

    assign uo_out = result;

    // unused IOs
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
