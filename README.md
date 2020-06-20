# LinuxLoader
Based on proot and chroot, easily use Linux subsystem in Android/Recovery mode terminal.
#### What is it?
简单使用 Chroot/ Proot 容器在Android/Recovery环境运行较为完整的Linux发行版
(与Linux on Android相同,但简单易用)

#### 体验

![](https://images.gitee.com/uploads/images/2020/0614/230412_a50a2061_2002763.jpeg "IMG_20200614_225528.jpg")
![](https://images.gitee.com/uploads/images/2020/0614/230440_b260bfea_2002763.jpeg "IMG_20200614_225601.jpg")
![](https://images.gitee.com/uploads/images/2020/0617/225639_196f918e_2002763.jpeg "IMG_20200617_225546.jpg")

 多个Linux发行版可同时后台运行  
 可设置多个配置  
 支持Proot和Chroot  
 支持自动生成基本Rootfs  
 支持使用LinuxRootfs Img镜像  
 自动正确挂载指定分区  
 支持TWRP及其衍生版运行Linux  
 Rootfs安装配置基于 LinuxDeployCli  
 Proot属于测试状态，不保证所有Rootfs能运行  

#### 已支持的发行版

[Rootfs下载](http://pea60k.coding-pages.com/rootfs/)

Manjaro  
Ubuntu 18.04 / 20.04 LTS  
Debian  
Alpine  
ArchLinux  
Slackware  
CentOS  
Fedora  
Kali  
Anthon  
Raspbianpi  
Busybox  
OpenWrt  
BlackBox  
Opensuse  
