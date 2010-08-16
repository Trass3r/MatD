/**
 *	
 */
module matd.mex;

public import matd.c.mex;

import std.string;

/**
 * mex equivalent to MATLAB's "disp" function
 */
int mexWritef(T...)(string fmt, // printf style format
	T ts)
{
	return mexPrintf(toStringz(fmt), ts);
}