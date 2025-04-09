NAME = libasm.a

ASM = nasm
ASMFLAGS = -f elf64
CC = cc
CFLAGS = -Wall -Wextra -Werror -g3

SRC = ft_strlen.s ft_strcpy.s ft_strcmp.s ft_write.s ft_read.s ft_strdup.s
BONUS_SRC = ft_atoi_base.s ft_list_push_front.s ft_list_size.s ft_list_sort.s ft_list_remove_if.s

OBJ_DIR = obj

OBJ = $(SRC:%.s=$(OBJ_DIR)/%.o)
BONUS_OBJ = $(BONUS_SRC:%.s=$(OBJ_DIR)/%.o)

C_SRC = main.c
C_OBJ = $(C_SRC:%.c=$(OBJ_DIR)/%.o)

.PHONY: all bonus clean fclean re test bonus_test

all: $(NAME)

$(NAME): $(OBJ)
	@ar rcs $(NAME) $(OBJ)
	@echo "Library $(NAME) created."

$(OBJ_DIR):
	@mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: %.s | $(OBJ_DIR)
	$(ASM) $(ASMFLAGS) -o $@ $<

$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

bonus: $(BONUS_OBJ)
	@ar rcs $(NAME) $(BONUS_OBJ)
	@echo "Bonus functions added to $(NAME)."

clean:
	@rm -rf $(OBJ_DIR)
	@rm -f main.o
	@echo "Cleaned object and dependency files."

fclean: clean
	@rm -f $(NAME) main main_bonus
	@echo "Removed library and executable."

re: fclean all

test: $(NAME) $(C_OBJ)
	$(CC) $(CFLAGS) -o main $(C_OBJ) $(NAME)
	@echo "Test executable 'main' built."

bonus_test: bonus main_bonus.c
	$(CC) $(CFLAGS) -o main_bonus main_bonus.c $(NAME)
	./main_bonus

-include $(C_OBJ:.o=.d)
