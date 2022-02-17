// simple linked list

#include <iostream>
using namespace std;

/* Linked list node */
class Node {
public:
	int data;
	Node* next;
};

void printList(Node* node)
{
	struct Node* head = node;

	while (node->next != head)
	{
		cout << node->data << " ";
		node = node->next;
	}
}

void push(Node** head, int data)
{
	Node* newNode = new Node();
	newNode->data = data;

	newNode->next = (*head);
	(*head) = newNode;
}

// 1, 2, 3  4 -> 1
void deleteNode(Node** head, int k)
{
	if (*head == NULL)
		return;
	// single node
	if ((*head)->data == k && (*head)->next == *head)
	{
		free(head);
		(*head) = NULL;
		return;
	}

	Node *last = *head, * d;

	// head node
	if((*head)->data == k)
	{
		while (last->next != *head)
		{
			last = last->next;
		}

		last->next = (*head)->next;
		free(*head);
		*head = last->next;
		return;
	}

// Either the node to be deleted is not found
// or the end of list is not reached
	while (last->next != *head && last->next->data != k)
	{
		last = last->next;
	}

	// in case found
	if (last->next->data == k)
	{
		d = last->next;
		last->next = d->next;
		free(d);
	}
	else
	{
		cout << "key not found" << endl;
	}

	return;
}

// 1, 2, 3  -> 2
void deleteNodePos(Node** n, int k)
{
	Node* temp = *n;
	Node* prev = NULL;
	int i = 0;

	if (temp != NULL && k == 0)
	{
		*n = temp->next;
		delete temp;
		return;
	}

	i = k;
	while (temp != NULL)
	{
		prev = temp;     // prev=1, temp=2
		temp = temp->next;
		i++;
		if (temp != NULL && i == k)
		{
			prev->next = temp->next;
		}
	}
	delete temp;

	return;
}

struct Node* circular(struct Node* head)
{
	struct Node* start = head;

	while (head->next != NULL)
	{
		head = head->next;
	}

	head->next = start;
	return start;
}


int main()
{
	// start with empty list
	Node* head = NULL;

	push(&head, 7);
	push(&head, 1);
	push(&head, 3);
	push(&head, 2);

	printList(head); cout << endl;

//	head = circular(head);

	deleteNode(&head, 3);
	//	insertAfter(second, 4);
	//	insertAfter(head, 5);
	//	deleteNodePos(&head, 1);
	//	deleteNode(&head, 7);

	printList(head); cout << endl;

	return 0;
}

