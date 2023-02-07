## 使用方法

**把ebpf程序注入内核**

```bash
bash start_ebpf.sh
```



**运行书上的那行代码并测量所需时间**（20次取平均值）

```bash
bash dd.sh
```



**反复调用某一syscall并测量所需时间**（重复调用10^5次，20次取平均值）

```bash
bash run.sh <syscall>
```

\<syscall\> = write | read | sendto | recvfrom | sendmsg | sendmmsg | recvmsg | recvmmsg |writev | readv | empty | ssl_write | ssl_read |ssl | empty



**检验可执行文件调用了哪些syscall、调用了多少次**

```bash
cd bin
strace -c ./<filename>
```

先编译出可执行文件再用strace



| 序号 | command   | time(no ebpf)  | time(with ebpf) | time overhead(per command) |
| ---- | --------- | -------------- | --------------- | -------------------------- |
| 1    | write     | 116 ms         | 185 ms          | 690 ns                     |
| 2    | read      | 127 ms         | 244 ms          | 1170 ns                    |
| 3    | sendto    | 73 ms          | 176 ms          | 1030 ns                    |
| 4    | recvfrom  | 74 ms          | 222 ms          | 1480 ns                    |
| 5    | sendmsg   | 73 ms          | 119 ms          | 460 ns                     |
| 6    | sendmmsg  | 73 ms          | 119 ms          | 460 ns                     |
| 7    | recvmsg   | 72 ms          | 119 ms          | 470 ns                     |
| 8    | recvmmsg  | 72 ms          | 113 ms          | 410 ns                     |
| 9    | writev    | 79 ms          | 171 ms          | 920 ns                     |
| 10   | readv     | 83 ms          | 219 ms          | 1360 ns                    |
| 11   | ssl_write | 0.22-0.23 ms   | 0.241-0.26 ms   | -                          |
| 12   | ssl_read  | 0.061-0.065 ms | 0.062-0.065 ms  | -                          |
| 13   | ssl       | 0.53-0.57 ms   | 0.53-0.58 ms    | -                          |
| 14   | None      | 0.285 ms       | 0.285 ms        | 0                          |



**复现书上的实验数据**

命令：

```bash
time dd if=/dev/zero of=/dev/null bs=1 count=100k
```



| command                                                      | purpose           | time    | cost-per-command |
| ------------------------------------------------------------ | ----------------- | ------- | ---------------- |
| -                                                            | -                 | 0.190 s | -                |
| sudo bpftrace -e 'k:vfs_read { 1 }'                          | kprobe            | 0.208 s | 175.8 ns         |
| sudo bpftrace -e 'kr:vfs_read { 1 }'                         | kretprobe         | 0.240 s | 488.3 ns         |
| sudo bpftrace -e 't:syscalls:sys_enter_read { 1 }'           | tracepoint(enter) | 0.215 s | 244.1 ns         |
| sudo bpftrace -e 't:syscalls:sys_exit_read { 1 }'            | tracepoint(exit)  | 0.215 s | 244.1 ns         |
| sudo bpftrace -e 'uprobe:/lib/x86_64-linux-gnu/libc.so.6:read {1;}' | uprobe            | 0.515 s | 3173.8 ns        |
| sudo bpftrace -e 'uretprobe:/lib/x86_64-linux-gnu/libc.so.6:read {1;}' | uretprobe         | 0.666 s | 4648.4 ns        |

