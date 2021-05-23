#!/bin/bash
# 参数一 开始节点号
# 参数二 结束节点号
# 参数三 密码
# 参数四 swap-endpoint
# 参数五 执行版本
# 参数六 系统类型

Path=./              # 工作目录
EngineFile=bee_$5        # 启动bee执行文件名
InitPort=10000       # 开始端口
BeeYamlVersion=bee_$5.yaml

[ -d $Path ]
int=$1
sudo rm -rf accounts.txt
# 结束之前的所有启动进程
sudo ps -aux | grep $EngineFile | awk '{print $2 }' | xargs sudo kill -9
while (($int <= $2)); do
    filename="bee_"$int""
    if [ ! -d $Path/$filename ]; then
        mkdir $Path/$filename
    fi
    cd $Path/$filename
    # bee.yaml
    if [ -c ../configs/$BeeYamlVersion ]; then
        echo "配置文件不存在"
        exit
    fi
    sudo cp ../configs/$BeeYamlVersion ./
    # 修改
    let newPort="InitPort+(int*10)"
    sed -i "1c api-addr: :$newPort" $BeeYamlVersion
    sed -i "2c p2p-addr: :$((newPort + 1))" $BeeYamlVersion
    sed -i "3c debug-api-addr: :$((newPort + 2))" $BeeYamlVersion
    echo "sed -i "4c password: \"$3\"" $BeeYamlVersion"
    sed -i "4c password: \"$3\"" $BeeYamlVersion
    sed -i "5c swap-endpoint: $4" $BeeYamlVersion
    # 启动
    sudo rm -rf output.log
    sudo ../cmd/$EngineFile start --config ./$BeeYamlVersion > output.log &
    # 输出地址
    if [ -d .bee ]; then
        echo "$int账户已创建"
    else
        echo "$int正在创建账户..."
        sleep 5
    fi
    echo "$int节点账户信息:" >>../accounts.txt
    sudo ../exportKeys/exportKeys_$6.exe .bee/keys/ $3 | awk 'NR==3{print $3}' >>../accounts.txt
    echo "============================================================" >>../accounts.txt
    echo "$int节点账户导出成功!"
    cd ..
    let "int++"
done

