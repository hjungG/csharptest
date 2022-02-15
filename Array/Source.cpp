#include <iostream>

using namespace std;

void leftRotateOne(int arr[], int n)
{
	int temp = arr[0], i;
	for (i = 0; i < n - 1; ++i)
	{
		arr[i] = arr[i + 1];
	}
	arr[n - 1] = temp;
}

void reverseArray(int arr[], int start, int end)
{
	while (start < end)
	{
		int temp = arr[start];
		arr[start] = arr[end];
		arr[end] = temp;
		start++;
		end--;
	}
}

void leftRotate(int arr[], int d, int n)
{
	if (d == 0)
		return;
	// in case the rotating factor is
	// greater than array length
	d = d % n;

	reverseArray(arr, 0, d - 1);
	reverseArray(arr, d, n - 1);
	reverseArray(arr, 0, n - 1);
}


void printArray(int arr[], int n)
{
	for (int i = 0; i < n; ++i)
	{
		cout << arr[i] << " ";
	}
}

// 12 34567
// 21 76543
// 3456712 

int main()
{
	int arr[] = { 1, 2, 3, 4, 5, 6, 7 };
	int n = sizeof(arr) / sizeof(arr[0]);
	int d = 2;

	// Function calling
	leftRotate(arr, d, n);
	printArray(arr, n);

	return 0;
}

//{1, 2, 3, 4, 5, 6, 7,  8, 9, 10, 11, 12}
//{4  2  3  7  5  6  10  8  9   1  11  12}
//{4  5  3  7  8  6  10 11  9   1   2  12}