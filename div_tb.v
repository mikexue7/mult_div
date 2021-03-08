module div_tb;
    wire clock, exception;
    wire [31:0] dividend, div, count, quotient, remainder;

    counter div_counter(clock, 1'b0, count);
    div divider(dividend, div, clock, count, quotient, remainder, exception);

    assign dividend = 32'b100011;
    assign div = 32'b10000;

    integer i;
    integer j = 0;
    assign clock = j;
    initial begin
        for (i = 0; i < 66; i = i+1) begin
            #20;
            $display("clock: %b, count: %b => quotient: %b, remainder: %b, exception: %b", clock, count, quotient, remainder, exception);
            j = !j;
        end
        $finish;
    end
endmodule