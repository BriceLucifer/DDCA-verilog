module top_module();
    reg clk = 0;      // Clock signal
    reg j = 0;        // J input
    reg k = 0;        // K input
    reg set = 1;      // Asynchronous set input
    reg rs = 1;       // Asynchronous reset input
    wire q;           // Output of JK flip-flop

    // Instantiate the JK flip-flop
    jkff_rs inst1 (clk, j, k, set, rs, q);

    // Clock generation with a period of 10 units
    always #5 clk = ~clk;

    // Start the timing diagram
    initial `probe_start;

    // Probing signals
    `probe(clk);
    `probe(j);
    `probe(k);
    `probe(set);
    `probe(rs);
    `probe(q);

    // Test sequence in an initial block
    initial begin
        // Initial reset conditions
        rs = 0;
        #10 rs = 1;     // Release reset

        // Test set condition
        set = 0;
        #10 set = 1;    // Release set

        // Stimulate JK flip-flop inputs
        #10 j = 1; k = 0;  // Set mode
        #20 j = 0; k = 1;  // Reset mode
        #20 j = 1; k = 1;  // Toggle mode
        #20 j = 0; k = 0;  // No change mode

        // Additional delay for observing the last state change
        #10;
        $display("Hello world! The current time is (%0d ps)", $time);

        // Finish the simulation after 50 time units from the last command
        #50 $finish;
    end
endmodule


module jkff_rs (
    input clk, j, k, set, rs,
    output reg q
);
    always @(posedge clk, negedge rs, negedge set) begin
        if (!rs)
            q <= 1'b0;
        else if (!set)
            q <= 1'b1;
        else begin
            case ({j, k})
                2'b00: q <= q;
                2'b01: q <= 1'b0;
                2'b10: q <= 1'b1;
                2'b11: q <= ~q;
            endcase
        end
    end
endmodule

