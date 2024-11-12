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
	printf("Width: %d", width);
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
					int ind = ((i + k) * width + (j + l)) * chanels;// +(i + k) * 2;
					//printf("X: %d, Y: %d; ", j+l, i+k);
					//printf("B: %d, G: %d, R: %d; \n", ptr[ind], ptr[ind+1], ptr[ind+2]);

					B += ptr[ind] * mask[k + 1][l + 1];
					G += ptr[ind + 1] * mask[k + 1][l + 1];
					R += ptr[ind + 2] * mask[k + 1][l + 1];
				}
			}

			if (R < 0) {
				R = 0;
			}
			if (G < 0) {
				G = 0;
			}
			if (B < 0) {
				B = 0;
			}
			int temp_ind = (i * width + j) * chanels;// + 2*i;
			//printf("B: %d, G: %d, R: %d; \n", B,G,R);
			temp_ptr[temp_ind] = (uint8_t)(B);
			temp_ptr[temp_ind + 1] = (uint8_t)(G);
			temp_ptr[temp_ind + 2] = (uint8_t)(R);
		}
	}

	for (int i = start; i < end; i++) {
		for (int j = 1; j < width-1; j++) {
			int ind = (i * width + j) * chanels;// +i * 2;
			//printf("X: %d, Y: %d; ", j, i);
			//printf("1: %d, 2: %d, 3: %d; \n", ptr[ind], ptr[ind+1], ptr[ind+2]);
			ptr[ind] = temp_ptr[ind]; // B
			ptr[ind + 1] = temp_ptr[ind + 1]; // G
			ptr[ind + 2] = temp_ptr[ind + 2]; // R
		}
	}
	//for (int i = 0; i <= 100; i++) {
	//	printf("%d \n", ptr[i]);
	//}
	free(temp_ptr);
}