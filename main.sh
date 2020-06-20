# LinuxLoader
# 2.3.3
#
# Apache License
# http://www.apache.org/licenses/
#
#
# 未来会完善更新哒（｡ò ∀ ó｡）
# 2.3.3-20200619
export version="2.3.3"
if [ `id -u` -eq 0 ];then
   umask 000
else
    echo
    echo "检测到无ROOT"
    echo 
    echo "无ROOT可能无法运行."
    echo
    sleep 2
fi
#启动入口
main() {
  echo
  echo "-----------------------------"
  echo "     LinuxLoader $version "
  echo "         Loading"
  echo ""
  echo "-----------------------------"
  get_platform()
{
    local arch="$1"
    if [ -z "${arch}" ]; then
        arch=$(uname -m)
    fi
    case "${arch}" in
    arm64|aarch64)
        echo "arm_64"
    ;;
    arm*)
        echo "arm"
    ;;
    x86_64|amd64)
        echo "x86_64"
    ;;
    i[3-6]86|x86)
        echo "x86"
    ;;
    *)
        echo "unknown"
    ;;
    esac
}
# Core
export xbin="./bin"
# MainUI Init
export mainui="$xbin/all/mainui.sh"
export confs=$(cat ./config/.id.conf)
export conflist=$(ls ./config/)
# Config
export prootrun=$(cat ./config/$confs/prootmount.conf)
export ebi=$(get_platform)
export cmd=$(cat ./config/$confs/cmd.conf)
export tmpdir=$(cat ./config/$confs/tmpdir.conf)
export rootfs=$(cat ./config/$confs/rootfs.conf)
# Repo
export repo=pea60k.coding-pages.com/
# 
if [ -d "$xbin/" ];then
  echo
  else
  echo "- 错误 "
  echo "- 找不到二进制文件"
  exit
fi
if [ -f "$xbin/LICENSE" ];then
echo
else
echo "找不到许可证文件,失败"
exit 255
fi
if [ -f "$xbin/all/service.sh" ];then
  sh $xbin/all/service.sh init
  else
  echo "- 错误"
  echo "- 关键组件已丢失."
  exit
fi

}
#开始运行
clear
main