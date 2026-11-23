#ifndef UTIL_H
#define UTIL_H

#include <stddef.h>

int join_path(char *buffer, size_t buffer_size, const char *part_a,
              const char *part_b);

#endif
