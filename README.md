# deepflow-sigcomm23

## 组件版本要求

* DeepFlow==6.1.7
  * DeepFlowAgent==6.2.0（因为看的时候已经更新到这个版本了）
* Kubernetes
  * kubeadm==v1.24.0
  * kubelet==v1.24.0
  * kubectl==v1.24.0
* containerd==v1.6.2 (worker node)

## 注意事项

切换namespace后，一定要记得切换回来，否则新安装的东西都会被放在另一个namespace而不是default。

## 参考资料

压力测试工具：<https://github.com/denji/awesome-http-benchmark>
