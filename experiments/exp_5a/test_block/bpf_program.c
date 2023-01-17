#include <linux/bpf.h>
#include <unistd.h>
#include <time.h>
#define SEC(NAME) __attribute__((section(NAME), used))

static int (*bpf_trace_printk)(const char *fmt, int fmt_size,
                               ...) = (void *)BPF_FUNC_trace_printk;

SEC("tracepoint/syscalls/sys_enter_write")
int bpf_prog(void *ctx) {
    char msg[] = "Hello, BPF World!";
    int temp=1;
    for(int i=0; i<10000; i++){
        temp *= 2;
        if(temp > 666666) temp = temp - 123456;
        if(temp > 10000){
            temp = 0;
            msg[0] = msg[0]=='H'?'h':'H';
        }
    }
    bpf_trace_printk(msg, sizeof(msg));
    return 0;
}

char _license[] SEC("license") = "GPL";