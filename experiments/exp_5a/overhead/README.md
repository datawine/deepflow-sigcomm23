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
| 1    | write     | 0.082192 s     | 0.124943 s      | 427.51 ns                  |
| 2    | read      | 0.090606 s     | 0.162634 s      | 720.28 ns                  |
| 3    | sendto    | 0.057167 s     | 0.116222 s      | 590.55 ns                  |
| 4    | recvfrom  | 0.057048 s     | 0.145914 s      | 888.66 ns                  |
| 5    | sendmsg   | 0.057016 s     | 0.084762 s      | 277.46 ns                  |
| 6    | sendmmsg  | 0.056852 s     | 0.084845 s      | 279.93 ns                  |
| 7    | recvmsg   | 0.056655 s     | 0.085161 s      | 285.06 ns                  |
| 8    | recvmmsg  | 0.054130 s     | 0.085895 s      | 317.65 ns                  |
| 9    | writev    | 0.057985 s     | 0.114833 s      | 568.48 ns                  |
| 10   | readv     | 0.059524 s     | 0.146692 s      | 871.68 ns                  |
| 11   | ssl_write | 0.22-0.23 ms   | 0.241-0.26 ms   | -                          |
| 12   | ssl_read  | 0.061-0.065 ms | 0.062-0.065 ms  | -                          |
| 13   | ssl       | 0.53-0.57 ms   | 0.53-0.58 ms    | -                          |
| 14   | None      | 0.000473 s     | 0.000515 s      | -                          |



**复现书上的实验数据**

命令：

```bash
time dd if=/dev/zero of=/dev/null bs=1 count=100k
```



| command                                                      | purpose           | time    | cost-per-command |
| ------------------------------------------------------------ | ----------------- | ------- | ---------------- |
| -                                                            | -                 | 0.146 s | -                |
| sudo bpftrace -e 'k:vfs_read { 1 }'                          | kprobe            | 0.160 s | 136.7 ns         |
| sudo bpftrace -e 'kr:vfs_read { 1 }'                         | kretprobe         | 0.183 s | 361.3 ns         |
| sudo bpftrace -e 't:syscalls:sys_enter_read { 1 }'           | tracepoint(enter) | 0.163 s | 166.0 ns         |
| sudo bpftrace -e 't:syscalls:sys_exit_read { 1 }'            | tracepoint(exit)  | 0.161 s | 146.5 ns         |
| sudo bpftrace -e 'uprobe:/lib/x86_64-linux-gnu/libc.so.6:read {1;}' | uprobe            | 0.404 s | 2519.5 ns        |
| sudo bpftrace -e 'uretprobe:/lib/x86_64-linux-gnu/libc.so.6:read {1;}' | uretprobe         | 0.518 s | 3632.8 ns        |

