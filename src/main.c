#include <stdio.h>

#include "scan.h"


int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: co <folder>\n");
        return 1; 
    }
const char *path = argv[1];
if (scan_folder(path) != 0 ) {
    return 1;
}
    return 0;
}