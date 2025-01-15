#pragma once

#ifdef MATHLIBRARY_EXPORTS
#define MATHLIBRARY_API __declspec(dllexport)
#else
#define MATHLIBRARY_API __declspec(dllimport)
#endif

extern "C" MATHLIBRARY_API void cProc(uint8_t* sourcePtr, uint8_t* destPtr, int height, int width, int start, int end);