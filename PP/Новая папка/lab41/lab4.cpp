#include "matrixOperations.h"
#include<windows.h>
#include<iostream>
#include "omp.h"
#include <cmath>   

#ifdef _DEBUG
#undef _DEBUG
#include <omp.h>
#define _DEBUG
#else
#include <omp.h>
#endif

using namespace std;

/*------------------------------------------------------------------

--

--              Parallel programming			     		--

--                   Laboratory work #4 OpenMP			--

--  Task: A = sort(e*Z+m*R(MO*MK))                               --

--                                                                  --

--  Author: Kobylynskiy Dmytro, group IP-31                         --

--  Date:06.04.2016                                                --

--                                                                  --

------------------------------------------------------------------ */

typedef int* vector;
typedef int** matrix;

int e,m;
int N,P,H;
vector A,R,Z;
matrix MO, MK;

void copySharedResources(int &copy_m, int &copy_e, matrix &copy_MO){
#pragma omp critical
	{
	copy_m = m;
	copy_MO = copyMatrix(MO, N);
	}
#pragma omp atomic
	copy_e += e;
}

void calculateEquation(int copy_d, int copy_e, matrix copy_MO, int startIndex, int endIndex){
	matrix Buf = multMatr(copy_MO, MK, startIndex, endIndex, N);
	vector BufVect1 = multVectMatr(R, Buf, startIndex, endIndex, N);
	addVectorsMultConstans(Z, BufVect1, A, copy_d, copy_e, startIndex, endIndex);
}


vector mergeParts(matrix vectorParts, vector vectorsSizes, int partsCount){
	cout << "vectorsSizes" << endl;

	if (partsCount == 1)
		return vectorParts[0];

	int vectorPairs = (int)ceil(partsCount / 2.0); //���������� ��� �������� (+ 1 ������ ��� ����, ���� �� ����)
	int fullIters = partsCount / 2;
	matrix currentParts = vectorParts;
	vector currentSizes = vectorsSizes;

	while (vectorPairs > 1){
		
		matrix nextIteration = new vector[vectorPairs];
		vector nextIterationSizes = new int[vectorPairs];
		cout << "parts count: " << partsCount << endl;
		cout << "fullIters: " << fullIters << endl;
		cout << "vectorPairs: " << vectorPairs << endl;
		cout << "currentThread: " << omp_get_thread_num() << endl;

		omp_set_num_threads(fullIters);
		#pragma omp parallel for 
		for (int i = 0; i < fullIters; i++){
			int left = 2 * i;
			int right = 2 * i + 1;
			cout << omp_get_thread_num() << " doing " << i << " iteration"<<endl;
			nextIteration[i] = mergeVectors(currentParts[left], currentParts[right], currentSizes[left], currentSizes[right]);
			nextIterationSizes[i] = currentSizes[left] + currentSizes[right];
		}
		if (fullIters < vectorPairs){
			nextIteration[fullIters] = currentParts[partsCount - 1];
			nextIterationSizes[fullIters] = currentSizes[partsCount - 1];
		}
		currentParts = nextIteration;
		currentSizes = nextIterationSizes;
		vectorPairs = (int)ceil(vectorPairs / 2.0);
		fullIters = vectorPairs / 2;
	}
	return mergeVectors(currentParts[0], currentParts[1], currentSizes[0], currentSizes[1]);
}

void task(){
	matrix sortedVectors = new vector[P];
	vector sortedVectorsSizes = new int[P];
	omp_set_num_threads(P);
	
	#pragma omp parallel
	{
		int tID = omp_get_thread_num();

		#pragma omp critical 
			cout << "Task " << tID << " started" << endl;

		switch(tID){

			case 0:
				MK = generateMatrix(N);
				m = generateConstant();
				break;

			case 1: 
				break;

			case 2:
				A = generateVector(N);
				Z = generateVector(N);
				R = generateVector(N);
				break;

			case 3:
				e = generateConstant();
				MO = generateMatrix(N);
				break;
		}

		#pragma omp barrier

		int m_i, e_i = 0;
		matrix MO_i = NULL;

		copySharedResources(m_i, e_i, MO_i);

		int endIndex = -1;
		int startIndex = -1;
		
		
		#pragma omp for private(startIndex, endIndex) 
			for (int i = 0; i < P; i++){

				startIndex = i*H;
				endIndex = (i == P - 1) ? N : (i + 1)*H;

				#pragma omp critical
				cout << tID << " startIndex = " << startIndex << ", endIndex = " << endIndex << endl;
				sortedVectorsSizes[i] = endIndex - startIndex;
				calculateEquation(m_i, e_i, MO_i, startIndex, endIndex); 
				sortedVectors[i] = copyVector(A, startIndex, endIndex);
				sortVector(sortedVectors[i], endIndex - startIndex);
			}
		}
		A = mergeParts(sortedVectors, sortedVectorsSizes, P);
		if (N <= 8)
			if (A[3]>A[1]){
				A[N - 1] = A[3];
				for (int i = 0; i < N - 1; i++)
					A[i] = A[1];
			}
			else{
				for (int i = 0; i < N; i++)
					A[i] = A[1];
			}
			printVector(A, N);
}

int main(int argc, char const *argv[])
{
	cout << "Lab4 started" << endl;
	cout << "input N" << endl;
    cin >> N;
    cout << "input P" << endl;
    cin >> P;
    H = N / P;
	A = new int[N];

	R = NULL;
	Z = NULL;
	MO = NULL;
	MK = NULL;

	task();
	cout << "Lab4 finished" << endl;
	system("pause");
	return 0;
}