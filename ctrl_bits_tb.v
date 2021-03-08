module ctrl_bits_tb;
    wire [2:0] ctrl_bits;
    
    wire nothing, shift, add;
    assign nothing = (~ctrl_bits[0] & ~ctrl_bits[1] & ~ctrl_bits[2]) | (ctrl_bits[0] & ctrl_bits[1] & ctrl_bits[2]);
    assign shift = (ctrl_bits[0] & ctrl_bits[1] & ~ctrl_bits[2]) | (~ctrl_bits[0] & ~ctrl_bits[1] & ctrl_bits[2]);    
    assign add = (~ctrl_bits[2]) | (ctrl_bits[0] & ctrl_bits[1] & ctrl_bits[2]);
    
    wire [5:0] shift_out;
    assign shift_out = 1'b1 ? ~6'b101101 : 6'b101101;

    integer i;
    assign {ctrl_bits} = i[2:0];
    initial begin
        for (i = 0; i < 8; i = i+1) begin
            #20;
            $display("ctrl_bits: %b => nothing: %b, shift: %b, add: %b, shift_out: %b", ctrl_bits, nothing, shift, add, shift_out);
        end
        $finish;
    end
endmodule