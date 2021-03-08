module counter_tb;
    wire clock, reset;
    assign reset = 1'b0;
    
    wire [31:0] out;
    counter c(clock, reset, out);

    integer i;
    integer j = 0;
    assign clock = j;
    initial begin
        for (i = 0; i < 34; i = i+1) begin
            #40;
            $display("clock: %b => count: %b", clock, out);
            j = !j;
        end
        $finish;
    end
endmodule