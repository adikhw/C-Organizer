CC      = gcc
CFLAGS  = -std=gnu11 -Wall -Wextra -g -fsanitize=address
SRC     = src/main.c src/scan.c
HDR     = $(wildcard src/*.h)
TARGET  = co

all: $(TARGET)

$(TARGET): $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: all clean
