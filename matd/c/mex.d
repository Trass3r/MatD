/**
 *	This file declares all the types, macros and functions
 *	necessary to interface mex files with the current version
 *	of MATLAB.
 */
module matd.c.mex;

//pragma(lib, "libmex");
version = MATLAB_MEX_FILE;
public import matd.c.matrix;

extern(C):

alias void MEX_impl_info; // alias struct impl_info_tag* MEX_impl_info;

alias extern(C) void function() mex_exit_fn; //!

struct mexGlobalTableEntry
{
    const(char)*	name;		// The name of the global
    mxArray**		variable;	// A pointer to the variable
}
alias mexGlobalTableEntry* mexGlobalTable;

/* TODO
#ifdef _WIN32
#define cicompare(s1,s2) utStrcmpi((s1),(s2))
#else
#define cicompare(s1,s2) strcmp((s1),(s2))
#endif
#define cscompare(s1,s2) strcmp((s1),(s2))
*/

struct mexFunctionTableEntry
{
    const(char)*	name;
    mxFunctionPtr	f;
    int				nargin;
    int				nargout;
    _mexLocalFunctionTable*	local_function_table;
}
alias mexFunctionTableEntry* mexFunctionTable;

struct _mexLocalFunctionTable
{
    size_t				length;
    mexFunctionTable	entries;
}
alias _mexLocalFunctionTable* mexLocalFunctionTable;

struct _mexInitTermTableEntry
{
    void  function() initialize;
    void  function() terminate;
}
alias _mexInitTermTableEntry* mexInitTermTableEntry;

const MEX_INFORMATION_VERSION = 1;

struct _mex_information
{
    int						ver; // TODO: this normally is named "version"
    int						file_function_table_length;
    mexFunctionTable		file_function_table;
    int						global_variable_table_length;
    mexGlobalTable			global_variable_table;
    int						npaths;
    const(char)**			paths;
    int						init_term_table_length;
    mexInitTermTableEntry	init_term_table;
}
alias _mex_information* mex_information;

alias mex_information function() fn_mex_file;

alias void function() fn_clean_up_after_error;
alias const(char)* function(mxFunctionPtr f) fn_simple_function_to_string;

alias void  function(mex_information x) fn_mex_enter_mex_library;
alias fn_mex_enter_mex_library fn_mex_exit_mex_library;

alias mexLocalFunctionTable  function() fn_mex_get_local_function_table;
alias mexLocalFunctionTable  function(mexLocalFunctionTable) fn_mex_set_local_function_table;


/**
 *	mexFunction is the user-defined C routine that is called upon invocation
 *	of a MEX-function.
 *
 *	Params:
 *		nlhs = Number of expected mxArrays (Left Hand Side)
 *		plhs = Array of pointers to expected outputs
 *		nrhs = Number of inputs (Right Hand Side)
 *		prhs = Array of pointers to input data
 *
 *	The input data is read-only and should not be altered by your mexFunction.
 *	The variables nrhs and nlhs are the number of variables that MATLAB requested at this instance.
 *	They are analogous to NARGIN and NARGOUT in MATLAB.
 *	The variables prhs and plhs are not mxArrays. They are arrays of pointers to mxArrays.
 *	So if a function is given three inputs, prhs will be an array of three pointers to the mxArrays that contain the data passed in.
 *	The variable prhs is declared as const. This means that the values that are passed into the MEX-file should not be altered.
 *	Doing so can cause segmentation violations in MATLAB. The values in plhs are invalid when the MEX-file begins.
 *	The mxArrays they point to must be explicitly created before they are used.
 *	Compilers will not catch this issue, but it will cause incorrect results or segmentation violations.
 */
void mexFunction(
    int					nlhs, // number of expected outputs
    mxArray**			plhs, // array of pointers to output arguments
    int					nrhs, // number of inputs
    const(mxArray)**	prhs  // array of pointers to input arguments
);


/**
 * Issue error message and return to MATLAB prompt
 */
void mexErrMsgTxt(const(char)* error_msg);


/**
 * Issue formatted error message with corresponding error identifier and return to MATLAB
 * prompt.
 */
void mexErrMsgIdAndTxt(
    const(char)* identifier, // string with error message identifier
    const(char)* err_msg,    // string with error message printf-style format
    ...                      // any additional arguments
);


/**
 * Invoke an unidentified warning. Such warnings can only be affected by the M-code
 * 'warning * all', since they have no specific identifier. See also mexWarnMsgIdAndTxt.
 */
void mexWarnMsgTxt(const(char)* warn_msg);


/**
 * Invoke a warning with message identifier 'identifier' and message derived from 'fmt' and
 * subsequent arguments. The warning may either get printed as is (if it is set to 'on'), or
 * not actually get printed (if set to 'off'). See 'help warning' in MATLAB for more
 * details.
 */
void  mexWarnMsgIdAndTxt(
	const(char)* identifier,/* string with warning message identifer */
	const(char)* warn_msg,	/* string with warning message printf-style format */
	...						/* any additional arguments */
);


/**
 * mex equivalent to MATLAB's "disp" function
 */
int mexPrintf(
	const(char)* fmt, // printf style format
	...
);

alias mexPrintf printf; //! ditto

/**
 * Remove all components of an array plus the array header itself
 * from MATLAB's memory allocation list.  The array will now
 * persist between calls to the mex function.  To destroy this
 * array, you will need to explicitly call mxDestroyArray().
 */
void mexMakeArrayPersistent(mxArray* pa);


/**
 * Remove memory previously allocated via mxCalloc from MATLAB's
 * memory allocation list.  To free this memory, you will need to
 * explicitly call mxFree().
 */
void mexMakeMemoryPersistent(void* ptr);


/**
 * mex equivalent to MATLAB's "set" function
 */
int mexSet(double handle, const(char)* property, mxArray* value);


//! API interface which mimics the "get" function
const(mxArray)* mexGet(double handle, const(char)* property);


/**
 * call MATLAB function
 */
int mexCallMATLAB(
	int			nlhs,		/* number of expected outputs */
	mxArray**	plhs,		/* pointer array to outputs */
	int			nrhs,		/* number of inputs */
	mxArray**	prhs,		/* pointer array to inputs */
	const(char)*fcn_name	/* name of function to execute */
);


/**
 * call MATLAB function with Trap
 */
mxArray* mexCallMATLABWithTrap(
	int			nlhs,	/* number of expected outputs */
	mxArray**	plhs,	/* pointer array to outputs */
	int			nrhs,	/* number of inputs */
	mxArray**	prhs,	/* pointer array to inputs */
	const(char)*fcn_name	/* name of function to execute */
);

/**
 * set or clear mexCallMATLAB trap flag (if set then an error in  
 * mexCallMATLAB is caught and mexCallMATLAB will return a status value, 
 * if not set an error will cause control to revert to MATLAB)
 */
void mexSetTrapFlag(int flag);


/**
 * Print an assertion-style error message and return control to the
 * MATLAB command line.
 */
 
void  mexPrintAssertion(const(char)* test, const(char)* fname, int linenum, const(char)* message);


/**
 * Tell whether or not a mxArray is in MATLAB's global workspace.
 */
bool  mexIsGlobal(const(mxArray)* pA);


/**
 * Place a copy of the array value into the specified workspace with the
 * specified name
 */
int mexPutVariable(
	const(char)*	workspace,
	const(char)*	name,
	const(mxArray)*	parray // matrix to copy
);


/**
 * return a pointer to the array value with the specified variable
 * name in the specified workspace
 */
const(mxArray)* mexGetVariablePtr(
	const(char)* workspace,
	const(char)* name	// name of symbol
);


/**
 * return a copy of the array value with the specified variable
 * name in the specified workspace
 */
mxArray* mexGetVariable(
	const(char)* workspace,
	const(char)* name	// name of variable in question
);


/**
 * Lock a MEX-function so that it cannot be cleared from memory.
 */
void mexLock();


/**
 * Unlock a locked MEX-function so that it can be cleared from memory.
 */
void mexUnlock();


/**
 * Return true if the MEX-function is currently locked, false otherwise.
 */
bool mexIsLocked();


/**
 * Return the name of the MEXfunction currently executing.
 */
const(char)* mexFunctionName();


/**
 * Parse and execute MATLAB syntax in string.  Returns zero if successful,
 * and a non zero value if an error occurs.
 */
int mexEvalString(
	const(char)* str	// matlab command string
);


/**
 * Parse and execute MATLAB syntax in string.  Returns NULL if successful,
 * and an MException if an error occurs.
 */
mxArray* mexEvalStringWithTrap(
	const(char)* str	// matlab command string
);


/**
 * Register Mex-file's At-Exit function (accessed via MEX callback)
 */
int  mexAtExit(mex_exit_fn exit_fcn);