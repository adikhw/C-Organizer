#include "category.h"

#include <string.h>

const char *take_extension(const char *file_name) {
    if (file_name == NULL) {
        return "";
    }

    const char *dot = strrchr(file_name, '.');
    if (dot == NULL || dot == file_name) {
        return "";
    }
    return dot + 1;
}