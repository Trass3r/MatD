/**
 *	MAT-file diagnose program
 * 
 *	See the MATLAB API Guide for compiling information.
 * 
 *	Calling syntax:
 * 
 *		matdiag <matfile>
 * 
 *	It will diagnose the MAT-file named <matfile>.
 * 
 *	This program demonstrates the use of the following functions:
 * 
 *	 matClose
 *	 matGetDir
 *	 matGetNextVariable
 *	 matGetNextVariableInfo
 *	 matOpen
 */
module matdiag;

import std.stdio;
//import std.stdlib;
import matd.c.mat;
import std.string;

//!
int diagnose(string filename)
{
	MATFile*		pmat;
	const(char)**	dir;
	const(char)*	name;
	int				ndir;
	mxArray*		pa;
	const(char)*	file = filename.ptr;

	writef("Reading file %s...\n\n", file);

	/*
	 *	Open file to get directory
	 */
	pmat = matOpen(file, "r");
	if (pmat is null)
	{
		writef("Error opening file %s\n", file);
		return 1;
	}
	
	/*
	 *	get directory of MAT-file
	 */
	dir = matGetDir(pmat, &ndir);
	if (dir is null)
	{
		writef("Error reading directory of file %s\n", file);
		return 1;
	}
	else
	{
		writef("Directory of %s:\n", file);
		for (int i=0; i < ndir; i++)
			writef("%s\n", dir[i]);
	}
	mxFree(dir);

	// In order to use matGetNextXXX correctly, reopen file to read in headers.
	if (matClose(pmat) != 0)
	{
		writef("Error closing file %s\n", file);
		return 1;
	}
	pmat = matOpen(file, "r");
	if (pmat is null)
	{
		writef("Error reopening file %s\n", file);
		return 1;
	}

	// Get headers of all variables
	write("\nExamining the header for each variable:\n");
	for (int i=0; i < ndir; i++)
	{
		pa = matGetNextVariableInfo(pmat, &name);
		if (pa is null)
		{
			writef("Error reading in file %s\n", file);
			return 1;
		}
		/* Diagnose header pa*/
		writef("According to its header, array %s has %d dimensions\n",
		 name, mxGetNumberOfDimensions(pa));
		if (mxIsFromGlobalWS(pa))
			writef("	and was a global variable when saved\n");
		else
			writef("	and was a local variable when saved\n");
		mxDestroyArray(pa);
	}

	// Reopen file to read in actual arrays.
	if (matClose(pmat) != 0)
	{
		writef("Error closing file %s\n", file);
		return 1;
	}
	pmat = matOpen(file, "r");
	if (pmat is null)
	{
		writef("Error reopening file %s\n", file);
		return 1;
	}

	// Read in each array.
	write("\nReading in the actual array contents:\n");
	for (int i=0; i<ndir; i++)
	{
		pa = matGetNextVariable(pmat, &name);
		if (pa is null)
		{
			writef("Error reading in file %s\n", file);
			return 1;
		} 
		/*
		 *	Diagnose array pa
		 */
		writef("According to its contents, array %s has %d dimensions\n",
				name, mxGetNumberOfDimensions(pa));
		if (mxIsFromGlobalWS(pa))
			write("	and was a global variable when saved\n");
		else
			write("	and was a local variable when saved\n");
		mxDestroyArray(pa);
	}

	if (matClose(pmat) != 0)
	{
			writef("Error closing file %s\n", file);
			return 1;
	}
	write("Done\n");
	return 0;
}

int main(string[] args)
{
	int result;

	if (args.length > 1)
		result = diagnose(args[1]~"\0");
	else
	{
		result = 0;
		write("Usage: matdiag <matfile>");
		write(" where <matfile> is the name of the MAT-file");
		write(" to be diagnosed\n");
	}

	return (result==0) ? 0 : 1;
}