#include <stdio.h>
#include <stdlib.h>


typedef struct Process {
    int pid;
    int arrival_time;
    int burst_time;
    int completion_time;
    int waiting_time;
    int turnaround_time;
} Process;


void swap(Process *a, Process *b) {
    Process temp = *a;
    *a = *b;
    *b = temp;
}


void sort_processes(Process *processes, int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = i + 1; j < n; j++) {
            if (processes[i].arrival_time > processes[j].arrival_time) {
                swap(&processes[i], &processes[j]);
            }
        }
    }
}


void fcfs_scheduling(Process *processes, int n) {
    int current_time = 0;
    for (int i = 0; i < n; i++) {
        if (current_time < processes[i].arrival_time) {
            current_time = processes[i].arrival_time;
        }

        processes[i].completion_time = current_time + processes[i].burst_time;
        processes[i].turnaround_time = processes[i].completion_time - processes[i].arrival_time;
        processes[i].waiting_time = processes[i].turnaround_time - processes[i].burst_time;

        current_time += processes[i].burst_time;
    }
}

void print_process_info(Process *processes, int n) {
    printf("PID\tArrival Time\tBurst Time\tCompletion Time\tTurnaround Time\tWaiting Time\n");
    for (int i = 0; i < n; i++) {
        printf("%d\t%d\t\t%d\t\t%d\t\t%d\t\t%d\n", 
            processes[i].pid,
            processes[i].arrival_time, 
            processes[i].burst_time,
            processes[i].completion_time, 
            processes[i].turnaround_time,
            processes[i].waiting_time
            );
    }
}




int main() {
    int n;
    printf("Enter the number of processes: ");
    scanf("%d", &n);

    Process processes[n];
    for (int i = 0; i < n; i++) {
        printf("Enter the arrival time and burst time for process %d: ", i + 1);
        scanf("%d %d", &processes[i].arrival_time, &processes[i].burst_time);
        processes[i].pid = i + 1;
    }

    sort_processes(processes, n);
    fcfs_scheduling(processes, n);
    print_process_info(processes, n);

    return 0;

}