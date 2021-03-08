module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // counters for mult/div
    wire [31:0] count, mult_count, div_count;
    counter mult_counter(clock, ctrl_MULT, mult_count);
    counter div_counter(clock, ctrl_DIV, div_count);

    // check if current operation is mult/div
    wire is_mult;
    ctrl_latch latch(ctrl_MULT, ctrl_DIV, is_mult);

    // instantiate mult/div
    wire [31:0] mult_result, div_result, div_remainder;
    wire mult_exception, div_exception;
    mult multiplier(data_operandA, data_operandB, clock, mult_count, mult_result, mult_exception);
    div divider(data_operandA, data_operandB, clock, div_count, div_result, div_remainder, div_exception);

    // assign outputs
    assign data_result = is_mult ? mult_result : div_result;
    assign data_exception = is_mult ? mult_exception : div_exception;
    assign data_resultRDY = is_mult ? (mult_count[4] & ~mult_count[3] & ~mult_count[2] & ~mult_count[1] & mult_count[0]) : 
        (div_count[5] & ~div_count[4] & ~div_count[3] & ~div_count[2] & ~div_count[1] & div_count[0]);

endmodule