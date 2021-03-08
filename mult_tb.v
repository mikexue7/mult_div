module mult_tb;
    wire clock, overflow;
    wire [31:0] multcand, mult, count, product;

    counter mult_counter(clock, 1'b0, count);
    mult multiplier(multcand, mult, clock, count, product, overflow);

    assign multcand = 32'b10000000000000000000000000000000;
    assign mult = 32'b11111111111111111111111111111111;

    integer i;
    integer j = 0;
    assign clock = j;
    initial begin
        for (i = 0; i < 34; i = i+1) begin
            #20;
            $display("clock: %b, count: %b => product: %b, overflow: %b", clock, count, product, overflow);
            j = !j;
        end
        $finish;
    end
endmodule