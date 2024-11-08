#include "pch.h"
#include "C_DLL.h"

void MyProc1(uint8_t* ptr, int height, int width, int start, int end) {
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
		end = height - 1;
	}

	for (int i = 1; i < width - 1; i++) {
		for (int j = start; j < end; j++) {
			int R = 0;
			int G = 0;
			int B = 0;

			for (int k = -1; k <= 1; k++) {
				for (int l = -1; l <= 1; l++) {
					int px_ind = ((i + k) * height + (j + l)) * chanels;
					R += ptr[px_ind] * mask[k + 1][l + 1];
					G += ptr[px_ind + 1] * mask[k + 1][l + 1];
					B += ptr[px_ind + 2] * mask[k + 1][l + 1];
				}
			}

			int temp_ind = (i * height + j) * chanels;
			temp_ptr[temp_ind] = (uint8_t)R;
			temp_ptr[temp_ind+1] = (uint8_t)G;
			temp_ptr[temp_ind+2] = (uint8_t)B;
		}
	}

	for (int i = 0; i < width; i++) {
		for (int j = start; j < end; j++) {
			int ind = (i * height + j) * chanels;
			ptr[ind] = temp_ptr[ind];
			ptr[ind+1] = temp_ptr[ind+1];
			ptr[ind+2] = temp_ptr[ind+2];
		}
	}
	free(temp_ptr);
}