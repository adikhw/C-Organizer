#include <dirent.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

#include "category.h"
#include "scan.h"

int scan_folder(const char *path) {
  DIR *dir = opendir(path);
  if (dir == NULL) {
    perror("opendir");
    return 1;
  }
  while (1) {
    struct dirent *entry = readdir(dir);
    if (entry == NULL) {
      break;
    }

    if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
      continue;
    }

    char full_path[PATH_MAX];
    snprintf(full_path, sizeof(full_path), "%s/%s", path, entry->d_name);

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
    printf("%s / %s / %s\n", entry->d_name, ext, category);
  }

  closedir(dir);
  return 0;
}
