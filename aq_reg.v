module aq_reg(in, clock, in_enable, out_enable, reset, out);
    input [63:0] in;
    input clock, in_enable, out_enable, reset;
    output [63:0] out;

    wire [63:0] q;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin: loop
            dffe_ref dffe(q[i], in[i], clock, in_enable, reset);
            assign out[i] = out_enable ? q[i] : 1'bz;
        end
    endgenerate
    
endmodule