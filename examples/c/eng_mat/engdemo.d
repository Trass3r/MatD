/**
 *	This is a simple program that illustrates how to call the MATLAB
 *	Engine functions from a D program using the C API.
 */
module engdemo;

import matd.c.engine;

import std.stdio;
import std.string;
import std.process;

const BUFSIZE = 256;

int main()
{
	Engine* ep;
	mxArray* result = null;
	double[10]	time	= [ 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 ];

	/*
	 * Start the MATLAB engine locally by executing the string
	 * "matlab"
	 *
	 * To start the session on a remote host, use the name of
	 * the host as the string rather than \0
	 *
	 * For more complicated cases, use any string with whitespace,
	 * and that string will be executed literally to start MATLAB
	 */
	if ((ep = engOpen("\0")) is null)
	{
		stderr.write("\nCan't start MATLAB engine\n");
		return 1;
	}

	/*
	 * PART I
	 *
	 * For the first half of this demonstration, we will send data
	 * to MATLAB, analyze the data, and plot the result.
	 */

	/*
	 * Create a variable for our data
	 */
	mxArray* T = mxCreateDoubleMatrix(1, 10, mxComplexity.mxREAL);
	(cast(void*)mxGetPr(T))[0..time.sizeof] = cast(void[]) time;

	/*
	 * Place the variable T into the MATLAB workspace
	 */
	engPutVariable(ep, "T", T);

	/*
	 * Evaluate a function of time, distance = (1/2)g.*t.^2
	 * (g is the acceleration due to gravity)
	 */
	engEvalString(ep, "D = .5.*(-9.8).*T.^2;");

	/*
	 * Plot the result
	 */
	engEvalString(ep, "plot(T, D);");
	engEvalString(ep, "title('Position vs. Time for a falling object');");
	engEvalString(ep, "xlabel('Time (seconds)');");
	engEvalString(ep, "ylabel('Position (meters)');");

	/*
	 * use fgetc() to make sure that we pause long enough to be
	 * able to see the plot
	 */
	writef("Hit return to continue\n\n");
	system("pause");
	/*
	 * We're done for Part I! Free memory, close MATLAB figure.
	 */
	writef("Done for Part I.\n");
	mxDestroyArray(T);
	engEvalString(ep, "close;");


	/*
	 * PART II
	 *
	 * For the second half of this demonstration, we will request
	 * a MATLAB string, which should define a variable X.  MATLAB
	 * will evaluate the string and create the variable.  We
	 * will then recover the variable, and determine its type.
	 */

	/*
	 * Use engOutputBuffer to capture MATLAB output, so we can
	 * echo it back. Ensure first that the buffer is always null
	 * terminated.
	 */

	char[BUFSIZE+1] buffer;
	buffer[BUFSIZE] = '\0';
	engOutputBuffer(ep, buffer.ptr, BUFSIZE);
	while (result is null)
	{
	    /*
	     * Get a string input from the user
	     */
	    write("Enter a MATLAB command to evaluate. This command should\n");
	    write("create a variable X. This program will then determine\n");
	    write("what kind of variable you created.\n");
	    write("For example: X = 1:5\n");
	    write(">> ");

	    auto str = readln();

	    /*
	     * Evaluate input with engEvalString
	     */
	    engEvalString(ep, toStringz(str));

	    /*
	     * Echo the output from the command.
	     */
	    writef("%s", buffer);

	    /*
	     * Get result of computation
	     */
	    write("\nRetrieving X...\n");
	    if ((result = engGetVariable(ep, "X")) is null)
	      write("Oops! You didn't create a variable X.\n\n");
	    else {
		writef("X is class %s\t\n", mxGetClassName(result));
	    }
	}

	/*
	 * We're done! Free memory, close MATLAB engine and exit.
	 */
	writef("Done!\n");
	mxDestroyArray(result);
	engClose(ep);

	return 0;
}