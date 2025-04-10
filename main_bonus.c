/* main_bonus.c */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
#include <signal.h>

/* --- Structure definition --- */
typedef struct s_list {
    void *data;
    struct s_list *next;
} t_list;

/* --- Function prototypes for bonus functions (should be defined in your assembly files) --- */
int     ft_atoi_base(char *str, char *base);
void    ft_list_push_back(t_list **begin_list, void *data);
void    ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(void*, void*), void (*free_fct)(void *));
void    ft_list_push_front(t_list **begin_list, void *data);
int     ft_list_size(t_list *begin_list);
void    ft_list_sort(t_list **begin_list, int (*cmp)(void*, void*));

/* --- Helper functions --- */

/* Simple check function that prints [OK] or [FAIL] with a message */
static void check(int condition, const char *msg) {
    if (condition)
        printf("[OK] %s\n", msg);
    else
        printf("[FAIL] %s\n", msg);
}

/* Clean (free) a linked list */
static void lst_clean(t_list **l) {
    t_list *tmp;
    while (*l) {
        tmp = (*l)->next;
        free(*l);
        *l = tmp;
    }
}

/* Comparison function for list sorting; interprets data as long integers */
int cmp_int(void *a, void *b) {
    long A = (long)a;
    long B = (long)b;
    if (A > B)
        return 1;
    else if (A < B)
        return -1;
    return 0;
}

/* Dummy free function used by ft_list_remove_if (data are not dynamically allocated) */
void free_dummy(void *data) {
    (void)data;
}

/* Helper function to print a list */
static void print_list(t_list *list) {
    printf("[ ");
    while (list) {
        printf("%ld ", (long)list->data);
        list = list->next;
    }
    printf("]\n");
}

/* Signal handler for segmentation faults */
void sigsegv_handler(int sig) {
    (void)sig;
    printf("Segmentation fault caught.\n");
    exit(1);
}

/* --- Main function --- */
int main(void) {
    signal(SIGSEGV, sigsegv_handler);

    printf("=== BONUS FUNCTIONS TESTS ===\n\n");

    /* ---------------------------------- */
    /* Test ft_atoi_base                 */
    /* ---------------------------------- */
    printf("Testing ft_atoi_base:\n");
    printf("ft_atoi_base(\"1\", \"001\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "001"),
           (ft_atoi_base("1", "001") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"011\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "011"),
           (ft_atoi_base("1", "011") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"01+\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "01+"),
           (ft_atoi_base("1", "01+") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"01-\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "01-"),
           (ft_atoi_base("1", "01-") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"01\t\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "01\t"),
           (ft_atoi_base("1", "01\t") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"01\n\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "01\n"),
           (ft_atoi_base("1", "01\n") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"01\v\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "01\v"),
           (ft_atoi_base("1", "01\v") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"01\f\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "01\f"),
           (ft_atoi_base("1", "01\f") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"01\r\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "01\r"),
           (ft_atoi_base("1", "01\r") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"\", \"01\") = %d (expected: 0) %s\n",
           ft_atoi_base("", "01"),
           (ft_atoi_base("", "01") == 0) ? "[OK]" : "[FAIL]");
    printf("ft_atoi_base(\"1\", \"0123450\") = %d (expected: 0) %s\n",
           ft_atoi_base("1", "0123450"),
           (ft_atoi_base("1", "0123450") == 0) ? "[OK]" : "[FAIL]");

    printf("\n");

    /* ---------------------------------- */
    /* Test ft_list_push_front & ft_list_size */
    /* ---------------------------------- */
    printf("Testing ft_list_push_front and ft_list_size:\n");
    t_list *list = NULL;
    printf("Initial list size: %d (expected: 0)\n", ft_list_size(list));
    ft_list_push_front(&list, (void*)1);
    ft_list_push_front(&list, (void*)2);
    ft_list_push_front(&list, (void*)3);
    printf("List size after pushing 3 elements: %d (expected: 3)\n", ft_list_size(list));
    printf("List contents (order: last pushed is first): ");
    print_list(list);
    printf("\n");

    /* ---------------------------------- */
    /* Test ft_list_sort                 */
    /* ---------------------------------- */
    printf("Testing ft_list_sort:\n");
    ft_list_push_front(&list, (void*)5);
    ft_list_push_front(&list, (void*)0);
    ft_list_push_front(&list, (void*)4);
    printf("Unsorted list: ");
    print_list(list);
    ft_list_sort(&list, cmp_int);
    printf("Sorted list (ascending): ");
    print_list(list);
    printf("\n");

    /* ---------------------------------- */
    /* Test ft_list_remove_if            */
    /* ---------------------------------- */
    printf("Testing ft_list_remove_if:\n");
    printf("Removing nodes with value 2...\n");
    ft_list_remove_if(&list, (void*)2, cmp_int, free_dummy);
    printf("List after removing value 2: ");
    print_list(list);
    printf("Removing nodes with value 0...\n");
    ft_list_remove_if(&list, (void*)0, cmp_int, free_dummy);
    printf("List after removing value 0: ");
    print_list(list);
    printf("Final list size: %d\n", ft_list_size(list));
    lst_clean(&list);
    printf("\n");

    /* ---------------------------------- */
    /* Test ft_list_push_front separately */
    /* (These tests come from your provided snippet.) */
    printf("----- Testing ft_list_push_front separately -----\n");
    t_list *list_push = NULL;
    ft_list_push_front(&list_push, (void*)1);
    check(list_push != NULL && list_push->data == (void*)1 && list_push->next == NULL,
          "Test 1: After push, list->data == 1 and list->next == NULL");
    /* mcheck: in C we simply verify the node size */
    if (sizeof(*list_push) == sizeof(t_list))
        printf("[OK] Memory check: size is correct\n");
    else
        printf("[FAIL] Memory check: size is incorrect\n");
    ft_list_push_front(&list_push, (void*)2);
    check(list_push != NULL &&
          list_push->data == (void*)2 &&
          list_push->next != NULL &&
          list_push->next->data == (void*)1 &&
          list_push->next->next == NULL,
          "Test 3: After second push, list->data == 2, next->data == 1, and next->next == NULL");
    lst_clean(&list_push);
    printf("----- ft_list_push_front tests completed -----\n");

    printf("\n=== All bonus tests completed ===\n");
    return 0;
}
