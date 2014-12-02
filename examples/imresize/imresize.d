/**
 * simple imresize implementation
 */
module imresize;

import matd.c.mex;

//! the gateway function
export extern(C) void mexFunction(int nlhs, mxArray** plhs,
                                  int nrhs, const(mxArray)** prhs)
{
	if (nlhs != 1 || nrhs != 2)
	{
		mexPrintf("Invalid arguments\n");
		return;
	}

	asm { int 3; }

	const(mxArray)* A = prhs[0], scaleM = prhs[1];

	mxClassID category = mxGetClassID(A);
	// it's mxDOUBLE_CLASS
	if (mxIsSparse(A))
		return;
	if (!mxIsNumeric(scaleM) || mxGetM(scaleM) != 1 || mxGetN(scaleM) != 1)
		return;

	assert(mxGetClassID(scaleM) == mxDOUBLE_CLASS);
	const double scale = *mxGetPr(scaleM);
	const double invscale = 1 / scale;

	bool a = mxIsNumeric(A);
	bool b = mxIsCell(A);
	bool c = mxIsStruct(A);

	assert(category == mxDOUBLE_CLASS);

	const size_t width  = mxGetN(A);
	const size_t height = mxGetM(A);
	double* pr = mxGetPr(A);
	mwSize numElements = mxGetNumberOfElements(A);

	// TODO: better than cast
	const size_t widthB = cast(size_t)(width * scale);
	const size_t heightB = cast(size_t)(height * scale);

	mxArray* B = mxCreateDoubleMatrix(heightB, widthB, mxREAL);
	double* prB = mxGetPr(B);

	for (mwSize colB = 0; colB < widthB; ++colB)
	{
		for (mwSize rowB = 0; rowB < heightB; ++rowB)
		{
			//mwSize col = (colB + 0.5) * invscale
			//pr[col * height + row];
		}
	}


	/*
	switch (category)
	{
		case mxClassID.mxLOGICAL_CLASS:	analyze_logical(array_ptr);		break;
		case mxClassID.mxCHAR_CLASS:	analyze_string(array_ptr);		break;
		case mxClassID.mxSTRUCT_CLASS:	analyze_structure(array_ptr);	break;
		case mxClassID.mxCELL_CLASS:	analyze_cell(array_ptr);		break;
		case mxClassID.mxUNKNOWN_CLASS:	mexWarnMsgTxt("Unknown class.");break;
		default: analyze_full(array_ptr);								break;
	}
	*/


}
