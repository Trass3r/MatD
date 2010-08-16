/**
 *	functions to get interface with the current workspace.
 */
module matd.c.engine;

pragma(lib, "libeng");

public import matd.c.matrix;


extern (C):

alias void Engine; //! alias struct engine Engine

/**
 * Execute matlab statement
 */
int engEvalString(
	Engine			*ep,	// engine pointer
	const(char)*	string	// string for matlab t execute
	);


/**
 * Start matlab process for single use.
 * Not currently supported on UNIX.
 */
Engine* engOpenSingleUse(
			 const(char)*	startcmd,	// exec command string used to start matlab
			 void*			reserved,	// reserved for future use, must be NULL
			 int*			retstatus	// return status
);


/**
 * SetVisible, do nothing since this function is only for NT 
 */ 
int engSetVisible( 
		  Engine*	ep,		// engine pointer 
		  bool		newVal 
		  );


/** 
 * GetVisible, do nothing since this function is only for NT 
 */ 
int engGetVisible( 
		  Engine*	ep,		// engine pointer 
		  bool*		bVal
		  );


/** 
 * Start matlab process
 */
Engine* engOpen(
	const(char)* startcmd // exec command string used to start matlab
	);


/**
 * Close down matlab server
 */
int engClose(
	Engine* ep         // engine pointer
	);


/**
 * Get a variable with the specified name from MATLAB's workspace
 */
mxArray *engGetVariable(
	Engine*			ep,		// engine pointer
	const(char)*	name	// name of variable to get
	);


/**
 * Put a variable into MATLAB's workspace with the specified name
 */
int engPutVariable(
		   Engine*			ep,			// engine pointer
		   const(char)*		var_name,
		   const(mxArray)*	ap			// array pointer
		   );


/**
 * register a buffer to hold matlab text output
 */
int engOutputBuffer(
	Engine*	ep,		// engine pointer
	char*	buffer,	// character array to hold output
	int		buflen	// buffer array length
	);