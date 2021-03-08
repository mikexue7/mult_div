# Design Implementation

For designing the MultDiv, several components were needed. Each is described below.

## Multiplier

The complete design of the multiplier follows the diagram found in lecture. The multiplier uses a 65-bit product register that is initialized with the multiplier and exploits modified Booth's algorithm to process the least significant 3 bits each cycle and perform the appropriate addition/subtraction on the multiplicand. This is done for exactly 17 cycles for 32-bit numbers (first cycle is to initialize the product register) until the data is ready. An exception is thrown if an overflow occurs, which can be detected by checking whether or not the upper 33 bits of the register are the same value, in which case the 32-bit answer is equal to the 64-bit answer and no overflow has occurred.

## Divider

The complete design of the divider follows the diagram found in lecture. The divider uses a 64-bit remainder/quotient (AQ) register that is initialized with the dividend and exploits the non-restoring division algorithm for unsigned integers to determine at each step whether to add/subtract the divisor and adjust the least significant bit based on the sign of the most significant bit in the AQ register. This is done for exactly 33 cycles for 32-bit numbers (first cycle is to initialize the AQ register) until the data is ready. An exception is thrown if the divisor is 0.

## Putting It All Together

In the main MultDiv module, we must take into account ctrl_MULT and ctrl_DIV, which specify which operation is requested at a given clock cycle. The first thing I did was create a counter for each operation, which keeps track of how many clock cycles have elapsed and is reset when ctrl_MULT or ctrl_DIV, respectively, turn on, indicating the counter must start over for a new operation. One challenge is to return the appropriate outputs of data_result, data_exception, and data_resultRDY based on the appropriate operation. To do so, I used an SR latch, which conveniently sets the values of Q_a and Q_b based on whether set or reset is on, and holds those values when both are off (which occurs during the period of computing the result). This ensures knowledge of which operation was requested based on ctrl_MULT and ctrl_DIV. Then, a simple 2-1 mux can be used to assign those outputs appropriately.