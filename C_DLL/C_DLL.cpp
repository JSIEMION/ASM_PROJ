#include "pch.h"
#include "C_DLL.h"

void MyProc1(uint8_t* sourcePtr, uint8_t* destPtr, int height, int width, int start, int end) {
	int mask[3][3] = {
		{-1,-1,-1},
		{-1,9,-1},
		{-1,-1,-1}
	};

	int chanels = 3;

	uint8_t* temp_ptr = (uint8_t*)malloc(height * width * chanels);

	if (!temp_ptr) {
		return;
	}

	if (start < 1) {
		start = 1;
	}
	if (end > height - 1) {
		end = height -1;
	}
	
	for (int i = start; i < end; i++) {
		for (int j = 1; j < width - 1; j++) {
			int R = 0;
			int G = 0;
			int B = 0;

			for (int k = -1; k <= 1; k++) {
				for (int l = -1; l <= 1; l++) {
					int ind = ((i + k) * width + (j + l)) * chanels;
					B += sourcePtr[ind] * mask[k + 1][l + 1];
					G += sourcePtr[ind + 1] * mask[k + 1][l + 1];
					R += sourcePtr[ind + 2] * mask[k + 1][l + 1];
				}
			}

			if (R < 0) {
				R = 0;
			}
			else if (R > 255) {
				R = 255;
			}
			
			if (G < 0) {
				G = 0;
			}
			else if (G > 255) {
				G = 255;
			}
			
			if (B < 0) {
				B = 0;
			}
			else if (B > 255) {
				B = 255;
			}

			int destInd = (i * width + j) * chanels;
			destPtr[destInd] = (uint8_t)(B);
			destPtr[destInd + 1] = (uint8_t)(G);
			destPtr[destInd + 2] = (uint8_t)(R);
		}
	}



	free(temp_ptr);
}