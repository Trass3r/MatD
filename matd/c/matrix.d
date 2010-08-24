/**
 *	This module defines the mxArray struct and functions to
 *	manipulate it.
 *	Furthermore functions for allocating MATLAB memory are provided.
 */
module matd.c.matrix;

pragma(lib, "libmx");

public import matd.c.tmwtypes;

extern(C):


const MX_API_VER = 0x07040000;

version(MX_COMPAT_32)
	const MX_COMPAT_32 = true;
else
	const MX_COMPAT_32 = false;
version(MX_INTERNAL_730)
	const MX_INTERNAL_730 = true;
else
	const MX_INTERNAL_730 = false;

/*
 * PUBLISHED APIs with changes in MATLAB 7.3
 */

static if (!MX_COMPAT_32 || MX_INTERNAL_730)
{
/*
 * Include this uniformly on non-Linux platforms (no .symver)
 * Include it only internal to the matrix library on Linux
 */

version(linux)
	const __tmp1 = true;
else
	const __tmp1 = false;

static if (!__tmp1 || MX_INTERNAL_730)
{
/+ TODO: all that preprocessor shit
alias mxSetProperty_730 mxSetProperty;

alias mxGetProperty_730 mxGetProperty;

alias mxSetField_730 mxSetField;

alias mxSetFieldByNumber_730 mxSetFieldByNumber;

alias mxGetFieldByNumber_730 mxGetFieldByNumber;

alias mxGetField_730 mxGetField;

alias mxCreateStructMatrix_730 mxCreateStructMatrix;

alias mxCreateCellMatrix_730 mxCreateCellMatrix;

alias mxCreateCharMatrixFromStrings_730 mxCreateCharMatrixFromStrings;

alias mxGetString_730 mxGetString;

alias mxGetNumberOfDimensions_730 mxGetNumberOfDimensions;

alias mxGetDimensions_730 mxGetDimensions;

alias mxSetDimensions_730 mxSetDimensions;

alias mxSetIr_730 mxSetIr;

alias mxGetIr_730 mxGetIr;

alias mxSetJc_730 mxSetJc;

alias mxGetJc_730 mxGetJc;

alias mxCreateStructArray_730 mxCreateStructArray;

alias mxCreateCharArray_730 mxCreateCharArray;

alias mxCreateNumericArray_730 mxCreateNumericArray;

alias mxCreateCellArray_730 mxCreateCellArray;

alias mxCreateLogicalArray_730 mxCreateLogicalArray;

alias mxGetCell_730 mxGetCell;

alias mxSetCell_730 mxSetCell;

alias mxSetNzmax_730 mxSetNzmax;

alias mxSetN_730 mxSetN;

alias mxSetM_730 mxSetM;

alias mxGetNzmax_730 mxGetNzmax;

alias mxCreateDoubleMatrix_730 mxCreateDoubleMatrix;

alias mxCreateNumericMatrix_730 mxCreateNumericMatrix;

alias mxCreateLogicalMatrix_730 mxCreateLogicalMatrix;

alias mxCreateSparse_730 mxCreateSparse;

alias mxCreateSparseLogicalMatrix_730 mxCreateSparseLogicalMatrix;

alias mxGetNChars_730 mxGetNChars;

alias mxCreateStringFromNChars_730 mxCreateStringFromNChars;

alias mxCalcSingleSubscript_730 mxCalcSingleSubscript;

alias mxGetDimensions_730 mxGetDimensions_fcn;
+/
}
else
	alias mxGetDimensions mxGetDimensions_fcn;

} // of static if (!MX_COMPAT_32 || MX_INTERNAL_730)
else
	alias mxGetDimensions_700 mxGetDimensions_fcn;

/**
 * Type representing the signature for MEX functions.
 */
alias void function(int nlhs, mxArray** plhs, int nrhs, mxArray** prhs) mxFunctionPtr;

/**
 * Maximum mxArray name length
 */
alias TMW_NAME_LENGTH_MAX mxMAXNAM;

/**
 * Logical type
 */
typedef bool mxLogical;

/**
 * UTF-16 character type
 */
alias ushort CHAR16_T;
alias ushort char16_t;

/**
 * Typedef required for Unicode support in MATLAB
 */
alias char16_t mxChar;

/**
 * Enumeration corresponding to all the valid mxArray types.
 */
version(D_LP64) // #if defined(_LP64) || defined(_WIN64)
{
//static assert(0, "need to fix mxClassID for 64Bit usage!");
const __tmpe = 15;
}
else
const __tmpe = 13;

enum mxClassID
{
	mxUNKNOWN_CLASS = 0,
	mxCELL_CLASS,
	mxSTRUCT_CLASS,
	mxLOGICAL_CLASS,
	mxCHAR_CLASS,
	mxVOID_CLASS,
	mxDOUBLE_CLASS,
	mxSINGLE_CLASS,
	mxINT8_CLASS,
	mxUINT8_CLASS,
	mxINT16_CLASS,
	mxUINT16_CLASS,
	mxINT32_CLASS,
	mxUINT32_CLASS, // 13
	mxINT64_CLASS,
	mxUINT64_CLASS, // 15
	mxFUNCTION_CLASS,
	mxOPAQUE_CLASS,
	mxOBJECT_CLASS, // keep the last real item in the list
	mxINDEX_CLASS = __tmpe, //mxUINT32_CLASS, // TODO: fix this!! see above
	// TEMPORARY AND NASTY HACK UNTIL mxSPARSE_CLASS IS COMPLETELY ELIMINATED
	mxSPARSE_CLASS = mxVOID_CLASS /* OBSOLETE! DO NOT USE */
}

/**
 * Indicates whether floating-point mxArrays are real or complex.
 */
enum mxComplexity : int
{
	mxREAL,
	mxCOMPLEX,
}

version(ARRAY_ACCESS_INLINING)
{
import std.bitmanip;

/**
 * This modified version of the mxArray structure is needed to support
 * the ARRAY_ACCESS_INLINING macros.  NOTE: The elements in this structure
 * should not be accessed directly.  Inlined MEX-files are NOT guaranteed
 * to be portable from one release of MATLAB to another.
 */
struct mxArray
{
	void*	reserved;
	int[2]	reserved1;
	void*	reserved2;
	size_t	number_of_dims;
	uint	reserved3;
	struct A
	{
		mixin(bitfields!(
			
	 		bool,	"flag0",	1,
	 		bool,	"flag1",	1, 
	 		bool,	"flag2",	1,
	 		bool,	"flag3",	1,
	 		bool,	"flag4",	1,
	 		bool,	"flag5",	1,
	 		bool,	"flag6",	1,
	 		bool,	"flag7",	1,
	 		bool,	"flag7a",	1,
	 		bool,	"flag8",	1,
	 		bool,	"flag9",	1,
	 		bool,	"flag10",	1,
	 		ubyte,	"flag11",	4,
	 		ubyte,	"flag12",	8,
	 		ubyte,	"flag13",	8));
	}
	A	flags;
	size_t[2]	reserved4;
	union data
	{
		struct B
		{
			void*		pdata;
			void*		pimag_data;
			void*		reserved5;
			size_t[3]	reserved6;
		}
		B number_array;
	}
}

} // of version(ARRAY_ACCESS_INLINING)
else
{
	/**
	 * Published incomplete definition of mxArray
	 */
	typedef void mxArray; // alias struct mxArray_tag mxArray;
}

/**
 * allocate memory, notifying registered listener
 */
void *mxMalloc(
	size_t	n		// number of bytes
	);


/**
 * allocate cleared memory, notifying registered listener.
 */
void *mxCalloc(
	size_t	n,		// number of objects
	size_t	size	// size of objects
	);


/**
 * free memory, notifying registered listener.
 */
void mxFree(void *ptr);	// pointer to memory to be freed


/**
 * reallocate memory, notifying registered listener.
 */
void* mxRealloc(void *ptr, size_t size);

 
/**
 * Return the class (catergory) of data that the array holds.
 */
mxClassID mxGetClassID(const(mxArray)* pa);


version(ARRAY_ACCESS_INLINING)
{
	/**
	 * Get pointer to data
	 */
	void* mxGetData(const(mxArray)* pa)
	{
		return pa.data.number_array.pdata;
	}
}
else
{
	/**
	 * Get pointer to data
	 */
	void* mxGetData(
			const(mxArray)* pa		// pointer to array
	);
}

/**
 * Set pointer to data
 */
void mxSetData(
	mxArray*	pa,		// pointer to array
	void*		newdata	// pointer to data
);


/** 
 * Determine whether the specified array contains numeric (as opposed 
 * to cell or struct) data.
 */
bool mxIsNumeric(const(mxArray)* pa);


/** 
 * Determine whether the given array is a cell array.
 */
bool mxIsCell(const(mxArray)* pa);


/**
 * Determine whether the given array's logical flag is on.
 */ 
bool mxIsLogical(const(mxArray)* pa);


/**  
 * Determine whether the given array contains character data. 
 */
bool mxIsChar(const(mxArray)* pa);


/**
 * Determine whether the given array is a structure array.
 */
bool mxIsStruct(const(mxArray)* pa);


/**
 * Determine whether the given array is an opaque array.
 */
bool mxIsOpaque(const(mxArray)* pa);


/**
 * Returns true if specified array is a function object.
 */
bool mxIsFunctionHandle(const(mxArray)* pa);


/**
 * This function is deprecated and is preserved only for backward compatibility.
 * DO NOT USE if possible.
 * Is array user defined MATLAB v5 object
 */
bool mxIsObject(
	const(mxArray)* pa		// pointer to array
);


version(ARRAY_ACCESS_INLINING)
{
	/***
	 * Get imaginary data pointer for numeric array
	 */
	void* mxGetImagData(const(mxArray)* pa)
	{
		return pa.data.number_array.pimag_data;
	}
}
else
{
	/**
	 * Get imaginary data pointer for numeric array
	 */
	void* mxGetImagData
	(
		const(mxArray)* pa		// pointer to array
	);
}


/**
 * Set imaginary data pointer for numeric array
 */
void mxSetImagData(
	mxArray*	pa,		// pointer to array
	void*		newdata	// imaginary data array pointer
);


/**
 * Determine whether the given array contains complex data.
 */
bool mxIsComplex(const(mxArray)* pa);


/**
 * Determine whether the given array is a sparse (as opposed to full). 
 */
bool mxIsSparse(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * double-precision floating-point numbers.
 */
bool mxIsDouble(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * single-precision floating-point numbers.
 */
bool mxIsSingle(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * signed 8-bit integers.
 */
bool mxIsInt8(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * unsigned 8-bit integers.
 */
bool mxIsUint8(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * signed 16-bit integers.
 */
bool mxIsInt16(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * unsigned 16-bit integers.
 */
bool mxIsUint16(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * signed 32-bit integers.
 */
bool mxIsInt32(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * unsigned 32-bit integers.
 */
bool mxIsUint32(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * signed 64-bit integers.
 */
bool mxIsInt64(const(mxArray)* pa);


/**
 * Determine whether the specified array represents its data as 
 * unsigned 64-bit integers.
 */
bool mxIsUint64(const(mxArray)* pa);


version(ARRAY_ACCESS_INLINING)
{
	/**
	 * Get number of dimensions in array
	 */
	mwSize mxGetNumberOfDimensions(const(mxArray)* pa)
	{
		return cast(mwSize)(pa.number_of_dims);
	}
}
else
{
	/**
	 * Get number of dimensions in array
	 */
	mwSize mxGetNumberOfDimensions(const(mxArray)* pa);
}


/**
 * Get pointer to dimension array
 */
const(mwSize)* mxGetDimensions(const(mxArray)* pa);


/** 
 * Get number of elements in array
 */
size_t mxGetNumberOfElements(	
	const(mxArray)* pa		// pointer to array
	);

version(ARRAY_ACCESS_INLINING)
{
	/**
	 * Get real data pointer for numeric array
	 */
	double* mxGetPr(const(mxArray)* pa)
	{
		return cast(double*) mxGetData(pa);
	}
}
else
{
	/**
	 * Get real data pointer for numeric array
	 */
	double* mxGetPr(
		const(mxArray)* pa		// pointer to array
	);
}

/**
 * Set real data pointer for numeric array
 */
void mxSetPr(
	mxArray*	pa,	// pointer to array
	double*		pr	// real data array pointer
	);


version(ARRAY_ACCESS_INLINING)
{
	/**
	 * Get imaginary data pointer for numeric array
	 */
	double* mxGetPi(const(mxArray)* pa)
	{
		return cast(double *)mxGetImagData(pa);
	}
}
else
{
	/**
	 * Get imaginary data pointer for numeric array
	 */
	double* mxGetPi(
		const(mxArray)* pa		// pointer to array
	);
}


/**
 * Set imaginary data pointer for numeric array
 */
void mxSetPi(
	mxArray*	pa,	// pointer to array
	double*		pi	// imaginary data array pointer
);

/+ TODO: mxArray doesn't have a member get_chars()!
version(ARRAY_ACCESS_INLINING)
{
	/**
	 * Get string array data
	 */
	mxChar* mxGetChars(const(mxArray)* pa)
	{
		return pa.get_chars();
	}
}
else
+/
	/**
	 * Get string array data
	 */
	mxChar* mxGetChars(
		const(mxArray)* pa		// pointer to array
		);


/**
 * Get 8 bits of user data stored in the mxArray header.  NOTE: This state
 * of these bits are not guaranteed to be preserved after API function
 * calls.
 */
int mxGetUserBits(
	const(mxArray)* pa		// pointer to array
	);


/**
 * Set 8 bits of user data stored in the mxArray header. NOTE: This state
 * of these bits are not guaranteed to be preserved after API function
 * calls.
 */ 
void mxSetUserBits(
	mxArray*	pa,		// pointer to array
	int			value
);

/* TODO:
#ifdef __WATCOMC__
#ifndef __cplusplus
#pragma aux mxGetScalar value [8087];
#endif
#endif
*/

/**
 * Get the real component of the specified array's first data element.
 */
double mxGetScalar(const(mxArray)* pa);


/**
 * Is the isFromGlobalWorkspace bit set?
 */
bool mxIsFromGlobalWS(const(mxArray)* pa);


/**
 * Set the isFromGlobalWorkspace bit.
 */
void mxSetFromGlobalWS(mxArray* pa, bool global);


/** 
 * Get row dimension
 */
size_t mxGetM(const(mxArray)* pa);


/** 
 * Set row dimension
 */
void mxSetM(mxArray* pa, mwSize m);


/** 
 * Get column dimension
 */
size_t mxGetN(const(mxArray)* pa);


/**
 * Is array empty
 */
bool mxIsEmpty(
	const(mxArray)* pa		// pointer to array
);


/**
 * Get row data pointer for sparse numeric array
 */
mwIndex* mxGetIr(const(mxArray)* pa);


/**
 * Set row data pointer for numeric array
 */
void mxSetIr(mxArray* pa, mwIndex* newir);


/**
 * Get column data pointer for sparse numeric array
 */
mwIndex* mxGetJc(const(mxArray)* pa);


/**
 * Set column data pointer for numeric array
 */
void mxSetJc(mxArray* pa, mwIndex* newjc);


/**
 * Get maximum nonzero elements for sparse numeric array
 */
mwSize mxGetNzmax(const(mxArray)* pa);


/**
 * Set maximum nonzero elements for numeric array
 */
void mxSetNzmax(mxArray* pa, mwSize nzmax);


/**
 * Get array data element size
 */
size_t mxGetElementSize(const(mxArray)* pa);


/** 
 * Return the offset (in number of elements) from the beginning of 
 * the array to a given subscript.  
 */
mwIndex mxCalcSingleSubscript(const(mxArray)* pa, mwSize nsubs, const(mwIndex)* subs);


/**
 * Get number of structure fields in array
 */
int mxGetNumberOfFields(
	const(mxArray)* pa		// pointer to array
	);


/**
 * Get a pointer to the specified cell element. 
 */ 
mxArray* mxGetCell(const(mxArray)* pa, mwIndex i);


/**
 * Set an element in a cell array to the specified value.
 */
void mxSetCell(mxArray* pa, mwIndex i, mxArray* value);


/**
 * Return pointer to the nth field name
 */
const(char)* mxGetFieldNameByNumber(const(mxArray)* pa, int n);


/**
 * Get the index to the named field.
 */ 
int mxGetFieldNumber(const(mxArray)* pa, const(char)* name);


/**
 * Return a pointer to the contents of the named field for 
 * the ith element (zero based).
 */ 
mxArray* mxGetFieldByNumber(const(mxArray)* pa, mwIndex i, int fieldnum);


/**
 * Set pa[i][fieldnum] = value 
 */
void mxSetFieldByNumber(mxArray* pa, mwIndex i, int fieldnum, mxArray* value);


/**
 * Return a pointer to the contents of the named field for the ith 
 * element (zero based).  Returns NULL on no such field or if the
 * field itself is NULL
 */
mxArray* mxGetField(const(mxArray)* pa, mwIndex i, const(char)* fieldname);


/**
 * Sets the contents of the named field for the ith element (zero based).  
 * The input 'value' is stored in the input array 'pa' - no copy is made.
 */
void mxSetField(mxArray* pa, mwIndex i, const(char)* fieldname, mxArray* value);

 
/**
 * mxGetProperty returns the value of a property for a given object and index.
 * The property must be public.
 *
 * If the given property name doesn't exist, isn't public, or the object isn't
 * the right type, then mxGetProperty returns NULL.
 */
mxArray* mxGetProperty(const(mxArray)* pa, mwIndex i, const(char)* propname);

 
/**
 * mxSetProperty sets the value of a property for a given object and index.
 * The property must be public.
 *
 */
void mxSetProperty(mxArray* pa, mwIndex i, const(char)* propname, const(mxArray)* value);

 
/** 
 * Return the name of an array's class.  
 */
const(char)* mxGetClassName(const(mxArray)* pa);


/**
 * Determine whether an array is a member of the specified class. 
 */
bool mxIsClass(const(mxArray)* pa, const(char)* name);


static if (!MX_COMPAT_32 || MX_INTERNAL_730)
{
/**
 * Create a numeric matrix and initialize all its data elements to 0.
 */
mxArray* mxCreateNumericMatrix(mwSize m, mwSize n, mxClassID classid, mxComplexity flag);
}



/**
 * Set column dimension
 */
void  mxSetN(mxArray* pa, mwSize n);


/**
 * Set dimension array and number of dimensions.  Returns 0 on success and 1
 * if there was not enough memory available to reallocate the dimensions array.
 */
int  mxSetDimensions(mxArray* pa, const(mwSize)* size, mwSize ndims);


/**
 * mxArray destructor
 */
void  mxDestroyArray(mxArray* pa);


/**
 * Create a numeric array and initialize all its data elements to 0.
 *
 * Similar to mxCreateNumericMatrix, in a standalone application, 
 * out-of-memory will mean a NULL pointer is returned.
 */
mxArray* mxCreateNumericArray(mwSize ndim, const(mwSize)* dims, mxClassID classid, mxComplexity flag);


/**
 * Create an N-Dimensional array to hold string data;
 * initialize all elements to 0.
 */
mxArray* mxCreateCharArray(mwSize ndim, const(mwSize)* dims);


/**
 * Create a two-dimensional array to hold double-precision
 * floating-point data; initialize each data element to 0.
 */
mxArray*  mxCreateDoubleMatrix(mwSize m, mwSize n, mxComplexity flag);


/**
 * Get a properly typed pointer to the elements of a logical array.
 */
mxLogical * mxGetLogicals(const(mxArray)* pa);


/**
 * Create a logical array and initialize its data elements to false.
 */
mxArray*  mxCreateLogicalArray(mwSize ndim, const(mwSize)*dims);



static if (!MX_COMPAT_32 || MX_INTERNAL_730)
{
/**
 * Create a two-dimensional array to hold logical data and
 * initializes each data element to false.
 */
mxArray*  mxCreateLogicalMatrix(mwSize m, mwSize n);
}



/**
 * Create a logical scalar mxArray having the specified value.
 */
mxArray*  mxCreateLogicalScalar(bool value);


/**
 * Returns true if we have a valid logical scalar mxArray.
 */
bool  mxIsLogicalScalar(const(mxArray)* pa);


/**
 * Returns true if the logical scalar value is true.
 */
bool  mxIsLogicalScalarTrue(const(mxArray)* pa);


/**
 * Create a double-precision scalar mxArray initialized to the
 * value specified
 */
mxArray*  mxCreateDoubleScalar(double value);
alias mxCreateDoubleScalar mxCreateScalarDouble; //! ditto


/**
 * Create a 2-Dimensional sparse array.
 */
mxArray*  mxCreateSparse(mwSize m, mwSize n, mwSize nzmax, mxComplexity flag);


/**
 * Create a 2-D sparse logical array
 */
mxArray*  mxCreateSparseLogicalMatrix(mwSize m, mwSize n, mwSize nzmax);


/**
 * Copies characters from a MATLAB array to a char array
 * This function will attempt to perform null termination if it is possible.
 * nChars is the number of bytes in the output buffer
 */
void  mxGetNChars(const(mxArray)* pa, char* buf, mwSize nChars);


/**
 * Converts a string array to a C-style string. The C-style string is in the
 * local codepage encoding. If the conversion for the entire Unicode string
 * cannot fit into the supplied character buffer, then the conversion includes
 * the last whole codepoint that will fit into the buffer. The string is thus
 * truncated at the greatest possible whole codepoint and does not split code-
 * points.
 */
int  mxGetString(const(mxArray)* pa, char* buf, mwSize buflen);


/**
 * Create a NULL terminated C string from an mxArray of type mxCHAR_CLASS
 * Supports multibyte character sets.  The resulting string must be freed
 * with mxFree.  Returns NULL on out of memory or non-character arrays.
 */
char * mxArrayToString(const(mxArray)* pa);


/**
 * Create a 1-by-n string array initialized to str. The supplied string is
 * presumed to be in the local codepage encoding. The character data format
 * in the mxArray will be UTF-16.
 */
mxArray*  mxCreateStringFromNChars(const(char)* str, mwSize n);


/**
 * Create a 1-by-n string array initialized to null terminated string
 * where n is the length of the string.
 */
mxArray*  mxCreateString(const(char)* str);


/**
 * Create a string array initialized to the strings in str.
 */
mxArray*  mxCreateCharMatrixFromStrings(mwSize m, const(char)** str);


/**
 * Create a 2-Dimensional cell array, with each cell initialized
 * to NULL.
 */
mxArray*  mxCreateCellMatrix(mwSize m, mwSize n);


/**
 * Create an N-Dimensional cell array, with each cell initialized
 * to NULL.
 */
mxArray*  mxCreateCellArray(mwSize ndim, const(mwSize)* dims);


/**
 * Create a 2-Dimensional structure array having the specified fields;
 * initialize all values to NULL.
 */
mxArray*  mxCreateStructMatrix(size_t m, size_t n, int nfields, const(char)** fieldnames);


/**
 * Create an N-Dimensional structure array having the specified fields;
 * initialize all values to NULL.
 */
mxArray*  mxCreateStructArray(mwSize ndim, const(mwSize)* dims, int nfields, const(char)** fieldnames);


/**
 * Make a deep copy of an array, return a pointer to the copy.
 */
mxArray*  mxDuplicateArray(const(mxArray)* inArray);


/**
 * Set classname of an unvalidated object array.  It is illegal to
 * call this function on a previously validated object array.
 * Return 0 for success, 1 for failure.
 */
int  mxSetClassName(mxArray* pa, const(char)* classname);


/** 
 * Add a field to a structure array. Returns field number on success or -1
 * if inputs are invalid or an out of memory condition occurs.
 */
int  mxAddField(mxArray* pa, const(char)* fieldname);


/**
 * Remove a field from a structure array.  Does nothing if no such field exists.
 * Does not destroy the field itself.
*/
void  mxRemoveField(mxArray* pa, int field);

/*
#ifdef __WATCOMC__
#ifndef __cplusplus
#pragma aux mxGetEps value [8087];
#pragma aux mxGetInf value [8087];
#pragma aux mxGetNaN value [8087];
#endif
#endif
*/

/**
 * Function for obtaining MATLAB's concept of EPS
 */
double  mxGetEps();


/**
 * Function for obtaining MATLAB's concept of INF (Used in MEX-File callback).
 */
double  mxGetInf();


/**
 * Function for obtaining MATLAB's concept of NaN (Used in MEX-File callback).
 */
double  mxGetNaN();


/**
 * test for finiteness in a machine-independent manner
 */
bool  mxIsFinite(double x);


/**
 * test for infinity in a machine-independent manner
 */
bool  mxIsInf(double x);


/**
 * test for NaN in a machine-independent manner
 */
bool  mxIsNaN(double x);



/*
mxAssert(int expression, char *error_message)
---------------------------------------------

  Similar to ANSI C's assert() macro, the mxAssert macro checks the
  value of an assertion, continuing execution only if the assertion
  holds.  If 'expression' evaluates to be true, then the mxAssert does
  nothing.  If, however, 'expression' is false, then mxAssert prints an
  error message to the MATLAB Command Window, consisting of the failed
  assertion's expression, the file name and line number where the failed
  assertion occurred, and the string 'error_message'.  'error_message'
  allows the user to specify a more understandable description of why
  the assertion failed.  (Use an empty string if no extra description
  should follow the failed assertion message.)  After a failed
  assertion, control returns to the MATLAB command line. 

  mxAssertS, (the S for Simple), takes the same inputs as mxAssert.  It 
  does not print the text of the failed assertion, only the file and 
  line where the assertion failed, and the explanatory error_message.

  Note that script MEX will turn off these assertions when building
  optimized MEX-functions, so they should be used for debugging 
  purposes only.
*/

/* TODO:
#ifdef MATLAB_MEX_FILE
#  ifndef NDEBUG

EXTERN_C void mexPrintAssertion(const(char)* test, 
			   const(char)* fname, 
			   int linenum, 
			   const(char)* message);


#	define mxAssert(test, message) ( (test) ? (void) 0 : mexPrintAssertion(": " #test ",", __FILE__, __LINE__, message))
#	define mxAssertS(test, message) ( (test) ? (void) 0 : mexPrintAssertion("", __FILE__, __LINE__, message))
#  else
#	define mxAssert(test, message) ((void) 0)
#	define mxAssertS(test, message) ((void) 0)
#  endif
#else
#  include <assert.h>
#  define mxAssert(test, message) assert(test)
#  define mxAssertS(test, message) assert(test)
#endif
*/

/* $Revision: 1.14.4.3 $ */

/*
 * Conflicts with 32-bit compatibility
 * Needs revisiting.  Is this layer still worthwhile?
 * XXX
 */

/+
#if 0

/*
 * Conflicts with 32-bit compatibility
 * Needs revisiting.  Is this layer still worthwhile?
 * XXX
 */

#ifdef ARGCHECK

#include "mwdebug.h" // Prototype _d versions of API functions

#define mxAddField(pa, fieldname)					   mxAddField_d(pa, fieldname, __FILE__, __LINE__)
#define mxArrayToString(pa)				mxArrayToString_d(pa, __FILE__, __LINE__)
#define mxCalcSingleSubscript(pa, nsubs, subs)		  mxCalcSingleSubscript_d(pa, nsubs, subs, __FILE__, __LINE__) 
#define mxCalloc(nelems, size)						  mxCalloc_d(nelems, size, __FILE__, __LINE__)
#define mxCreateCellArray(ndim, dims)					mxCreateCellArray_d(ndim, dims, __FILE__, __LINE__)
#define mxCreateCellMatrix(m, n)						mxCreateCellMatrix_d(m, n, __FILE__, __LINE__)
#define mxCreateCharArray(ndim, dims)				   mxCreateCharArray_d(ndim, dims, __FILE__, __LINE__)
#define mxCreateCharMatrixFromStrings(m, strings)	   mxCreateCharMatrixFromStrings_d(m, strings, __FILE__, __LINE__)
#define mxCreateDoubleMatrix(m, n, cplxflag)		mxCreateDoubleMatrix_d(m, n, cplxflag, __FILE__, __LINE__)
#define mxCreateDoubleScalar(value)				mxCreateDoubleScalar_d(value, __FILE__, __LINE__)
#define mxCreateLogicalArray(ndim, dims)		mxCreateLogicalArray_d(ndim, dims, __FILE__, __LINE__)
#define mxCreateLogicalMatrix(m, n)				mxCreateLogicalMatrix_d(m, n, __FILE__, __LINE__)
#define mxCreateLogicalScalar(value)					mxCreateLogicalScalar_d(value, __FILE__, __LINE__)
#define mxCreateNumericArray(ndim, dims, classname, cplxflag) mxCreateNumericArray_d(ndim, dims, classname, cplxflag, __FILE__, __LINE__) 
#define mxCreateNumericMatrix(m, n, classid, cmplx_flag)	  mxCreateNumericMatrix_d(m, n, classid, cmplx_flag, __FILE__, __LINE__)
#define mxCreateSparse(m, n, nzmax, cplxflag)		   mxCreateSparse_d(m, n, nzmax, cplxflag, __FILE__, __LINE__) 
#define mxCreateSparseLogicalMatrix(m, n, nzmax)	mxCreateSparseLogicalMatrix_d(m, n, nzmax, __FILE__, __LINE__)
#define mxCreateString(string) mxCreateString_d(string, __FILE__, __LINE__)
#define mxCreateStructArray(ndim, dims, nfields, fieldnames)  mxCreateStructArray_d(ndim, dims, nfields, fieldnames, __FILE__, __LINE__)
#define mxCreateStructMatrix(m, n, nfields, fieldnames) mxCreateStructMatrix_d(m, n, nfields, fieldnames, __FILE__, __LINE__)
#define mxDestroyArray(pa)				mxDestroyArray_d(pa, __FILE__, __LINE__)
#define mxDuplicateArray(pa)					mxDuplicateArray_d(pa, __FILE__, __LINE__)
#define mxFree(pm)					mxFree_d(pm, __FILE__, __LINE__)
#define mxGetChars(pa)					mxGetChars_d(pa, __FILE__, __LINE__)
#define mxGetCell(pa, index)					mxGetCell_d(pa, index, __FILE__, __LINE__)
#define mxGetClassID(pa)				mxGetClassID_d(pa, __FILE__, __LINE__)
#define mxGetClassName(pa)				mxGetClassName_d(pa, __FILE__, __LINE__)
#define mxGetData(pa)								   mxGetData_d(pa, __FILE__, __LINE__)
#define mxGetDimensions(pa)  					mxGetDimensions_d(pa, __FILE__, __LINE__)
#define mxGetElementSize(pa)					mxGetElementSize_d(pa, __FILE__, __LINE__)
#define mxGetProperty(pa, index, propname)			  mxGetProperty_d(pa, index, propname, __FILE__, __LINE__)
#define mxGetField(pa, index, fieldname)				mxGetField_d(pa, index, fieldname, __FILE__, __LINE__)
#define mxGetFieldByNumber(pa, index, fieldnum)		 mxGetFieldByNumber_d(pa, index, fieldnum, __FILE__, __LINE__)
#define mxGetFieldNameByNumber(pa, fieldnum)			mxGetFieldNameByNumber_d(pa, fieldnum, __FILE__, __LINE__)
#define mxGetFieldNumber(pa, fieldname)				 mxGetFieldNumber_d(pa, fieldname, __FILE__, __LINE__)
#define mxGetImagData(pa)							   mxGetImagData_d(pa, __FILE__, __LINE__)
#define mxGetIr(pa)									 mxGetIr_d(pa, __FILE__, __LINE__)
#define mxGetJc(pa)									 mxGetJc_d(pa, __FILE__, __LINE__)
#define mxGetLogicals(pa)				mxGetLogicals_d(pa, __FILE__, __LINE__)
#define mxGetNumberOfDimensions(pa)				mxGetNumberOfDimensions_d(pa, __FILE__, __LINE__)
#define mxGetNumberOfElements(pa)				mxGetNumberOfElements_d(pa, __FILE__, __LINE__)
#define mxGetNumberOfFields(pa)					mxGetNumberOfFields_d(pa, __FILE__, __LINE__)
#define mxGetNzmax(pa)					mxGetNzmax_d(pa, __FILE__, __LINE__)
#define mxGetM(pa)					mxGetM_d(pa, __FILE__, __LINE__)
#define mxGetN(pa)					mxGetN_d(pa, __FILE__, __LINE__)
#define mxGetPi(pa)									 mxGetPi_d(pa, __FILE__, __LINE__)
#define mxGetPr(pa)									 mxGetPr_d(pa, __FILE__, __LINE__)
#define mxGetScalar(pa)					mxGetScalar_d(pa, __FILE__, __LINE__)
#define mxGetString(pa, buffer, buflen)				 mxGetString_d(pa, buffer, buflen, __FILE__, __LINE__)
#define mxIsCell(pa)					mxIsCell_d(pa, __FILE__, __LINE__)
#define mxIsChar(pa)					mxIsChar_d(pa, __FILE__, __LINE__)
#define mxIsClass(pa, classname)						mxIsClass_d(pa, classname, __FILE__, __LINE__)
#define mxIsComplex(pa)					mxIsComplex_d(pa, __FILE__, __LINE__)
#define mxIsDouble(pa)					mxIsDouble_d(pa, __FILE__, __LINE__)
#define mxIsEmpty(pa)					mxIsEmpty_d(pa, __FILE__, __LINE__)
#define mxIsFromGlobalWS(pa)							mxIsFromGlobalWS_d(pa, __FILE__, __LINE__)
#define mxIsInt8(pa)					mxIsInt8_d(pa, __FILE__, __LINE__)
#define mxIsInt16(pa)					mxIsInt16_d(pa, __FILE__, __LINE__)
#define mxIsInt32(pa)					mxIsInt32_d(pa, __FILE__, __LINE__)
#define mxIsLogical(pa)					mxIsLogical_d(pa, __FILE__, __LINE__)
#define mxIsNumeric(pa)					mxIsNumeric_d(pa, __FILE__, __LINE__)
#define mxIsOpaque(pa)					mxIsOpaque_d(pa, __FILE__, __LINE__)
#define mxIsObject(pa)					mxIsObject_d(pa, __FILE__, __LINE__)
#define mxIsSingle(pa)					mxIsSingle_d(pa, __FILE__, __LINE__)
#define mxIsSparse(pa)					mxIsSparse_d(pa, __FILE__, __LINE__)
#define mxIsStruct(pa)					mxIsStruct_d(pa, __FILE__, __LINE__)
#define mxIsUint8(pa)					mxIsUint8_d(pa, __FILE__, __LINE__)
#define mxIsUint16(pa)					mxIsUint16_d(pa, __FILE__, __LINE__)
#define mxIsUint32(pa)					mxIsUint32_d(pa, __FILE__, __LINE__)
#define mxIsUint64(pa)						mxIsUint64_d(pa, __FILE__, __LINE__)
#define mxMalloc(n)							mxMalloc_d(n, __FILE__, __LINE__)
#define mxRealloc(pm, nelems)					mxRealloc_d(pm, nelems, __FILE__, __LINE__)
#define mxRemoveField(pa, field)				mxRemoveField_d(pa, field, __FILE__, __LINE__)
#if !defined(MATLAB_MEX_FILE)
#define mxSetAllocFcns(callocptr, freeptr, reallocptr, mallocptr) mxSetAllocFcns_d(callocptr, freeptr, reallocptr, freeptr, __FILE__, __LINE__)
#endif // MATLAB_MEX_FILE
#define mxSetCell(pa, index, value)				mxSetCell_d(pa, index, value, __FILE__, __LINE__)
#define mxSetClassName(pa, name)				mxSetClassName_d(pa, name, __FILE__, __LINE__)
#define mxSetData(pa, pd)				mxSetData_d(pa, pd, __FILE__, __LINE__)
#define mxSetDimensions(pa, size, ndims)				mxSetDimensions_d(pa, size, ndims, __FILE__, __LINE__)
#define mxSetProperty(pa, index, propname, value)	   mxSetProperty_d(pa, index, propname, value, __FILE__, __LINE__)
#define mxSetField(pa, index, fieldname, value)		 mxSetField_d(pa, index, fieldname, value, __FILE__, __LINE__)
#define mxSetFieldByNumber(pa, index, fieldnum, value)  mxSetFieldByNumber_d(pa, index, fieldnum, value, __FILE__, __LINE__)
#define mxSetImagData(pa, pid)					mxSetImagData_d(pa, pid, __FILE__, __LINE__)
#define mxSetIr(pa, ir)					mxSetIr_d(pa, ir, __FILE__, __LINE__)
#define mxSetJc(pa, jc)					mxSetJc_d(pa, jc, __FILE__, __LINE__)
#define mxSetM(pa, m)						mxSetM_d(pa, m, __FILE__, __LINE__)
#define mxSetN(pa, n)						mxSetN_d(pa, n, __FILE__, __LINE__)
#define mxSetNzmax(pa, nzmax)					mxSetNzmax_d(pa, nzmax, __FILE__, __LINE__)
#define mxSetPi(pa, pi)					mxSetPi_d(pa, pi, __FILE__, __LINE__)
#define mxSetPr(pa, pr)					mxSetPr_d(pa, pr, __FILE__, __LINE__)
#endif

#endif
 +/


/*
 * 32-bit compatibility APIs
 */
version(MX_COMPAT_32)
{
	/+ TODO:
/* Cannot inline these one on 64-bit platforms */
#if defined(_LP64) || defined(_WIN64)
#undef mxGetDimensions
#undef mxSetDimensions
#undef mxSetIr
#undef mxGetIr
#undef mxSetJc
#undef mxGetJc
#undef mxCreateStructArray
#undef mxCreateCharArray
#undef mxCreateNumericArray
#undef mxCreateCellArray
#undef mxCreateLogicalArray
#undef mxGetM
#undef mxCalcSingleSubscript
#endif

#ifndef mxSetProperty
#define mxSetProperty mxSetProperty_700
#endif
void mxSetProperty_700(mxArray *, int, const char *, const mxArray *);

#ifndef mxGetProperty
#define mxGetProperty mxGetProperty_700
#endif
mxArray *mxGetProperty_700(const mxArray *, int, const char *);

#ifndef mxSetField
#define mxSetField mxSetField_700
#endif
void mxSetField_700(mxArray *, int, const char *, mxArray *);

#ifndef mxSetFieldByNumber
#define mxSetFieldByNumber mxSetFieldByNumber_700
#endif
void mxSetFieldByNumber_700(mxArray *, int, int, mxArray *);

#ifndef mxGetFieldByNumber
#define mxGetFieldByNumber mxGetFieldByNumber_700
#endif
mxArray *mxGetFieldByNumber_700(const mxArray *, int, int);

#ifndef mxGetField
#define mxGetField mxGetField_700
#endif
mxArray *mxGetField_700(const mxArray *, int, const char *);

#ifndef mxCreateStructMatrix
#define mxCreateStructMatrix mxCreateStructMatrix_700
#endif
mxArray *mxCreateStructMatrix_700(int, int, int, const char **);

#ifndef mxCreateCellMatrix
#define mxCreateCellMatrix mxCreateCellMatrix_700
#endif
mxArray *mxCreateCellMatrix_700(int, int);

#ifndef mxCreateCharMatrixFromStrings
#define mxCreateCharMatrixFromStrings mxCreateCharMatrixFromStrings_700
#endif
mxArray *mxCreateCharMatrixFromStrings_700(int, const char **);

#ifndef mxGetString
#define mxGetString mxGetString_700
#endif
int mxGetString_700(const mxArray *, char *, int);

#ifndef mxGetNumberOfDimensions
#define mxGetNumberOfDimensions mxGetNumberOfDimensions_700
#endif
int mxGetNumberOfDimensions_700(const mxArray *);

#ifndef mxGetDimensions
#define mxGetDimensions mxGetDimensions_700
#endif
const int *mxGetDimensions_700(const mxArray *);

#ifndef mxSetDimensions
#define mxSetDimensions mxSetDimensions_700
#endif
int mxSetDimensions_700(mxArray *, const int *, int);

#ifndef mxSetIr
#define mxSetIr mxSetIr_700
#endif
void mxSetIr_700(mxArray *, int *);

#ifndef mxGetIr
#define mxGetIr mxGetIr_700
#endif
int *mxGetIr_700(const mxArray *);

#ifndef mxSetJc
#define mxSetJc mxSetJc_700
#endif
void mxSetJc_700(mxArray *, int *);

#ifndef mxGetJc
#define mxGetJc mxGetJc_700
#endif
int *mxGetJc_700(const mxArray *);

#ifndef mxCreateStructArray
#define mxCreateStructArray mxCreateStructArray_700
#endif
mxArray *mxCreateStructArray_700(int, const int *, int, const char **);

#ifndef mxCreateCharArray
#define mxCreateCharArray mxCreateCharArray_700
#endif
mxArray *mxCreateCharArray_700(int, const int *);

#ifndef mxCreateNumericArray
#define mxCreateNumericArray mxCreateNumericArray_700
#endif
mxArray *mxCreateNumericArray_700(int, const int *, mxClassID, mxComplexity);

#ifndef mxCreateCellArray
#define mxCreateCellArray mxCreateCellArray_700
#endif
mxArray *mxCreateCellArray_700(int, const int *);

#ifndef mxCreateLogicalArray
#define mxCreateLogicalArray mxCreateLogicalArray_700
#endif
mxArray *mxCreateLogicalArray_700(int, const int *);

#ifndef mxGetCell
#define mxGetCell mxGetCell_700
#endif
mxArray *mxGetCell_700(const mxArray *, int);

#ifndef mxSetCell
#define mxSetCell mxSetCell_700
#endif
void mxSetCell_700(mxArray *, int, mxArray *);

#ifndef mxSetNzmax
#define mxSetNzmax mxSetNzmax_700
#endif
void mxSetNzmax_700(mxArray *, int);

#ifndef mxSetN
#define mxSetN mxSetN_700
#endif
void mxSetN_700(mxArray *, int);

#ifndef mxSetM
#define mxSetM mxSetM_700
#endif
void mxSetM_700(mxArray *, int);

#ifndef mxGetNzmax
#define mxGetNzmax mxGetNzmax_700
#endif
int mxGetNzmax_700(const mxArray *);

#ifndef mxCreateDoubleMatrix
#define mxCreateDoubleMatrix mxCreateDoubleMatrix_700
#endif
mxArray *mxCreateDoubleMatrix_700(int, int, mxComplexity);

#ifndef mxCreateNumericMatrix
#define mxCreateNumericMatrix mxCreateNumericMatrix_700
#endif
mxArray *mxCreateNumericMatrix_700(int, int, mxClassID, int);

#ifndef mxCreateLogicalMatrix
#define mxCreateLogicalMatrix mxCreateLogicalMatrix_700
#endif
mxArray *mxCreateLogicalMatrix_700(unsigned int, unsigned int);

#ifndef mxCreateSparse
#define mxCreateSparse mxCreateSparse_700
#endif
mxArray *mxCreateSparse_700(int, int, int, mxComplexity);

#ifndef mxCreateSparseLogicalMatrix
#define mxCreateSparseLogicalMatrix mxCreateSparseLogicalMatrix_700
#endif
mxArray *mxCreateSparseLogicalMatrix_700(int, int, int);

#ifndef mxGetNChars
#define mxGetNChars mxGetNChars_700
#endif
void mxGetNChars_700(const mxArray *, char *, int);

#ifndef mxCreateStringFromNChars
#define mxCreateStringFromNChars mxCreateStringFromNChars_700
#endif
mxArray *mxCreateStringFromNChars_700(const char *, int);

#ifndef mxCalcSingleSubscript
#define mxCalcSingleSubscript mxCalcSingleSubscript_700
#endif
int mxCalcSingleSubscript_700(const mxArray *, int, const int *);

	 +/
}