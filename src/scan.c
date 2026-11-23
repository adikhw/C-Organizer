#include <dirent.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

#include "category.h"
#include "mover.h"
#include "scan.h"
#include "util.h"

int scan_folder(const char *path, int dry_run, int verbose) {
  DIR *dir = opendir(path);
  if (dir == NULL) {
    perror("opendir");
    return 1;
  }

  int had_error = 0;

  while (1) {
    struct dirent *entry = readdir(dir);
    if (entry == NULL) {
      break;
    }

    if (entry->d_name[0] == '.') {
      continue;
    }

    char full_path[PATH_MAX];
    if (join_path(full_path, sizeof(full_path), path, entry->d_name) != 0) {
      fprintf(stderr, "path too long, skipped: %s/%s\n", path, entry->d_name);
      continue;
    }

    struct stat st;
    if (stat(full_path, &st) != 0) {
      perror("stat");
      continue;
    }

    if (!S_ISREG(st.st_mode)) {
      continue;
    }

    const char *ext = take_extension(entry->d_name);
    const char *category = search_category(ext);

    if (dry_run) {
      printf("[DRY-RUN] %s -> %s/%s\n", entry->d_name, category, entry->d_name);
    } else if (move_file(path, entry->d_name, category, verbose) != 0) {
      had_error = 1;
    }
  }

  closedir(dir);

  return had_error ? 1 : 0;
}
