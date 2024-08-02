#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void sanitize_file_name(char *file_name) {
    if (!file_name) {
        fprintf(stderr, "Error: file_name is NULL\n");
        return;
    }

    size_t len = strlen(file_name);
    if (len > 255) {
        fprintf(stderr, "Error: file_name is too long\n");
        return;
    }

    char *dot = strrchr(file_name, '.');
    size_t name_len = dot ? (size_t)(dot - file_name) : len;
    
    int underscore_count = 0;
    size_t j = 0;

    for (size_t i = 0; i < name_len; i++) {
        if (isalnum((unsigned char)file_name[i])) {
            file_name[j++] = file_name[i];
            underscore_count = 0;
        } else if (underscore_count < 2) {
            file_name[j++] = '_';
            underscore_count++;
        }
    }

    if (dot) {
        strcpy(file_name + j, dot);
    } else {
        file_name[j] = '\0';
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
        return 1;
    }
    char new_file_name[256];
    char *input = argv[1];
    char *file_name = strrchr(input, '/');
    if (file_name) {
        file_name++;
    } else {
        file_name = input;
    }
    strcpy(new_file_name, file_name);
    sanitize_file_name(new_file_name);
    if (rename(input, new_file_name) == 0) {
        printf("File renamed to: %s\n", new_file_name);
    } else {
        perror("Error renaming file");
    }
    return 0;
}
