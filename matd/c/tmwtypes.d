/**
 *	Data types for use with MATLAB/SIMULINK and the Real-Time Workshop.
 *
 *	When compiling stand-alone model code, data types can be overridden
 *	via compiler switches.
 */
module matd.c.tmwtypes;

extern(C):

version = LOGICAL_IS_A_TYPE;
version = SPARSE_GENERALIZATION;

const FLT_MANT_DIG = 24;
const DBL_MANT_DIG = 53;


//! The following data types cannot be overridden when building MEX files.

/+
TODO:
#ifdef MATLAB_MEX_FILE
# undef CHARACTER_T
# undef INTEGER_T
# undef BOOLEAN_T
# undef REAL_T
# undef TIME_T
#endif
 +/

/*
 * The uchar_T, ushort_T and ulong_T types are needed for compilers which do 
 * not allow defines to be specified, at the command line, with spaces in them.
 */

alias ubyte uchar_T;	//!
alias ushort ushort_T;	//!
alias uint ulong_T;		//!


/*=======================================================================*
 * Fixed width word size data types:                                     *
 *   int8_T, int16_T, int32_T     - signed 8, 16, or 32 bit integers     *
 *   uint8_T, uint16_T, uint32_T  - unsigned 8, 16, or 32 bit integers   *
 *   real32_T, real64_T           - 32 and 64 bit floating point numbers *
 *=======================================================================*/

/* When used with Real Time Workshop generated code, this
 * header file can be used with a variety of compilers.
 *
 * The compiler could be for an 8 bit embedded processor that
 * only had 8 bits per integer and 16 bits per long.
 * In that example, a 32 bit integer size is not even available.
 * This header file should be robust to that.   
 *
 * For the case of an 8 bit processor, the preprocessor
 * may be limited to 16 bit math like its target.  That limitation 
 * would mean that 32 bit comparisons can't be done accurately.  
 * To increase robustness to this, comparisons are done against
 * smaller values first.  An inaccurate 32 bit comparison isn't
 * attempted if the 16 bit comparison has already succeeded.
 *
 * Limitations on preprocessor math can also be stricter than
 * for the target.  There are known cases where a compiler
 * targeting processors with 64 bit longs can't do accurate
 * preprocessor comparisons on more than 32 bits.  
 */

/* Determine the number of bits for int, long, short, and char.
 * If one fails to be determined, set the number of bits to -1
 */
const TMW_BITS_PER_INT = 32;	//!
const TMW_BITS_PER_LONG = 32;	//!
const TMW_BITS_PER_SHRT = 16;	//!
const TMW_BITS_PER_SCHAR = 8;	//!
const TMW_CHAR_SIGNED = 1;		//!

/* It is common for one or more of the integer types
 * to be the same size.  For example, on many embedded
 * processors, both shorts and ints are 16 bits.  On
 * processors used for workstations, it is quite common
 * for both int and long to be 32 bits.  
 *   When there is more than one choice for typdef'ing
 * a portable type like int16_T or uint32_T, in
 * concept, it should not matter which choice is made.
 * However, some style guides and some code checking
 * tools do identify and complain about seemingly
 * irrelevant differences.  For example, a code
 * checking tool may complain about an implicit
 * conversion from int to short even though both
 * are 16 bits.  To reduce these types of
 * complaints, it is best to make int the
 * preferred choice when more than one is available.
 */

alias byte INT8_T;	//!
alias byte int8_T;	//! ditto

alias ubyte UINT8_T;	//!
alias ubyte uint8_T;	//! ditto

alias short INT16_T;	//!
alias short int16_T;	//! ditto

alias ushort UINT16_T;	//!
alias ushort uint16_T;	//! ditto

alias int INT32_T;	//!
alias int int32_T;	//! ditto

alias uint UINT32_T;	//!
alias uint uint32_T;	//! ditto


alias float REAL32_T;	//!
alias float real32_T;	//! ditto

alias double REAL64_T;	//!
alias double real64_T;	//! ditto


/*=======================================================================*
 * Fixed width word size data types:                                     *
 *   int64_T                      - signed 64 bit integers               *
 *   uint64_T                     - unsigned 64 bit integers             *
 *=======================================================================*/

alias long INT64_T;	//!
alias long int64_T;	//! ditto
const FMT64 = "L";

alias ulong UINT64_T;	//!
alias ulong uint64_T;	//! ditto

/*===========================================================================*
 * Format string modifiers for using size_t variables in printf statements.  *
 *===========================================================================*/
// TODO:
const FMT_SIZE_T = "";
const FMT_PTRDIFF_T = "";

/*===========================================================================*
 * General or logical data types where the word size is not guaranteed.      *
 *  real_T     - possible settings include real32_T or real64_T              *
 *  time_T     - possible settings include real64_T or uint32_T              *
 *  boolean_T                                                                *
 *  char_T                                                                   *
 *  int_T                                                                    *
 *  uint_T                                                                   *
 *  byte_T                                                                   *
 *===========================================================================*/

alias real64_T REAL_T;	//!
alias REAL_T real_T;	//! ditto

alias real_T TIME_T;	//!
alias TIME_T time_T;	//! ditto

alias bool BOOLEAN_T;		//!
alias BOOLEAN_T boolean_T;	//! ditto

alias char CHARACTER_T;		//!
alias CHARACTER_T char_T;	//! ditto

alias int INTEGER_T;	//!
alias INTEGER_T int_T;	//! ditto

alias uint UINTEGER_T;		//!
alias UINTEGER_T uint_T;	//! ditto

alias ubyte byte_T;	//!


/*===========================================================================*
 * Define Complex Structures                                                 *
 *===========================================================================*/

//!
struct creal32_T
{
    real32_T re;
    real32_T im;
}
alias creal32_T CREAL32_T; //! ditto

//!
struct creal64_T
{
    real64_T re;
    real64_T im;
}
alias creal64_T CREAL64_T; //! ditto

//!
struct creal_T
{
    real_T re;
    real_T im;
}
alias creal_T CREAL_T; //! ditto

//!
struct cint8_T
{
    int8_T re;
    int8_T im;
}
alias cint8_T CINT8_T; //! ditto

//!
struct cuint8_T
{
    uint8_T re;
    uint8_T im;
}
alias cuint8_T CUINT8_T; //! ditto

//!
struct cint16_T
{
    int16_T re;
    int16_T im;
}
alias cint16_T CINT16_T; //! ditto

//!
struct cuint16_T
{
    uint16_T re;
    uint16_T im;
}
alias cuint16_T CUINT16_T; //! ditto

//!
struct cint32_T
{
    int32_T re;
    int32_T im;
}
alias cint32_T CINT32_T; //! ditto

//!
struct cuint32_T
{
    uint32_T re;
    uint32_T im;
}
alias cuint32_T CUINT32_T; //! ditto

/*=======================================================================*
 * Min and Max:                                                          *
 *   int8_T, int16_T, int32_T     - signed 8, 16, or 32 bit integers     *
 *   uint8_T, uint16_T, uint32_T  - unsigned 8, 16, or 32 bit integers   *
 *=======================================================================*/
const MAX_int8_T = cast(int8_T)(127);            /* 127  */
const MIN_int8_T = cast(int8_T)(-128);           /* -128 */
const MAX_uint8_T = cast(uint8_T)(255);           /* 255  */
const MIN_uint8_T = cast(uint8_T)(0);

const MAX_int16_T = cast(int16_T)(32767);         /* 32767 */
const MIN_int16_T = cast(int16_T)(-32768);        /* -32768 */
const MAX_uint16_T = cast(uint16_T)(65535);        /* 65535 */
const MIN_uint16_T = cast(uint16_T)(0);

const MAX_int32_T = cast(int32_T)(2147483647);    /* 2147483647  */
const MIN_int32_T = cast(int32_T)(-2147483647-1); /* -2147483648 */
const MAX_uint32_T = cast(uint32_T)(0xFFFFFFFFU);  /* 4294967295  */
const MIN_uint32_T = cast(uint32_T)(0);

const MAX_int64_T = cast(int64_T)(9223372036854775807L);
const MIN_int64_T = cast(int64_T)(-9223372036854775807L-1L);

const MAX_uint64_T = cast(uint64_T)(0xFFFFFFFFFFFFFFFFUL);
const MIN_uint64_T = cast(uint64_T)(0);


/* Conversion from unsigned __int64 to double is not implemented in windows
 * and results in a compile error, thus the value must first be cast to
 * signed __int64, and then to double.
 *
 * If the 64 bit int value is greater than 2^63-1, which is the signed int64 max,
 * the macro below provides a workaround for casting a uint64 value to a double
 * in windows.
 */
/* The largest double value that can be cast to uint64 in windows is the
 * signed int64 max, which is 2^63-1. The macro below provides
 * a workaround for casting large double values to uint64 in windows.
 */
/* double_to_uint64 defined only for MSVC and UNIX */
// TODO: check if this is the case for D


/* 
 * This software assumes that the code is being compiled on a target using a 
 * 2's complement representation for signed integer values.
 */
static if ((byte.min + 1) != -byte.max)
	pragma(msg, "This code must be compiled using a 2's complement representation for signed integer values");

/**
 * Maximum length of a MATLAB identifier (function/variable/model)
 * including the null-termination character.
 */
const TMW_NAME_LENGTH_MAX = 64;

/*
 * Maximum values for indices and dimensions
 */
// TODO: version(MX_COMPAT_32) use int's?
alias size_t mwSize;
alias size_t mwIndex;
alias ptrdiff_t mwSignedIndex;

// Currently 2^48 based on hardware limitations
version(D_LP64)
{
	const MWSIZE_MAX    = 281474976710655UL;	//!
	const MWINDEX_MAX   = 281474976710655UL;	//!
	const MWSINDEX_MAX  = 281474976710655L;		//!
	const MWSINDEX_MIN  = -281474976710655L;	//!
}
else
{
	const MWSIZE_MAX	= 2147483647U;	//!
	const MWINDEX_MAX	= 2147483647U;	//!
	const MWSINDEX_MAX	= 2147483647;	//!
	const MWSINDEX_MIN	= -2147483647;	//!
}
const MWSIZE_MIN = 0U;	//!
const MWINDEX_MIN = 0U;	//!