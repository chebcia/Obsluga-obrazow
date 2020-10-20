// rozmycie.cpp : Defines the exported functions for the DLL application.
//
#include "stdafx.h"
#include <iostream>
#include <string>
#include <thread>
#define DllExport   __declspec( dllexport )

using namespace std;

extern "C" {
	DllExport void black_white(uint8_t*, int len, int threads);
	DllExport void rozmycie(uint8_t* img, int height, int width, int threads);
	DllExport void edge(uint8_t* img, int height, int width, int threads);
	DllExport void sepia(uint8_t*, int len, int thread);
	DllExport void negative(uint8_t*, int len, int thread);
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
	// tworzenie obrazu / tablicy wyjsciowej / inicjalizacja 
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
		// blur
		//kernel[i] = 1; // mean blur
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

	for (int c = 0; c < n_of_channels; ++c) {
		for (int h = start; h < stop; ++h) {
			for (int w = half_kernel; w < width - half_kernel; ++w) {
				for (int k_h = 0; k_h < kernel_dim; ++k_h) {
					for (int k_w = 0; k_w < kernel_dim; ++k_w) {
						dest[c + n_of_channels * (w + h * width)] += kernel[k_w + k_h * kernel_dim] * img[c + n_of_channels * ((w - half_kernel + k_w) + (h - half_kernel + k_h) * width)];
					}
				}
			}
		}
	}

}

void b_w(uint8_t* arrayTest, int start, int stop, int len);
void black_white(uint8_t* arrayTest, int len, int threads) {

	thread *thready = new thread[threads - 1];
	int work_to_do = len / threads;
	int start, stop;

	
	for (int i = 0; i < threads - 1; ++i) { // 1 dla maina zostawimy
		start = i * work_to_do;
		stop = (i + 1) * work_to_do;
		thready[i] = thread(b_w, arrayTest, start, stop, len);
	}
	for (int i = threads - 1; i < threads; ++i) { // to co main robi
		stop = len;
		start = i * work_to_do;
		b_w(arrayTest, start, stop, len);

	}

	for (int i = 0; i < threads - 1; ++i)
		thready[i].join();


}

void b_w(uint8_t* arrayTest, int start, int stop, int len)

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



void edge(uint8_t* img, int height, int width, int threads)
{
	int kernel_dim = 3;
	int n_of_channels = 4;
	int kernel_size = kernel_dim * kernel_dim;
	int half_kernel = (kernel_dim - 1) / 2;
	// creating destination matrix
	double* dest = new double[n_of_channels * width * height];
	for (int i = 0; i < n_of_channels * width * height; ++i) {
		dest[i] = 0;
	}
	// tworzenie kernela
	double* kernel = new double[kernel_size];
	double sum = 0;
	for (int i = 0; i < kernel_size; ++i) {
		kernel[i] = 0;
		if (i == 4) {
			kernel[i] = 0;
		}
		else if(i == 1 || i == 3){
			kernel[i] = 1;
		}
		sum += kernel[i];
	}

	// normalizacja
	for (int i = 0; i < kernel_size; ++i) {
		kernel[i] /= sum;
	}
	// applying filter
	for (int c = 0; c < n_of_channels; ++c) {
		for (int h = half_kernel; h < height - half_kernel; ++h) {
			for (int w = half_kernel; w < width - half_kernel; ++w) {
				for (int k_h = 0; k_h < kernel_dim; ++k_h) {
					for (int k_w = 0; k_w < kernel_dim; ++k_w) {
						dest[c + n_of_channels * (w + h * width)] += kernel[k_w + k_h * kernel_dim] * img[c + n_of_channels * ((w - half_kernel + k_w) + (h - half_kernel + k_h) * width)];
					}
				}
			}
		}
	}
	for (int i = 0; i < n_of_channels * width * height; ++i) {
		if (i % 4 == 3) {
			img[i] = 255;
			continue;
		}
		img[i] = (uint8_t)dest[i];
	}
}


void sepia(uint8_t* arrayTest, int len, int thread) {
	
	int alpha = 255;
	int red, green, blue;
	for (int i = 0; i < len; i += 4)
	{

		red = (.393 * arrayTest[i]) + (.769 * arrayTest[i + 1]) + (.189 * arrayTest[i + 2]);  //red

		green = (.349 * arrayTest[i]) + (.686 * arrayTest[i + 1]) + (.168 * arrayTest[i + 2]);//green

		blue = (.272 * arrayTest[i]) + (.534 * arrayTest[i + 1]) + (.131 * arrayTest[i + 2]);//blue
		arrayTest[i + 3] = alpha;
		if (red > 255)
		{
			arrayTest[i + 2] = 255;
		}
		else {
			arrayTest[i + 2] = (uint8_t)red;
		}
		if (green > 255)
		{
			arrayTest[i + 1] = 255;
		}
		else {
			arrayTest[i + 1] = (uint8_t)green;


		}
		if (blue > 255)
		{
			arrayTest[i + 0] = 255;
		}
		else
		{
			arrayTest[i + 0] = (uint8_t)blue;

		}
	}


}

void negative(uint8_t* arrayTest, int len, int thread) {
	
	int alpha = 255;
	for (int i = 0; i < len; i += 4) {

		
		arrayTest[i] = 255-arrayTest[i];
		arrayTest[i + 1] = 255 - arrayTest[i+1];
		arrayTest[i + 2] = 255 - arrayTest[i+2];
		arrayTest[i + 3] = alpha;

	}


}
