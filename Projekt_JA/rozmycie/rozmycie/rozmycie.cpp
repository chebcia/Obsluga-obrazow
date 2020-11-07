// rozmycie.cpp : Defines the exported functions for the DLL application.
//
#include "stdafx.h"
#include <iostream>
#include <string>
#include <thread>
#define DllExport   __declspec( dllexport )

using namespace std;


extern "C" {
	
	DllExport void rozmycie(uint8_t* img, int height, int width, int threads);
	DllExport void b_w(uint8_t *arrayTest, int start, int stop);
	DllExport void sep(uint8_t *arrayTest, int start, int stop);
	DllExport void neg(uint8_t *arrayTest, int start, int stop);
	
}
void gauss(uint8_t * img, double * dest, int start, int stop, double* kernel, int n_of_channels, int half_kernel, int height, int width, int kernel_dim);
void rozmycie(uint8_t* img, int height, int width, int th_n)
{
	//definicje 
	double sigma = 10;
	int kernel_dim = 11;
	int n_of_channels = 4;
	int kernel_size = kernel_dim * kernel_dim;
	int half_kernel = (kernel_dim - 1) / 2;
	double* dest = new double[n_of_channels * width * height];
	thread *th = new thread[th_n - 1]; // deklarowanie tablicy threadow
	int start, stop;
	int work_to_do =  (height-2*kernel_dim) / th_n;
	// tworzenie obrazu / tablicy wyjsciowej / inicjalizacja SB
	for (int i = 0; i < n_of_channels * width * height; ++i) {
		dest[i] = 0;
	}
	// tworzenie kernela
	double* kernel = new double[kernel_size];
	double sum = 0;
	for (int i = 0; i < kernel_size; ++i) {
		//gauss
		double horizontal_distance = abs(i % kernel_dim - half_kernel);
		double vertical_distance = abs(floor(i / kernel_dim) - half_kernel);
		double x = sqrt(horizontal_distance * horizontal_distance + vertical_distance * vertical_distance);
		kernel[i] = pow(2.71, -x * x / (2 * sigma*sigma)) / (sqrt(2 * 3.14159) * sigma);
		sum += kernel[i];
	}


	// normalizacja
	for (int i = 0; i < kernel_size; ++i) {
		kernel[i] /= sum;
	}

	// odpalanie threadow
	for (int i = 0; i < th_n - 1; ++i) { // 1 dla maina zostawimy
		start = i* work_to_do + kernel_dim;
		stop = (i+1) * work_to_do + kernel_dim;
			th[i] = thread(gauss,img, dest, start, stop, kernel, n_of_channels, half_kernel, height, width, kernel_dim);
	}
	for (int i = th_n - 1; i < th_n; ++i) { // to co main robi
		stop = height - kernel_dim;
		start = i * work_to_do + kernel_dim;
		gauss(img, dest, start, stop, kernel,  n_of_channels,  half_kernel,  height,  width, kernel_dim);

	}

	for (int i = 0; i < th_n - 1; ++i)
		th[i].join();


	for (int i = 0; i < n_of_channels * width * height; ++i) {
		if (i % 4 == 3){
			img[i] = 255;
			continue;
		}
		img[i] = (uint8_t)dest[i];
	}
}

void gauss(uint8_t * img, double * dest, int start, int stop, double* kernel, int n_of_channels, int half_kernel, int height, int width, int kernel_dim)
{
	constexpr int r_off = 0x0;
	constexpr int g_off = 0x1;
	constexpr int b_off = 0x2;
	constexpr int a_off = 0x3;

	for (int h = start; h < stop; ++h) {
		for (int w = half_kernel; w < width - half_kernel; ++w) {
			for (int k_h = 0; k_h < kernel_dim; ++k_h) {
				for (int k_w = 0; k_w < kernel_dim; ++k_w) {
					size_t dst_off_1 = r_off + n_of_channels * (w + h * width);
					size_t dst_off_2 = g_off + n_of_channels * (w + h * width);
					size_t dst_off_3 = b_off + n_of_channels * (w + h * width);
					size_t dst_off_4 = a_off + n_of_channels * (w + h * width);

					size_t k_off = k_w + k_h * kernel_dim;
					size_t im_off = n_of_channels
						* ((w - half_kernel + k_w)
							+ (h - half_kernel + k_h) * width);

					size_t im_off_1 = r_off + im_off;
					size_t im_off_2 = g_off + im_off;
					size_t im_off_3 = b_off + im_off;
					size_t im_off_4 = a_off + im_off;

					dest[dst_off_1] += kernel[k_off] * img[im_off_1];
					dest[dst_off_2] += kernel[k_off] * img[im_off_2];
					dest[dst_off_3] += kernel[k_off] * img[im_off_3];
					dest[dst_off_4] += kernel[k_off] * img[im_off_4];
				}
			}
		}
	}
}

void sep(uint8_t* arrayTest, int start, int stop)
{

	int alpha = 255;
	int red, green, blue;
	for (int i = start; i < stop; i += 4)
	{
		red = (.393 * arrayTest[i]) + (.769 * arrayTest[i + 1]) + (.189 * arrayTest[i + 2]); 
		green = (.349 * arrayTest[i]) + (.686 * arrayTest[i + 1]) + (.168 * arrayTest[i + 2]);
		blue = (.272 * arrayTest[i]) + (.534 * arrayTest[i + 1]) + (.131 * arrayTest[i + 2]);
		arrayTest[i + 3] = alpha;
		arrayTest[i+2] = red + (red > 255) * (255-red);
		arrayTest[i + 1] = green + (green> 255) * (255-green);
		arrayTest[i ] = blue + (blue > 255) * ( 255 - blue);
		
	}
}


void neg(uint8_t* arrayTest, int start, int stop)
{
	int alpha = 255;
	for (int i = start; i < stop; i += 4) 
	{
		arrayTest[i] = 255 - arrayTest[i];
		arrayTest[i + 1] = 255 - arrayTest[i + 1];
		arrayTest[i + 2] = 255 - arrayTest[i + 2];
		arrayTest[i + 3] = alpha;
	}
}
void b_w(uint8_t *arrayTest, int start, int stop)
{

	int avg;
	int alpha = 255;
	for (int i = start; i < stop; i += 4) {

		avg = 0.2989 *arrayTest[i + 2] + 0.5870 *arrayTest[i + 1] + 0.11*arrayTest[i];
		arrayTest[i] = avg;
		arrayTest[i + 1] = avg;
		arrayTest[i + 2] = avg;
		arrayTest[i + 3] = alpha;
	}
}