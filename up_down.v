module updown_count(
    input clk,
    input clear,
    input load,
    input up_down,
    input [7:0] d,
    output [7:0] qd
);
    reg [7:0] cnt;
    assign qd = cnt;

    always @(posedge clk) begin
        if (!clear) begin
            cnt <= 8'h00;  // 同步清零，低电平有效
        end else if (load) begin
            cnt <= d;      // 同步预置
        end else if (up_down) begin
            cnt <= cnt + 1; // 加法计数
        end else begin
            cnt <= cnt - 1; // 减法计数
        end
    end
endmodule

module top_module();
    reg clk = 0;
    reg clear;
    reg load;
    reg up_down;
    reg [7:0] d;
    wire [7:0] qd;

    // Instantiate the updown_count module
    updown_count uut (
        .clk(clk),
        .clear(clear),
        .load(load),
        .up_down(up_down),
        .d(d),
        .qd(qd)
    );

    // Clock generation with a period of 10 units
    always #5 clk = ~clk;
    
    initial `probe_start;

    // Probing signals
    `probe(clk);
    `probe(clear);
    `probe(load);
    `probe(d);
    `probe(up_down);
    `probe(qd);
    

    // Test sequence in an initial block
    initial begin
        clear = 1; load = 0; up_down = 0; d = 8'h00;

        // Initial reset
        #10 clear = 0; // Active low clear
        #10 clear = 1; // Stop reset

        // Load a value
        #10 d = 8'h55; load = 1;
        #10 load = 0;

        // Count up
        #10 up_down = 1; // Start counting up
        #30 up_down = 0; // Stop counting up

        // Count down
        #10 up_down = 0; // Start counting down
        #30;

        // Final state
        #10 $display("Final output: qd = %b", qd);
        #10 $finish;
    end
    
endmodule

