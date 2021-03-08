module mult(multcand, mult, clk, count, product, overflow);
    input [31:0] multcand, mult, count;
    input clk;
    output [31:0] product;
    output overflow;

    // assign input
    wire signed [64:0] running_prod_init, running_prod, running_prod_out, in;
    assign running_prod_init[0] = 1'b0;
    assign running_prod_init[32:1] = mult[31:0];
    assign running_prod_init[64:33] = 32'b0;
    assign in = (~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4]) ? running_prod_init : running_prod >>> 2;

    product_reg prod(in, clk, 1'b1, 1'b1, reset, running_prod_out);

    // check ctrl bits for next add/sub
    wire [2:0] ctrl_bits;
    assign ctrl_bits = running_prod_out[2:0];

    wire nothing, shift, add;
    assign nothing = (~ctrl_bits[0] & ~ctrl_bits[1] & ~ctrl_bits[2]) | (ctrl_bits[0] & ctrl_bits[1] & ctrl_bits[2]);
    assign shift = (ctrl_bits[0] & ctrl_bits[1] & ~ctrl_bits[2]) | (~ctrl_bits[0] & ~ctrl_bits[1] & ctrl_bits[2]);    
    assign add = (~ctrl_bits[2]) | (ctrl_bits[0] & ctrl_bits[1] & ctrl_bits[2]);

    wire [31:0] nothing_out, shift_out;
    assign nothing_out = nothing ? 32'b0 : multcand;
    assign shift_out = shift ? nothing_out << 1 : nothing_out;

    // next unshifted input into product register
    wire [31:0] x, y, sum;
    assign x = running_prod_out[64:33];
    assign y = add ? shift_out : ~shift_out;
    cla_full_adder adder(x, y, ~add, x | y, x & y, sum);
    assign running_prod[64:33] = sum;

    assign running_prod[32:0] = running_prod_out[32:0];

    // output
    assign product = running_prod_out[32:1];

    // overflow
    wire special_overflow; // for case when multcand is largest negative number (has no 2's complement)
    assign special_overflow = multcand[31] & mult[31] & product[31];

    assign overflow = special_overflow | ~((running_prod_out[64] & running_prod_out[63] & running_prod_out[62] & 
        running_prod_out[61] & running_prod_out[60] & running_prod_out[59] & running_prod_out[58] & 
        running_prod_out[57] & running_prod_out[56] & running_prod_out[55] & running_prod_out[54] & 
        running_prod_out[53] & running_prod_out[52] & running_prod_out[51] & running_prod_out[50] & 
        running_prod_out[49] & running_prod_out[48] & running_prod_out[47] & running_prod_out[46] & 
        running_prod_out[45] & running_prod_out[44] & running_prod_out[43] & running_prod_out[42] & 
        running_prod_out[41] & running_prod_out[40] & running_prod_out[39] & running_prod_out[38] & 
        running_prod_out[37] & running_prod_out[36] & running_prod_out[35] & running_prod_out[34] & 
        running_prod_out[33] & running_prod_out[32]) | (~running_prod_out[64] & ~running_prod_out[63] & 
        ~running_prod_out[62] & ~running_prod_out[61] & ~running_prod_out[60] & ~running_prod_out[59] & 
        ~running_prod_out[58] & ~running_prod_out[57] & ~running_prod_out[56] & ~running_prod_out[55] & 
        ~running_prod_out[54] & ~running_prod_out[53] & ~running_prod_out[52] & ~running_prod_out[51] & 
        ~running_prod_out[50] & ~running_prod_out[49] & ~running_prod_out[48] & ~running_prod_out[47] & 
        ~running_prod_out[46] & ~running_prod_out[45] & ~running_prod_out[44] & ~running_prod_out[43] & 
        ~running_prod_out[42] & ~running_prod_out[41] & ~running_prod_out[40] & ~running_prod_out[39] & 
        ~running_prod_out[38] & ~running_prod_out[37] & ~running_prod_out[36] & ~running_prod_out[35] & 
        ~running_prod_out[34] & ~running_prod_out[33] & ~running_prod_out[32]));
        
endmodule