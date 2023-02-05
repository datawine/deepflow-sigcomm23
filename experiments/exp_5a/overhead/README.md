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

\<syscall\> = write | read | sendto | recvfrom | sendmsg | sendmmsg | recvmsg | recvmmsg |writev | readv | empty



**检验可执行文件调用了哪些syscall、调用了多少次**

```bash
cd bin
strace -c ./<filename>
```

先编译出可执行文件再用strace



| 序号 | command  | time(no ebpf) | time(with ebpf) | time overhead(per command) |
| ---- | -------- | ------------- | --------------- | -------------------------- |
| 1    | write    | 116 ms        | 185 ms          | 690 ns                     |
| 2    | read     | 127 ms        | 244 ms          | 1170 ns                    |
| 3    | sendto   | 73 ms         | 176 ms          | 1030 ns                    |
| 4    | recvfrom | 74 ms         | 222 ms          | 1480 ns                    |
| 5    | sendmsg  | 73 ms         | 119 ms          | 460 ns                     |
| 6    | sendmmsg | 73 ms         | 119 ms          | 460 ns                     |
| 7    | recvmsg  | 72 ms         | 119 ms          | 470 ns                     |
| 8    | recvmmsg | 72 ms         | 113 ms          | 410 ns                     |
| 9    | writev   | 79 ms         | 171 ms          | 920 ns                     |
| 10   | readv    | 83 ms         | 219 ms          | 1360 ns                    |
| 11   | None     | 0.285 ms      | 0.285 ms        | 0                          |

