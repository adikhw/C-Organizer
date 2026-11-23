#include "util.h"

#include <stdio.h>

int join_path(char *buffer, size_t buffer_size, const char *part_a,
              const char *part_b) {
  int n = snprintf(buffer, buffer_size, "%s/%s", part_a, part_b);
  if (n < 0 || (size_t)n >= buffer_size) {
    return 1;
  }
  return 0;
}
