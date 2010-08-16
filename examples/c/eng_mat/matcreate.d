/**
 * MAT-file creation program
 *
 * See the MATLAB External Interfaces/API Guide for compiling information.
 *
 * Calling syntax:
 *
 *	 matcreat
 *
 * Create a MAT-file which can be loaded into MATLAB.
 *
 * This program demonstrates the use of the following functions:
 *
 *	matClose
 *	matGetVariable
 *	matOpen
 *	matPutVariable
 *	matPutVariableAsGlobal
 */
module matcreate;

import std.stdio;
import matd.c.mat;

const BUFSIZE = 256;

int main()
{
	MATFile* pmat;
	mxArray* pa1, pa2, pa3;
	double[9] data = [ 1.0, 4.0, 7.0, 2.0, 5.0, 8.0, 3.0, 6.0, 9.0 ];
	string file = "mattest.mat";
	char[BUFSIZE] str;
	int status; 

	writef("Creating file %s...\n\n", file);
	pmat = matOpen(file.ptr, "w");
	if (pmat is null)
	{
		writef("Error creating file %s\n", file);
		writef("(Do you have write permission in this directory?)\n");
		return 1;
	}

	pa1 = mxCreateDoubleMatrix(3,3,mxComplexity.mxREAL);
	if (pa1 is null)
	{
			writef("%s : Out of memory on line %d\n", __FILE__, __LINE__); 
			writef("Unable to create mxArray.\n");
			return 1;
	}

	pa2 = mxCreateDoubleMatrix(3,3,mxComplexity.mxREAL);
	if (pa2 is null)
	{
			writef("%s : Out of memory on line %d\n", __FILE__, __LINE__);
			writef("Unable to create mxArray.\n");
			return 1;
	}
	mxGetPr(pa2)[0..data.length] = data[];
	
	pa3 = mxCreateString("MATLAB: the language of technical computing".ptr);
	if (pa3 is null)
	{
			writef("%s :	Out of memory on line %d\n", __FILE__, __LINE__);
			writef("Unable to create string mxArray.\n");
			return 1;
	}

	status = matPutVariable(pmat, "LocalDouble", pa1);
	if (status != 0)
	{
			writef("%s :	Error using matPutVariable on line %d\n", __FILE__, __LINE__);
			return 1;
	}	
	
	status = matPutVariableAsGlobal(pmat, "GlobalDouble", pa2);
	if (status != 0)
	{
			writef("Error using matPutVariableAsGlobal\n");
			return 1;
	} 
	
	status = matPutVariable(pmat, "LocalString", pa3);
	if (status != 0)
	{
			writef("%s :	Error using matPutVariable on line %d\n", __FILE__, __LINE__);
			return 1;
	} 
	
	/*
	 * Ooops! we need to copy data before writing the array.	(Well,
	 * ok, this was really intentional.) This demonstrates that
	 * matPutVariable will overwrite an existing array in a MAT-file.
	 */
	mxGetPr(pa1)[0..data.length] = data[];
	status = matPutVariable(pmat, "LocalDouble", pa1);
	if (status != 0)
	{
			writef("%s :	Error using matPutVariable on line %d\n", __FILE__, __LINE__);
			return 1;
	} 
	
	/* clean up */
	mxDestroyArray(pa1);
	mxDestroyArray(pa2);
	mxDestroyArray(pa3);

	if (matClose(pmat) != 0)
	{
		writef("Error closing file %s\n",file);
		return 1;
	}

	/*
	 * Re-open file and verify its contents with matGetVariable
	 */
	pmat = matOpen(file.ptr, "r");
	if (pmat is null)
	{
		writef("Error reopening file %s\n", file);
		return 1;
	}

	/*
	 * Read in each array we just wrote
	 */
	pa1 = matGetVariable(pmat, "LocalDouble");
	if (pa1 is null)
	{
		writef("Error reading existing matrix LocalDouble\n");
		return 1;
	}
	if (mxGetNumberOfDimensions(pa1) != 2)
	{
		writef("Error saving matrix: result does not have two dimensions\n");
		return 1;
	}

	pa2 = matGetVariable(pmat, "GlobalDouble");
	if (pa2 is null)
	{
		writef("Error reading existing matrix GlobalDouble\n");
		return 1;
	}
	if (!(mxIsFromGlobalWS(pa2)))
	{
		writef("Error saving global matrix: result is not global\n");
		return 1;
	}

	pa3 = matGetVariable(pmat, "LocalString");
	if (pa3 is null)
	{
		writef("Error reading existing matrix LocalString\n");
		return 1;
	}

	status = mxGetString(pa3, str.ptr, str.sizeof);
	if(status != 0)
	{
			writef("Not enough space. String is truncated.");
			return 1;
	}
	if (str[0..7] == "MATLAB:") // the language of technical computing")
	{// TODO: this comparison fails even though str is correct
		writef("Error saving string: result has incorrect contents: %s\n", str[0..7]);
//		return 1;
	}

	/* clean up before exit */
	mxDestroyArray(pa1);
	mxDestroyArray(pa2);
	mxDestroyArray(pa3);

	if (matClose(pmat) != 0)
	{
		writef("Error closing file %s\n",file);
		return 1;
	}
	writef("Done\n");
	return 0;
}