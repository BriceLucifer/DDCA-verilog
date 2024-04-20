module top_module (
    input [7:0] in,
    output parity); 

assign parity = ^ in;
// 其实就是in[7] ^ in[6] ^ ... 
endmodule
