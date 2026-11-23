#include "mover.h"

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <sys/stat.h>

static int ensure_dir_exists(const char *path) {
  if (mkdir(path, 0755) == 0) {
    return 0;
  }

  if (errno != EEXIST) {
    perror("mkdir");
    return 1;
  }

  return 0;
}

int move_file(const char *base_path, const char *name, const char *category) {
  char target_dir[PATH_MAX];
  char old_path[PATH_MAX];
  char new_path[PATH_MAX];
  int n;

  n = snprintf(target_dir, sizeof(target_dir), "%s/%s", base_path, category);
  if (n < 0 || (size_t)n >= sizeof(target_dir)) {
    fprintf(stderr, "path too long, skipped: %s/%s\n", base_path, category);
    return 1;
  }
  if (ensure_dir_exists(target_dir) != 0) {
    return 1;
  }

  n = snprintf(old_path, sizeof(old_path), "%s/%s", base_path, name);
  if (n < 0 || (size_t)n >= sizeof(old_path)) {
    fprintf(stderr, "path too long, skipped: %s/%s\n", base_path, name);
    return 1;
  }

  n = snprintf(new_path, sizeof(new_path), "%s/%s", target_dir, name);
  if (n < 0 || (size_t)n >= sizeof(new_path)) {
    fprintf(stderr, "path too long, skipped: %s/%s\n", target_dir, name);
    return 1;
  }

  if (rename(old_path, new_path) != 0) {
    perror("rename");
    return 1;
  }

  return 0;
}
