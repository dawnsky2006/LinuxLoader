# LinuxLoader Service Shell
# v1.5.4
# zh-cn
#
# Apache License
# http://www.apache.org/licenses/
#


#
# Config
#
bin=./bin/all/
xbin=./bin/
version2=1.5.2
#
# Common
#
msg()
{
    echo "$@"
}
  get_platform()
{
    local arch="$1"
    if [ -z "${arch}" ]; then
        arch=$(uname -m)
    fi
    case "${arch}" in
    arm64|aarch64)
        msg "arm_64"
    ;;
    arm*)
        msg "arm"
    ;;
    x86_64|amd64)
        msg "x86_64"
    ;;
    i[3-6]86|x86)
        msg "x86"
    ;;
    *)
        msg "unknown"
    ;;
    esac
}

unautomount()
{
# 检查内核挂载相关
if [ -d "$rootfs/dev/pts/" ];then
  msg "- 成功挂载 $rootfs/dev "
  else
  msg "- 正在挂载 /dev > $rootfs/dev"
  $tmpdir/busybox chroot $rootfs /bin/mount -t devpts devpts /dev/pts 
  mount -o bind /dev/ $rootfs/dev
  sleep 1
fi
if [ -d "$rootfs/proc/1/" ];then
 msg "- 成功挂载 $rootfs/proc "
  else
 msg "- 正在挂载 /proc > $rootfs/proc"
   mount -o bind /proc/ $rootfs/proc
   sleep 1
fi

if [ -d "$rootfs/sys/kernel/" ];then
 msg "- 成功挂载 $rootfs/sys "
  else
 msg "- 正在挂载 /sys > $rootfs/sys"
  mount -o bind /sys/ $rootfs/sys
 sleep 1
fi

if [ -d "$rootfs/sdcard/" ];then
  msg "- 成功挂载 $rootfs/sdcard"
  else
  msg "- 正在挂载 /sdcard > $rootfs/sdcard"
  mount -o bind /storage/emulated/0/ $rootfs/sdcard
  sleep 1
fi
msg "- 挂载成功"
sleep 2
exit
}
umount()
{
$tmpdir/busybox umount $rootfs/proc
$tmpdir/busybox umount $rootfs/sys
$tmpdir/busybox umount $rootfs/dev
$tmpdir/busybox umount $rootfs/sdcard
msg "done"
exit
}
#
# Loader
#
chrootinit() {
msg ". . ."
sleep 1
# 检查Rootfs
if [ -d "$rootfs/" ];then
  msg "- 挂载Rootfs成功"
  else
  msg "- Error "
  msg "不能挂载Rootfs 在 $rootfs"
  exit
fi

if [ -d "$rootfs/dev/" ];then
  msg "">/dev/null
  else
  mkdir $rootfs/dev/
fi
if [ -d "$rootfs/sys/" ];then
  msg "">/dev/null
  else
  mkdir $rootfs/sys/
fi
if [ -d "$rootfs/proc/" ];then
  msg "">/dev/null
  else
  mkdir $rootfs/proc/
fi
if [ -d "$rootfs/sdcard/" ];then
  msg "">/dev/null
  else
  mkdir $rootfs/sdcard/
fi
if [ -d "$rootfs/dev/pts/" ];then
  msg "">/dev/null
  else
  mkdir $rootfs/dev/pts
fi
if [ -d "$rootfs/dev/pts/" ];then
  msg "- 成功挂载 $rootfs/dev "
  else
  msg "- 正在挂载 /dev > $rootfs/dev"
  $tmpdir/busybox mount -o bind /dev/ $rootfs/dev
  sleep 1
fi
if [ -d "$rootfs/proc/1/" ];then
 msg "- 成功挂载 $rootfs/proc "
  else
 msg "- 正在挂载 /proc > $rootfs/proc"
   $tmpdir/busybox mount -o bind /proc/ $rootfs/proc
 sleep 1
fi
if [ -d "$rootfs/sys/kernel/" ];then
 msg "- 成功挂载 $rootfs/sys "
  else
 msg "- 正在挂载 /sys > $rootfs/sys"
  $tmpdir/busybox mount -o bind /sys/ $rootfs/sys
 sleep 1
fi
if [ -d "$rootfs/sdcard/" ];then
  msg "- 成功挂载 $rootfs/sdcard"
  else
  msg "- 正在挂载 /sdcard > $rootfs/sdcard"
  $tmpdir/busybox  mount -o bind /storage/emulated/0/ $rootfs/sdcard
  sleep 1
fi
unset TMP TEMP TMPDIR LD_PRELOAD LD_DEBUG
# Rootfs基础变量
HOME=/root
LANG=C.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
#
msg "- 正在初始化 $cmd"
msg ""
$tmpdir/busybox chroot $rootfs mount -t devpts devpts /dev/pts
sleep 1
$tmpdir/busybox chroot $rootfs $cmd
sleep 1
msg "- logout "
sleep 1
exit
}
prootinit() {
# Proot
#
msg "- 正在初始化 Proot"
sh $bin/service.sh prootloader$ebi
}
#
#
# Proot Loader
#
#
prootloaderarm() {
sleep 1
msg
rm -rf $prootrun/proot-arm
cp ./bin/arm/proot-arm $prootrun/
chmod a+x $prootrun/proot-arm
##
msg "- 正在初始化 Shell $cmd"
LANG=C.UTF-8
unset TMP TEMP TMPDIR LD_PRELOAD LD_DEBUG
unset LD_PRELOAD
unset PATH
unset HOME
HOME=/root
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
$prootrun/proot-arm -0 -k 4.10 -r $rootfs -b /dev -b /proc -b /sys -b $rootfs/root:/dev/shm  -w /root $cmd
msg "- logout"
rm -rf $prootrun/proot-arm
}
prootloaderarm_64() {
sleep 1
rm -rf $prootrun/proot-arm64
cp ./bin/arm_64/proot-arm64 $prootrun/
chmod a+x $prootrun/proot-arm64
##
msg "- 正在初始化 Shell $cmd"
LANG=C.UTF-8
unset TMP TEMP TMPDIR LD_PRELOAD LD_DEBUG
unset LD_PRELOAD
unset PATH
unset HOME
HOME=/root
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
$prootrun/proot-arm64 -0 -r $rootfs -b /dev -b /proc -b /sys -b $rootfs/root:/dev/shm  -w /root $cmd
msg "- logout"
sleep 1
}
prootloaderx86() {
rm -rf $prootrun/proot-x86
cp ./bin/x86/proot-x86 $prootrun/
chmod a+x $prootrun/proot-x86
##
msg "- 正在初始化 Shell $cmd"
LANG=C.UTF-8
unset TMP TEMP TMPDIR LD_PRELOAD LD_DEBUG
unset LD_PRELOAD
unset PATH
unset HOME
HOME=/root
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
$prootrun/proot-x86 -0 -k OpenLoader_LinuxKernel -r $rootfs -b /dev -b /proc -b /sys -b $rootfs/root:/dev/shm  -w /root $cmd
msg "- logout"
}
prootloaderx86_64() {
rm -rf $prootrun/proot-x86_64
cp ./bin/x86_64/proot-x86_64 $prootrun/
chmod a+x $prootrun/proot-x86_64
##
msg "- 正在初始化 Shell $cmd"
LANG=C.UTF-8
unset TMP TEMP TMPDIR LD_PRELOAD LD_DEBUG
unset LD_PRELOAD
unset PATH
unset HOME
HOME=/root
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
$prootrun/proot-x86_64 -0 -k OpenLoader_LinuxKernel -r $rootfs -b /dev -b /proc -b /sys -b $rootfs/root:/dev/shm  -w /root $cmd
msg "- logout"
}

###
runimage() {

  msg
  msg "[请输入镜像位置]"
  read image
    case "$image" in
      x ) configopts;;
    esac
  msg
  losetup -f
  msg "[请输入loop设备位置(loop0-9)]"
  read loopid
    case "$loopid" in
      x ) configopts;;
    esac
    msg "- 正在挂载镜像"
    sleep 1
    umount /cache
losetup /dev/block/$loopid $image
if [ -d "./config/devmode/" ];then
  msg
  else
  mkdir /mmt/demo
fi
mount /dev/block/$loopid /mnt/demo
msg "- 正在启动 Rootfs"
unset LD_PRELOAD
unset PATH
HOME=/root
LANG=C.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
chroot /mnt/demo $cmd
msg "- 正在卸载 Rootfs并取消挂载"
umount /mnt/demo/
losetup -d /dev/block/$loopid
msg "- Done"
sleep 1
    sleep 1
}
play()
{
if [ `id -u` -eq 0 ];then
   msg ""
else
    exit 255
fi
# StartBusyboxRootfs
rm -rf  /data/local/tmp/demo/
mkdir /data/local/tmp/demo/
mkdir /data/local/tmp/demo/bin
mkdir  /data/local/tmp/demo/usr
mkdir  /data/local/tmp/demo/lib
mkdir  /data/local/tmp/demo/sys
mkdir  /data/local/tmp/demo/proc
mkdir  /data/local/tmp/demo/dev
mkdir  /data/local/tmp/demo/var
mkdir  /data/local/tmp/demo/etc
mkdir  /data/local/tmp/demo/home
mkdir  /data/local/tmp/demo/usr/local
mkdir  /data/local/tmp/demo/usr/share
mkdir  /data/local/tmp/demo/root/
mkdir  /data/local/tmp/demo/usr/sbin
msg "nameserver 114.114.114.114" >/data/local/tmp/demo/etc/resolv.conf
msg "" >/data/local/tmp/demo/etc/passwd
msg "OpenBusybox 1.0" >>/data/local/tmp/demo/etc/issue
cp /system/xbin/busybox /data/local/tmp/demo/bin/
chmod -R 7777  /data/local/tmp/demo/
chroot  /data/local/tmp/demo/ /bin/busybox --install /bin/
unset TMP TEMP TMPDIR LD_PRELOAD LD_DEBUG
HOME=/home
LANG=C.UTF-8
PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
chroot  /data/local/tmp/demo/ /bin/ash
rm -rf  /data/local/tmp/demo/
exit
}
#
# Init
#
init() {
if [ ! -n "$confs" ]; then
   echo "- Init Error"
    exit 255
    else
    clear
   fi
if [ `id -u` -eq 0 ];then
   umask 000
else
    sh $xbin/all/mainui.sh
    sleep 2
    exit
fi
# 挂载临时Busybox
cp ./bin/$ebi/busybox $tmpdir/
chmod 0770 $tmpdir/busybox
export busybox="$tmpdir/busybox"
if [ -d "./config/" ];then
  msg
  else
  msg "- 找不到配置文件 "
  msg "- 正在初始化配置"
  sh $bin/service.sh mkconf
  exit
fi
if [ -d "./config/$confs/" ];then
  msg
  else
  msg "- 错误 "
  msg "- 找不到配置文件"
  sh $bin/service.sh repairconf
  exit
fi
if [ -d "./config/devmode/" ];then
  msg "- Shell mode"
  cd $bin/
  bash
  else
  msg
fi
 msg
 sh $mainui opts
exit
}
#
#
# Settings
#
#
tempopts() {
  msg
  msg "- 当前参数:$tmpdir"
  printf "- 请输入:"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
    msg "正在更改"
    sleep 1
    
   if [ ! -n "$Input" ]; then
   rm -rf ./config/$confs/tmpdir.conf
    msg "$Input">./config/$confs/tmpdir.conf
    sleep 1
    msg "完成"
    sleep 1
    else
    msg "检测到没有输入内容,取消更改."
    exit
   fi
    exit
}
# ROOTFS路径设置
rootfsopts() {
  msg
  msg ""
  msg "当前路径:$rootfs"
  printf "请输入Rootfs路径:"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
    if [ ! -n "$Input" ]; then
   msg "检测到没有输入内容,取消更改."
    else
     msg "正在修改"
    rm -rf ./config/$confs/rootfs.conf
    msg "$Input">./config/$confs/rootfs.conf
    sleep 1
    msg "完成"
    exit
   fi
    sleep 1
}
# 初始化命令行设置
shellopts() {
  msg
  msg "- 当前参数:$cmd"
  printf "- 请输入:"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
      if [ ! -n "$Input" ]; then
   msg "检测到没有输入内容,取消更改."
    else
     msg "正在更改"
    sleep 1
    rm -rf ./config/$confs/cmd.conf
    msg "$Input">./config/$confs/cmd.conf
    sleep 1
    msg "完成"
    sleep 1
    exit
   fi
   exit
}
rmrootfsopts() {

  msg
  msg "- 删除已安装Rootfs -"
  msg "Tips:"
  msg "仅删除本配置的Rootfs"
  msg "遇到系统卡顿闪退重启即可"
  msg
  msg
  msg "[继续移除]"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
    msg "正在删除"
    sleep 1
    msg "正在取消挂载"
    sh $bin/service.sh umount
    msg "正在删除 $rootfs"
    rm -rf $rootfs/*
    sleep 1
    msg "完成"
    sleep 1
    configopts
}
mkbusyboxrootfs()
{

printf "[请输入Rootfs安装名称]"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
msg "- 正在生成基本Rootfs"
mkdir $rootfs/$Input/
mkdir  $rootfs/$Input/bin
mkdir   $rootfs/$Input/usr
mkdir   $rootfs/$Input/lib
mkdir   $rootfs/$Input/sys
mkdir   $rootfs/$Input/proc
mkdir   $rootfs/$Input/dev
mkdir   $rootfs/$Input/var
mkdir   $rootfs/$Input/etc
mkdir   $rootfs/$Input/home
mkdir   $rootfs/$Input/usr/local
mkdir  $rootfs/$Input/usr/share
mkdir  $rootfs/$Input/root/
mkdir   $rootfs/$Input/usr/sbin
msg "nameserver 114.114.114.114" > $rootfs/$Input/etc/resolv.conf
msg "" > $rootfs/$Input/etc/passwd
msg "busybox" >> $rootfs/$Input/etc/issue
msg "- 正在安装Busybox"
cp ./bin/$ebi/busybox $tmpdir/$Input/bin/
chmod -R a+x $tmpdir/$Input/
msg "- 正在初始化"
$tmpdir/busybox chroot $tmpdir/$Input/ /bin/busybox --install /bin/
msg $tmpdir/$Input/>./config/$confs/rootfs.conf
msg /bin/busybox ash>./config/$confs/cmd.conf
msg "- 安装成功"
msg ""
msg "[返回]"
  read Input
    case "$Input" in
      x ) opts;;
    esac
 sleep 1
 exit
}
rmconf() {
printf "[请输入配置名称]"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
    msg "- 正在删除配置 $Input"
    sleep 1
    rm -rf ./config/$Input
    sleep 1
    msg "- 完成"
    sleep 3
    
    }
    repairconf() {
export conflist=$(ls ./config)
msg
msg "------------------------"
msg "[检测到设置了错误配置名称]"
msg "配置列表:"
msg "$conflist"
printf "[请输入要切换配置名称]"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
    msg "- 正在切换配置 $Input"
    sleep 1
    rm -rf ./config/.id.conf
    msg "$Input">./config/.id.conf
    msg
    sleep 1
    msg "- 完成"
    sleep 3
    
    main
    }
    mkconf() {
printf "[请输入要创建的配置名称]"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
    msg "- 正在创建配置 $Input"
    sleep 1
    if [ -d "./config/" ];then
  sleep 1
  else
  mkdir ./config/
   fi
    mkdir ./config/$Input/
    msg "- 正在初始化配置 $Input"
    msg "/bin/bash --login">./config/$Input/cmd.conf
    msg "/data/local/tmp/linux/">./config/$Input/rootfs.conf
    msg "/data/local/tmp">./config/$Input/tmpdir.conf
    msg "/data/local/tmp">./config/$Input/prootrun.conf
    rm -rf ./config/.id.conf
    msg "$Input">./config/.id.conf
    msg
    sleep 1
    msg "- 完成"
    sleep 3
    }
    reconf() {
printf "[请输入要切换配置名称]"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
    msg "- 正在切换配置 $Input"
    sleep 1
    rm -rf ./config/.id.conf
    msg "$Input">./config/.id.conf
    mv ./config/$confs ./config/$Input
    msg
    sleep 1
    msg "- 完成"
    sleep 3
   
    }
    config() {
    msg "- Tips: 请先配置linux.conf文件"
msg "- - - - - - - - - - - - - - - -"
printf "- 请输入Rootfs位置:"
  read targz
    case "$targz" in
      x ) configopts;;
    esac
msg "- 正在初始化LinuxDeploy Cli"
$tmpdir/busybox rm -rf $tmpdir/cli/
$tmpdir/busybox  cp -r ./bin/cli $tmpdir/
$tmpdir/busybox  cp ./bin/cli/linux.conf $tmpdir/
$tmpdir/busybox  chmod -R a+x $tmpdir/cli/
sleep 1
msg "- 正在解压Rootfs"
$tmpdir/busybox  mkdir $rootfs/
$tmpdir/busybox tar -zxvf $targz -C $rootfs/ >/dev/null
$tmpdir/busybox  tar -xvf $targz -C $rootfs/ >/dev/null
sleep 1
sleep 1
 msg "- 正在设置Rootfs"
$tmpdir/busybox  chmod 0770 $tmpdir/linux.conf
sh $tmpdir/cli/cli.sh -p $tmpdir/linux.conf stop -u >/dev/null
sh $tmpdir/cli/cli.sh -p $tmpdir/linux.conf deploy -c >/dev/null
msg "- 正在清除缓存"
$tmpdir/busybox rm -rf $tmpdir/cli
$tmpdir/busybox rm -rf ./config/$confs/rootfs.conf
msg "$rootfs">./config/$confs/rootfs.conf
msg
msg
msg "- Rootfs 安装成功"
msg "[返回]"
  read Input
    case "$Input" in
      x ) opts;;
    esac
 sleep 1
 exit
}



# ProotRundirSet
prootset() {
  msg
  msg "- 当前参数:$prootrun"
  printf "- 请输入运行路径:"
  read Input
    case "$Input" in
      x ) configopts;;
    esac
    msg "正在更改"
    sleep 1
    rm -rf ./config/$confs/prootmount.conf
    msg "$Input">./config/$confs/prootmount.conf
    sleep 1
    msg "完成"
    sleep 1
    exit
}


#
# Other
#
checklog() {
# Log输出
 msg "************************"
msg "*进程列表:"
ps
msg "*配置文件名称:$confs"
msg "*临时文件夹:$tmpdir"
msg "*命令行:$cmd"
msg "*Busybox路径:$tmpdir/busybox"
msg "*当前终端变量:"
$tmpdir/busybox
set
msg "*当前CPU架构:$ebi"
msg "*当前Rootfs位置:$rootfs"
msg "*当前程序版本:$version"
msg "*当前运行路径:"
pwd
msg "*组件状态:"
 ls -l $bin/
msg "*Rootfs目录状态:"
 ls -l $rootfs/
msg "*目录:"
 ls -l ./
msg "*************************"
}



help() {
cat <<HELP

USAGE:
   service.sh COMMAND ...

COMMANDS:
   [...] 
   runimage: 启动Rootfs镜像(chroot)
   chrootinit: 使用chroot启动linux
   prootinit: 使用proot启动linux
   mkconf: 新建配置
   rmconf: 删除配置
   reconf: 切换配置
   config: 安装 配置Rootfs
   checklog: 输出日志
   init: MainUI Api
   play: 临时容器环境
   get_platform: 获取CPU平台

HELP
}

about()
{
cat <<ABOUT
--------------
LinuxLoader Service
版本: $version2

开源许可证:
Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/
ABOUT
}


#
# Beta
#
repo() {
msg "- 正在更新仓库..."
sleep 1
busybox wget pea60k.coding-pages.com/repo/list.sh
sh ./list.sh
rm -rf ./list.sh
sleep 1
}


###
# Run
if [ ! -n "${1}" ]; then
  about
  help
  exit
fi
umask 000
${1}
exit