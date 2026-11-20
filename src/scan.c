#include <dirent.h>
#include <stdio.h>

#include "scan.h"

int scan_folder(const char *path) {
    DIR *dir = opendir(path);
    if (dir == NULL) {
        perror("opendir");
        return 1;
    }

    closedir(dir);
    return 0;
}
