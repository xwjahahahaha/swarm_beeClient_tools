#!/bin/bash
while true
do
  int=$1
  while(($int<=$2))
  do
    let api="10000+(10*int)"
    echo -n "[$api]端口,账户地址:"
    curl -s localhost:$(($api+2))/addresses | jq .ethereum
    echo -n "   欢迎度:"
    curl -sX GET http://localhost:$(($api+2))/topology | jq .population
    echo -n "   连接数:"
    sudo curl -s http://localhost:$(($api+2))/peers | jq '.peers | length'
    echo -n "   支票:"
    cheque=`curl -s localhost:$(($api+2))/chequebook/cheque | jq '.lastcheques | length'`
    if [ $cheque -gt 0 ];then
      s=`curl -s localhost:$(($api+2))/chequebook/cheque`
      echo -e "\033[31m $cheque \033[5m"
      echo -e "\033[31m $s \033[5m" 
    else
      echo $cheque
    fi
    let "int++"
    echo ""
  done
  echo "================================================================================================================"
sleep 5;done;
