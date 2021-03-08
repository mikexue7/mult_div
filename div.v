module div(dividend, div, clk, count, quotient, remainder, exception);
    input [31:0] dividend, div, count;
    input clk;
    output [31:0] quotient, remainder;
    output exception;

    // check if dividend or divisor are negative, turn them into positive
    wire [31:0] dividend_fixed, div_fixed;
    wire neg_dividend, neg_div;
    assign neg_dividend = dividend[31];
    assign neg_div = div[31];

    wire [31:0] x1, y1;
    assign x1 = neg_dividend ? ~dividend : dividend;
    assign y1 = 32'b0;
    cla_full_adder dividend_adder(x1, y1, neg_dividend, x1 | y1, x1 & y1, dividend_fixed);

    wire [31:0] x2, y2;
    assign x2 = neg_div ? ~div : div;
    assign y2 = 32'b0;
    cla_full_adder div_adder(x2, y2, neg_div, x2 | y2, x2 & y2, div_fixed);

    // assign input to register
    wire [63:0] aq_init, aq, in, aq_out;
    assign aq_init[31:0] = dividend_fixed;
    assign aq_init[63:32] = 32'b0;
    assign in = (~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & ~count[5]) ? aq_init : aq;

    aq_reg aq_register(in, clk, 1'b1, 1'b1, reset, aq_out);

    // perform sum and assign aq
    wire [63:0] aq_shifted;
    assign aq_shifted = aq_out << 1;

    wire [31:0] x3, y3, sum, last_sum;
    assign x3 = aq_shifted[63:32];
    assign y3 = aq_out[63] ? div_fixed : ~div_fixed;
    cla_full_adder main_adder(x3, y3, ~aq_out[63], x3 | y3, x3 & y3, sum);
    cla_full_adder last_adder(sum, div_fixed, 1'b0, sum | div_fixed, sum & div_fixed, last_sum); // for last iteration
    assign aq[63:32] = ((~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & count[5]) & sum[31]) ? last_sum : sum;
    assign aq[31:1] = aq_shifted[31:1];
    assign aq[0] = ~sum[31];

    // fixed output
    wire [31:0] x4, y4, quotient_no_exception;
    wire neg_quotient;
    xor check_neg_quotient(neg_quotient, neg_dividend, neg_div);
    assign x4 = neg_quotient ? ~aq_out[31:0] : aq_out[31:0];
    assign y4 = 32'b0;
    cla_full_adder out_adder(x4, y4, neg_quotient, x4 | y4, x4 & y4, quotient_no_exception);

    assign quotient = exception ? 32'b0 : quotient_no_exception;
    assign remainder = aq_out[63:32];

    // exception
    assign exception = ~div[31] & ~div[30] & ~div[29] & ~div[28] & ~div[27] & ~div[26] & 
        ~div[25] & ~div[24] & ~div[23] & ~div[22] & ~div[21] & ~div[20] & ~div[19] & ~div[18] & 
        ~div[17] & ~div[16] & ~div[15] & ~div[14] & ~div[13] & ~div[12] & ~div[11] & ~div[10] & 
        ~div[9] & ~div[8] & ~div[7] & ~div[6] & ~div[5] & ~div[4] & ~div[3] & ~div[2] & ~div[1] & ~div[0];

endmodule