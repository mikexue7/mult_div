module ctrl_latch(s, r, out);
    input s, r;
    output out;

    wire q_a, q_b;

    nor nor1(q_a, r, q_b);
    nor nor2(q_b, s, q_a);

    assign out = q_a;

endmodule