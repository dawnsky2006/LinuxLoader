# LinuxLoader MainUI
# 2.3.2
#
# Apache License
# http://www.apache.org/licenses/
#
umask 000
if [ ! -n "$xbin" ]; then
    exit 255
    else
    clear
   fi
opts() {
clear
  echo
  echo "#########################"
  echo "#  LinuxLoader $version [$confs]"
  echo "#  1. 启动 Rootfs"
  echo "#  2. 启动 Rootfs[Proot]"
  echo "#  3. 启动 Rootfs 镜像"
  echo "#  4. 设置"
  echo "#  5. 配置设置"
  echo "#  6. 安装 / 配置 Rootfs"
  echo "#  7. 更新配置"
  echo "#"
  echo "#  a. 关于"
  echo "#  x. 退出"
  echo "#########################"
  echo
  
  printf "[请输入选项]"
  read Input
    case "$Input" in
      1 ) chrootstart;;
      2 ) prootstart;;
      3 ) runimage;;
      4 ) configopts;;
      5 ) setconf;;
      6 ) installrootfs;;
      7 ) reload;;
      8 ) repo;;
      a ) about;;
      s ) shell;;
      x ) quit;;
      * ) opts;;
    esac
}
quit() {
echo "Exit..."
sleep 1
clear
exit
}
repo() {
sleep 1
clear
sh $xbin/all/service.sh repo
exit
}
shell() {
sleep 1
bash
exit
}
chrootstart() {
clear
sleep 1
sh $xbin/all/service.sh chrootinit
sleep 1
clear
opts
}
runimage() {
sleep 1
clear
sh $xbin/all/service.sh runimage
sleep 1
clear
opts
}
prootstart() {
sleep 1
clear
sh $xbin/all/service.sh prootinit
sleep 1
clear
opts
}
# Reload
reload() {
clear
sleep 1
clear
sh ./main.sh
clear
opts
}
# About
about() {
###
clear
echo
echo
echo "LinuxLoader MainUI "
echo "版本: $version"
echo ""
sh $xbin/all/service.sh about
printf "[返回]"
  read Input
    case "$Input" in
      * ) opts;;
    esac
    clear
####
}
# 切换配置
setconf() {
clear
  echo
  echo "#########################"
  echo "#    当前配置: [$confs]"
  echo "#"
  echo "#    配置列表:"
  echo ""
  echo "$conflist"
  echo ""
  echo "#   1. 新建"
  echo "#   2. 删除"
  echo "#   3. 切换"
  echo "#   x. 返回"
  echo "########################"
  echo
  
  printf "[请输入选项]"
  read Input
    case "$Input" in
      x ) opts;;
      1 ) mkconf;;
      2 ) rmconf;;
      3 ) reconf;;
    esac
    setconf
}
clear
# 创建配置
mkconf() {
    clear
    sh $xbin/all/service.sh mkconf
    clear
    opts
    }
# 切换配置
reconf() {
    clear
    sh $xbin/all/service.sh reconf
    opts
    }
# 删除配置
rmconf() {
    clear
    sh $xbin/all/service.sh rmconf
    opts
    }
# 配置设置
configopts() {
clear
  echo
  echo "#########################"
  echo "#  设置 [$confs]"
  echo "#  1. Rootfs 目录"
  echo "#  2. 运行目录"
  echo "#  3. 初始化命令行"
  echo "#  4. 修改配置名称"
  echo "#  5. 删除已安装 Rootfs"
  echo "#  6. 查看 log"
  echo "#  7. 生成 BusyboxRootfs"
  echo "#  8. 设置 Proot 运行路径"
  echo "#  9. 挂载 Rootfs 分区"
  echo "#"
  echo "#  x. 返回"
  echo "#########################"
  echo
  
  printf "[请输入选项]"
  read Input
    case "$Input" in
      x ) opts;;
      1 ) rootfsopts;;
      3 ) bashopts;;
      2 ) tempopts;;
      4 ) nameopts;;
      5 ) rmrootfsopts;;
      6 ) checklog;;
      7 ) makerootfs;;
      8 ) prootset;;
      9 ) unautomount;;
    esac
    configopts
}
# RmRootfs设置
rmrootfsopts() {
clear
sh $xbin/all/service.sh rmrootfsopts
configopts
}
prootset() {
# Proot RundirSet
#  - - - - - - - - - - - - -
sleep 1
clear
sh $xbin/all/service.sh prootset
sleep 1
clear
configopts
}

# ROOTFS路径设置
rootfsopts() {
clear
sh $xbin/all/service.sh rootfsopts
    sleep 1
    configopts
}
# 初始化命令行设置
bashopts() {
clear
clear
sh $xbin/all/service.sh shellopts
configopts
}
# 临时文件目录设置
tempopts() {
clear
sh $xbin/all/service.sh tempopts
configopts
}
# 配置名称设置
nameopts() {
clear
sh $xbin/all/service.sh reconf
configopts
}

# Log
checklog() {
clear
echo "- 正在导出Log"
sh $xbin/all/service.sh checklog>>check.log
echo "- 导出成功"
sleep 1
clear
configopts
}
# Rootfs安装
installrootfs() {
clear
sh $xbin/all/service.sh config
sleep 2
clear
opts
}
# MAKEROOTFS
makerootfs() {
clear
sh $xbin/all/service.sh mkbusyboxrootfs
    sleep 1
    configopts
}
unautomount() {
#  - - - - - - - - - - - - -
sleep 1
sh $xbin/all/service.sh unautomount
sleep 1
clear
opts
}

opts