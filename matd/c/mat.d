/**
 *	Contains functions to create and edit .mat files created using
 *	'save' in Matlab.
 */
module matd.c.mat;

pragma(lib, "libmat");

extern(C):

import core.stdc.stdio;
public import matd.c.matrix;


alias void MATFile; //! alias struct MatFile_tag MATFile;




/**
 * Open a MAT-file "filename" using mode "mode".  Return
 * a pointer to a MATFile for use with other MAT API functions.
 *
 * Current valid entries for "mode" are
 * "r"    == read only.
 * "w"    == write only (deletes any existing file with name <filename>).
 * "w4"   == as "w", but create a MATLAB 4.0 MAT-file.
 * "w7.3" == as "w", but create a MATLAB 7.3 MAT-file.
 * "u"    == update.  Read and write allowed, existing file is not deleted.
 * 
 * Return NULL if an error occurs.
 */
MATFile* matOpen(const(char)* filename, const(char)* mode);


/**
 * Close a MAT-file opened with matOpen.
 * The pointer-to-MATfile argument is invalid, once matClose returns.
 * Return zero for success, EOF on error.
 */
int  matClose(MATFile* pMF);


/**
 * Return the ANSI C FILE pointer obtained when the MAT-file was opened.
 * Warning: the FILE pointer may be NULL in the case of a MAT file format
 * that does not allow access to the raw file pointer.
 */
FILE* matGetFp(MATFile* pMF);


/**
 * Write array value with the specified name to the MAT-file, deleting any 
 * previously existing variable with that name in the MAT-file.
 *
 * Return zero for success, nonzero for error.
 */
int  matPutVariable(MATFile* pMF, const(char)* name, mxArray* pA);


/**
 * Write array value with the specified name to the MAT-file pMF, deleting any 
 * previously existing variable in the MAT-file with the same name.
 *
 * The variable will be written such that when the MATLAB LOAD command 
 * loads the variable, it will automatically place it in the 
 * global workspace and establish a link to it in the local
 * workspace (as if the command "global <varname>" had been
 * issued after the variable was loaded.)
 *
 * Return zero for success, nonzero for error.
 */
int  matPutVariableAsGlobal(MATFile* pMF, const(char)* name, mxArray* pA);


/**
 * Read the array value for the specified variable name from a MAT-file.
 *
 * Return NULL if an error occurs.
 */
mxArray*  matGetVariable(MATFile* pMF, const(char)* name);


/**
 * Read the next array value from the current file location of the MAT-file
 * pMF.  This function should only be used in conjunction with 
 * matOpen and matClose.  Passing pMF to any other API functions
 * will cause matGetNextVariable() to work incorrectly.
 *
 * Return NULL if an error occurs.
 */
mxArray*  matGetNextVariable(MATFile* pMF, const(char)** nameptr);


/**
 * Read the array header of the next array value in a MAT-file.  
 * This function should only be used in conjunction with 
 * matOpen and matClose.  Passing pMF to any other API functions
 * will cause matGetNextVariableInfo to work incorrectly.
 * 
 * See the description of matGetVariableInfo() for the definition
 * and valid uses of an array header.
 *
 * Return NULL if an error occurs.
 */
 
mxArray*  matGetNextVariableInfo(MATFile* pMF, const(char)** nameptr);


/**
 * Read the array header for the variable with the specified name from 
 * the MAT-file.
 * 
 * An array header contains all the same information as an
 * array, except that the pr, pi, ir, and jc data structures are 
 * not allocated for non-recursive data types.  That is,
 * Cells, structures, and objects contain pointers to other
 * array headers, but numeric, string, and sparse arrays do not 
 * contain valid data in their pr, pi, ir, or jc fields.
 *
 * The purpose of an array header is to gain fast access to 
 * information about an array without reading all the array's
 * actual data.  Thus, functions such as mxGetM, mxGetN, and mxGetClassID
 * can be used with array headers, but mxGetPr, mxGetPi, mxGetIr, mxGetJc,
 * mxSetPr, mxSetPi, mxSetIr, and mxSetJc cannot.
 *
 * An array header should NEVER be returned to MATLAB (for example via the
 * MEX API), or any other non-matrix access API function that expects a
 * full mxArray (examples include engPutVariable(), matPutVariable(), and 
 * mexPutVariable()).
 *
 * Return NULL if an error occurs.
 */
mxArray*  matGetVariableInfo(MATFile* pMF, const(char)* name);


/**
 * Remove a variable with with the specified name from the MAT-file pMF.
 *
 * Return zero on success, non-zero on error.
 */
int  matDeleteVariable(MATFile* pMF, const(char)* name);


/**
 * Get a list of the names of the arrays in a MAT-file.
 * The array of strings returned by this function contains "num"
 * entries.  It is allocated with one call to mxCalloc, and so 
 * can (must) be freed with one call to mxFree.
 *
 * If there are no arrays in the MAT-file, return value 
 * is NULL and num is set to zero.  If an error occurs,
 * return value is NULL and num is set to a negative number.
 */
const(char)** matGetDir(MATFile* pMF, int* num);