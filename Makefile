# Makefile

NAME = libasm.a
ASM = nasm
ASMFLAGS = -f elf64
CC = gcc
CFLAGS = -Wall -Wextra -Werror -g3

# Assembly source files for mandatory functions
SRC = ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s ft_strdup.s
OBJ = $(SRC:.s=.o)

# Optional bonus files (must be in separate file _bonus.s)
BONUS_SRC = _bonus.s
BONUS_OBJ = $(_bonus.s:.s=.o)

.PHONY: all bonus clean fclean re test

all: $(NAME)

$(NAME): $(OBJ)
	@ar rcs $(NAME) $(OBJ)
	@echo "Library $(NAME) created."

%.o: %.s
	$(ASM) $(ASMFLAGS) -o $@ $<

bonus:
	$(ASM) $(ASMFLAGS) -o _bonus.o _bonus.s
	@ar rcs $(NAME) _bonus.o
	@echo "Bonus functions added to $(NAME)."

clean:
	@rm -f $(OBJ) _bonus.o main.o
	@echo "Cleaned object files."

fclean: clean
	@rm -f $(NAME) main
	@echo "Removed library and executable."

re: fclean all

test: $(NAME) main.c
	$(CC) $(CFLAGS) -no-pie -o main main.c $(NAME)
	@echo "Test executable 'main' built."
