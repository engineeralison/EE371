/* A 1-bit adder with carry-in and carry-out.
 *
 * Inputs:
 *   a    - 1-bit input #1
 *   b    - 1-bit input #2
 *   cin  - 1-bit carry-in (connected to cout of another fullAdder)
 *
 * Outputs:
 *   sum  - LSB of a+b+cin
 *   cout - MSB of a+b+cin (connected to cin of another fullAdder)
 */
module fullAdder (a, b, cin, sum, cout);

	input  logic a, b, cin;
	output logic sum, cout;

	assign  sum = a ^ b ^ cin;
	assign cout = (a & b) | (cin & (a ^ b));

endmodule  // fullAdder