#include <iostream>
using namespace std;

#define MAX 1000

class Queue {
public:
	int front, rear, size;
	unsigned capacity;
	int* array;
};

Queue* createQueue(unsigned capacity)
{
	Queue* queue = new Queue();
	queue->capacity = capacity;
	queue->front = queue->size = 0;

	// This is important, see the enqueue
	queue->rear = capacity - 1;
	queue->array = new int[queue->capacity];
	return queue;
}

int main()
{
//	Queue* queue = createQueue(1000);
	char input[] = "hell";
	char dest[] = "dell";

	for (int i = 0; i < strlen(input); ++i)
	{
		for (char c = 'a'; c <= 'z'; ++c)
		{
			input[i] = c;
			cout << input << " ";

		}
	}

	return 0;
}