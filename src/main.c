#include <stdio.h>
#include <string.h>

#include "scan.h"

static void print_usage(void) {
  fprintf(stderr, "Usage: co [--dry-run] [--verbose] <folder>\n");
}

int main(int argc, char *argv[]) {
  int dry_run = 0;
  int verbose = 0;
  const char *path = NULL;

  for (int i = 1; i < argc; i++) {
    const char *arg = argv[i];

    if (strcmp(arg, "--dry-run") == 0) {
      dry_run = 1;
    } else if (strcmp(arg, "--verbose") == 0) {
      verbose = 1;
    } else if (arg[0] == '-') {
      fprintf(stderr, "Unknown option: %s\n", arg);
      print_usage();
      return 1;
    } else {
      path = arg;
    }
  }

  if (path == NULL) {
    print_usage();
    return 1;
  }

  if (scan_folder(path, dry_run, verbose) != 0) {
    return 1;
  }

  return 0;
}
