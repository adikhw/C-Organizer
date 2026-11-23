CC      = gcc
CFLAGS  = -std=gnu11 -Wall -Wextra -g -fsanitize=address
SRC     = src/main.c src/scan.c src/category.c src/mover.c src/util.c
HDR     = $(wildcard src/*.h)
TARGET  = co

all: $(TARGET)

$(TARGET): $(SRC) $(HDR)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET)

clean:
	rm -f $(TARGET)

test: $(TARGET)
	bash tests/run_tests.sh

install: $(TARGET)
	install -Dm755 $(TARGET) $(HOME)/.local/bin/$(TARGET)

.PHONY: all clean test install
