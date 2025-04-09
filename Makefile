NAME = libasm.a
ASM = nasm
ASMFLAGS = -f elf64
CC = cc
CFLAGS = -Wall -Wextra -Werror -g3

SRC = ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s ft_strdup.s
OBJ = $(SRC:.s=.o)

BONUS_SRC = ft_atoi_base.s
BONUS_OBJ = $(BONUS_SRC:.s=.o)

.PHONY: all bonus clean fclean re test

all: $(NAME)

$(NAME): $(OBJ)
	@ar rcs $(NAME) $(OBJ)
	@echo "Library $(NAME) created."

%.o: %.s
	$(ASM) $(ASMFLAGS) -o $@ $<

bonus: $(BONUS_OBJ)
	@ar rcs $(NAME) $(BONUS_OBJ)
	@echo "Bonus functions added to $(NAME)."

clean:
	@rm -f $(OBJ) $(BONUS_OBJ) main.o
	@echo "Cleaned object files."

fclean: clean
	@rm -f $(NAME) main
	@echo "Removed library and executable."

re: fclean all

test: $(NAME) main.c
	$(CC) $(CFLAGS) -no-pie -o main main.c $(NAME)
	@echo "Test executable 'main' built."
