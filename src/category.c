#include "category.h"

#include <string.h>
#include <strings.h>

typedef struct {
    const char *ext;
    const char *category;
} Rule;

static const Rule rules[] = {
    {"jpg", "Images"},
    {"jpeg", "Images"},
    {"png", "Images"},
    {"gif", "Images"},
    {"pdf", "Documents"},
    {"docx", "Documents"},
    {"txt", "Documents"},
    {"mp4", "Videos"},
    {"mkv", "Videos"},
    {"mp3", "Audio"},
    {"zip", "Archives"},
    {"tar", "Archives"},
    {"gz", "Archives"},
    {"c", "Code"},
    {"py", "Code"},
    
};

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

const char *search_category(const char *ext) {
    for (size_t i = 0; i < sizeof(rules) / sizeof(rules[0]); i++) {
        if (strcasecmp(ext, rules[i].ext) == 0) {
            return rules[i].category;
        }
    }
    return "Other";
}