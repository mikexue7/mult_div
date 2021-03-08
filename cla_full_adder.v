module cla_full_adder(x, y, c_in, p, g, s);
    input [31:0] x, y, p, g;
    input c_in;
    output [31:0] s;
    
    wire [3:0] P, G;
    wire [4:0] c;
    wire c_out;
    assign c[0] = c_in;
    assign c_out = c[4];

    cla_block b0(x[7:0], y[7:0], c[0], p[7:0], g[7:0], P[0], G[0], s[7:0]);
    cla_block b1(x[15:8], y[15:8], c[1], p[15:8], g[15:8], P[1], G[1], s[15:8]);
    cla_block b2(x[23:16], y[23:16], c[2], p[23:16], g[23:16], P[2], G[2], s[23:16]);
    cla_block b3(x[31:24], y[31:24], c[3], p[31:24], g[31:24], P[3], G[3], s[31:24]);

    // calculate carry in's
    wire w_b0;
    and b0_and1(w_b0, P[0], c[0]);
    or b0_or(c[1], G[0], w_b0);

    wire [1:0] w_b1;
    and b1_and1(w_b1[0], P[1], G[0]);
    and b1_and2(w_b1[1], P[1], P[0], c[0]);
    or b1_or(c[2], G[1], w_b1[0], w_b1[1]);

    wire [2:0] w_b2;
    and b2_and1(w_b2[0], P[2], G[1]);
    and b2_and2(w_b2[1], P[2], P[1], G[0]);
    and b2_and3(w_b2[2], P[2], P[1], P[0], c[0]);
    or b2_or(c[3], G[2], w_b2[0], w_b2[1], w_b2[2]);

    wire [3:0] w_b3;
    and b3_and1(w_b3[0], P[3], G[2]);
    and b3_and2(w_b3[1], P[3], P[2], G[1]);
    and b3_and3(w_b3[2], P[3], P[2], P[1], G[0]);
    and b3_and4(w_b3[3], P[3], P[2], P[1], P[0], c[0]);
    or b3_or(c[4], G[3], w_b3[0], w_b3[1], w_b3[2], w_b3[3]);

endmodule