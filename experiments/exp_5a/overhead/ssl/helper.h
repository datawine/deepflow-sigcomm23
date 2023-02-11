#ifndef HELPER_H
#define HELPER_H

typedef unsigned long long ticks;

/* x86架构直接获取 cpu 的时钟周期数更精确,可以替换为其他统计方式 */
static __inline__ ticks getticks(void)
{
     unsigned a, d;
     asm("cpuid");
     asm volatile("rdtsc" : "=a" (a), "=d" (d));

     return (((ticks)a) | (((ticks)d) << 32));
}

/* 对于小块的数据,加解密本身执行的速度过快,要测量影响可以扩大内存 */
#define BUFFER_SIZE (1024)
#define SERVER_ADDR "127.0.0.1"
#define SERVER_PORT 2357

#endif