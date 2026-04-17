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
    // INPUT
    // =========================
    wire pulse = ui_in[0];

    // =========================
    // STATE REGISTERS
    // =========================
    reg pulse_d;
    reg [7:0] counter;
    reg [7:0] result;

    wire rising_edge = pulse & ~pulse_d;

    // =========================
    // MAIN LOGIC
    // =========================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pulse_d <= 1'b0;
            counter <= 8'd0;
            result  <= 8'd0;
        end else if (ena) begin
            pulse_d <= pulse;

            // count pulses
            if (rising_edge)
                counter <= counter + 1;

            // classification output
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

    // =========================
    // OUTPUT
    // =========================
    assign uo_out = result;

    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

endmodule
