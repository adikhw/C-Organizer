#include "mover.h"

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <sys/stat.h>
#include <unistd.h>

#include "util.h"

static int ensure_dir_exists(const char *path) {
  if (mkdir(path, 0755) == 0) {
    return 0;
  }

  if (errno != EEXIST) {
    perror("mkdir");
    return 1;
  }

  struct stat st;
  if (stat(path, &st) != 0 || !S_ISDIR(st.st_mode)) {
    fprintf(stderr, "%s already exists but is not a directory\n", path);
    return 1;
  }

  return 0;
}

int move_file(const char *base_path, const char *name, const char *category,
              int verbose) {
  char target_dir[PATH_MAX];
  char old_path[PATH_MAX];
  char new_path[PATH_MAX];

  if (join_path(target_dir, sizeof(target_dir), base_path, category) != 0) {
    fprintf(stderr, "path too long, skipped: %s/%s\n", base_path, category);
    return 1;
  }
  if (ensure_dir_exists(target_dir) != 0) {
    return 1;
  }

  if (join_path(old_path, sizeof(old_path), base_path, name) != 0) {
    fprintf(stderr, "path too long, skipped: %s/%s\n", base_path, name);
    return 1;
  }

  if (join_path(new_path, sizeof(new_path), target_dir, name) != 0) {
    fprintf(stderr, "path too long, skipped: %s/%s\n", target_dir, name);
    return 1;
  }

  if (access(new_path, F_OK) == 0) {
    printf("SKIP: %s already exists in %s\n", name, category);
    return 0;
  }

  if (rename(old_path, new_path) != 0) {
    perror("rename");
    return 1;
  }

  if (verbose) {
    printf("moving %s -> %s/%s\n", name, category, name);
  }

  return 0;
}
