OBJ     := mask

CC      := cc
CCFLAG  := -O2 -Wall -Wextra -Wpedantic

.PHONY: default
default: $(OBJ)

.PHONY: clean
clean:
	rm -f -r $(OBJ)

%: %.c
	$(CC) $(CCFLAG) -s -o $@ $<
