/* main.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

size_t   ft_strlen(const char *s);
char    *ft_strcpy(char *dst, const char *src);
int      ft_strcmp(const char *s1, const char *s2);
ssize_t  ft_write(int fd, const void *buf, size_t count);
ssize_t  ft_read(int fd, void *buf, size_t count);
char    *ft_strdup(const char *s);

int main(void)
{
    char    buffer[128];
    int     ret_cmp;

    /* Test ft_strlen */
    const char *test_str = "Hello, world!";
    printf("ft_strlen: %zu\n", ft_strlen(test_str));
    printf("strlen   : %zu\n", strlen(test_str));

    /* Test ft_strcpy */
    char dest[100];
    ft_strcpy(dest, "Copy this string!");
    printf("ft_strcpy: %s\n", dest);

    /* Test ft_strcmp */
    ret_cmp = ft_strcmp("", "");
    printf("ft_strcmp (\"\", \"\"): %d\n", ret_cmp);
    ret_cmp = ft_strcmp("Tripouille", "Tripouille");
    printf("ft_strcmp (\"Tripouille\", \"Tripouille\"): %d\n", ret_cmp);
    ret_cmp = ft_strcmp("Tripouille", "tripouille");
    printf("ft_strcmp (\"Tripouille\", \"tripouille\"): %d\n", ret_cmp);
    printf("ft_strcmp (\"Tripouille\", \"tripouille\"): %d\n", strcmp("Tripouille", "tripouille"));

    /* Test ft_write */
    ssize_t written = ft_write(1, "Hello from ft_write\n", 22);
    printf("ft_write returned: %zd\n", written);

    /* Test ft_read.
       Type some text then press Ctrl+D (EOF) */
    printf("Type something for ft_read: ");
    ssize_t read_bytes = ft_read(0, buffer, 127);
    if (read_bytes >= 0)
    {
        buffer[read_bytes] = '\0';
        printf("ft_read read: %s\n", buffer);
    }
    else
        perror("ft_read error");

    /* Test ft_strdup */
    char *dup = ft_strdup("Duplicate me!");
    if (dup)
    {
        printf("ft_strdup: %s\n", dup);
        free(dup);
    }
    else
        printf("ft_strdup returned NULL\n");

    return 0;
}
