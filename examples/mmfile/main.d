/***********************************************************
 * provides a way to open a file via memory mapping
 *
 * useful for working with huge files
 **********************************************************/
module mmfile;

import matd.c.mex;
import std.mmfile;
import std.conv;

__gshared initialized = false;
//__gshared mxArray* persistentArray;
//__gshared void* memory_holder;


extern(C) void mexExitFunction()
{
//	mxSetData(persistentArray, memory_holder);
//	mxDestroyArray(persistentArray);
}

//! the gateway function
export extern(C) void mexFunction( int nlhs, mxArray** plhs,
				  int nrhs, const(mxArray)** prhs)
{
	if (!initialized)
	{
		mexPrintf("initializing...\n");
		/************************************************************* 
		 Register the MEX exit function first time thru mex file. 
		 Setup a persistent mxArray that we will us for passing data 
		*************************************************************/
//		mexAtExit(&mexExitFunction); 
//		persistentArray = mxCreateString(" "); 
//		mexMakeArrayPersistent(persistentArray);
//		memory_holder = mxGetData(persistentArray);
		
		initialized = true;
		mexPrintf("initialization done\n");
	}
	
	/***************************************************************
	 Actual work of the MEX file.
	***************************************************************/
	if (nrhs==1 && nlhs == 1)
	{
		mexPrintf("doing my job\n");
		char* filename = mxArrayToString(prhs[0]);
		if (filename !is null)
		{
			mexPrintf("opening file %s\n", filename);
			scope mmFile = new MmFile(to!string(filename));
			mexPrintf("file pointer: %p\n", mmFile[].ptr);
			mexPrintf("filesize: %d\n", mmFile[].length);
			
			plhs[0] = mxCreateString(cast(char*)mmFile[].ptr);
		}
	}

/+
		// User wants to put data into memory map file
		hObj.putData(mxGetPr(prhs[0]), 
		mxGetNumberOfElements(prhs[0]));
	}
	else // Or user wants to get data from memory mapped file.
	{
		plhs[0]=persistentArray;
	
		// Notice that we pass back a pointer to the mem-map
		// and we do not copy the data out of the point
		mxSetPr(plhs[0],hObj.getPointer());
		// Tell the mxArray the size of the data in the mem-map
		mxSetN(plhs[0],hObj->getLength());
	}
+/
}
