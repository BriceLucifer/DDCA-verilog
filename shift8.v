module shift8 (
    input din,
    input clk,
    input clr,
    output reg [7:0] dout
);
    always @(posedge clk) begin
        if (clr) begin
            dout <= 8'b0;  // 同步清零
        end else begin
            dout <= dout << 1;  // 左移一位
            dout[0] <= din;     // 将输入数据位填充到最低位
        end
    end
endmodule

module top_module;
    reg din;
    reg clk = 0;
    reg clr;
    wire [7:0] dout;

    // 实例化 shift8 模块
    shift8 uut (
        .din(din),
        .clk(clk),
        .clr(clr),
        .dout(dout)
    );

    // 生成时钟信号
    always #5 clk = ~clk;

    // 测试序列
    initial begin
        // 初始化信号
        clr = 1; din = 0;
        #10 clr = 0;  // 释放复位

        // 输入序列
        #10 din = 1;  // 输入序列开始
        #10 din = 0;
        #10 din = 1;
        #10 din = 1;
        #10 din = 0;
        #10 din = 0;
        #10 din = 1;
        #10 din = 1;  // 输入序列结束

        // 检查结果
        #10;
        $display("Output: %b", dout);  // 显示移位寄存器的输出
        $finish;  // 结束仿真
    end

    initial `probe_start;

    // Probing signals
    `probe(clk);
    `probe(clr);
    `probe(din);
    `probe(dout);
    
endmodule
