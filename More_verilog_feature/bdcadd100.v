module top_module( 
    input [399:0] a, b,
    input cin,
    output cout,
    output [399:0] sum );
    
    wire [3:0] sum0;
    wire [99:0] cout100;
    
    bcd_fadd add1( 
                .a(a[3:0]),
                .b(b[3:0]),
                .cin(cin),
                .cout(cout100[0]),
                .sum(sum[3:0])
                );

    
    genvar i ;
    generate
        for(i=4;i<400;i=i+4)
            begin:adder
                bcd_fadd inst(
                    .a(a[i+3:i]),
                    .b(b[i+3:i]),
                    .cin(cout100[i/4-1]),
                    .cout(cout100[i/4]),                              .sum(sum[i+3:i])
                );
            end
    endgenerate

                assign cout = cout100[99];

endmodule


module bcd_fadd (
    input [3:0] a,
    input [3:0] b,
    input     cin,
    output   cout,
    output [3:0] sum );
    
endmodule