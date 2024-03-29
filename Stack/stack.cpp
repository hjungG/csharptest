#include <iostream>
using namespace std;

#define MAX 1000

class Stack {
	int top;
public:
	int a[MAX];  // maximum size of stack

	Stack() { top = -1; }
	bool push(int x);
	int pop();
	int peek();
	bool isEmpty();
};

bool Stack::push(int x)
{
	if (top >= (MAX - 1)) {
		cout << "Stack Overflow";
		return false;		
	}
	else {
		a[++top] = x;
		cout << x << "pushed into Stack\n";
		return true;
	}
}

int Stack::pop()
{
	if (top < 0)
	{
		cout << "Stack underflow";
		return 0;
	}
	else {
		int x = a[top--];
		return x;
	}
}

int Stack::peek()
{
	if (top < 0)
	{
		cout << "Stack is Empty";
		return 0;
	}
	else {
		int x = a[top];
		return x;
	}
}

bool Stack::isEmpty()
{
	return (top < 0);
}

int main()
{
	class Stack s;
	s.push(10);
	s.push(1);
	s.push(3);
	s.push(5);

	while (!s.isEmpty())
	{
		cout << s.peek() << " ";
		s.pop();
	}

	return 0;
}