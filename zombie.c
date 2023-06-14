#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main() {
    pid_t child_pid = fork();

    if (child_pid > 0) {
        // Parent process
        sleep(10);  // Sleep for a while to allow the child process to become a zombie
    } else if (child_pid == 0) {
        // Child process
        exit(0);  // Child process exits immediately, becoming a zombie
    }

    return 0;
}
