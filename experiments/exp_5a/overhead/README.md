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

\<syscall\> = read | recvmmsg | recvmsg | sendmmsg | sendmsg | write



**检验可执行文件调用了哪些syscall、调用了多少次**

```bash
cd bin
strace -c ./<filename>
```

filename = read5 | recvmmsg5 | recvmsg5 | sendmmsg5 | sendmsg5 | write5

先编译出可执行文件再用strace