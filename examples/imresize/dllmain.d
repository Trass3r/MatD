module dllmain;

import std.c.windows.windows;
import core.sys.windows.dll;

__gshared HINSTANCE hInstDll;

extern (Windows)
BOOL DllMain(HINSTANCE hInstance, ULONG ulReason, LPVOID pvReserved)
{
	switch (ulReason)
	{
		case DLL_PROCESS_ATTACH:
			hInstDll = hInstance;
			dll_process_attach( hInstance, true );
			break;

		case DLL_PROCESS_DETACH:
			dll_process_detach( hInstance, true );
			break;

		case DLL_THREAD_ATTACH:
			dll_thread_attach( true, true );
			break;

		case DLL_THREAD_DETACH:
			dll_thread_detach( true, true );
			break;

		default:
			assert(0);
	}

	return true;
}
