#!/bin/bash
#!/usr/bin/python3

MAIN=`pwd`

# 创建mods文件夹放置mod
mkdir mods
mkdir assets
mkdir total

# 爬虫下载mod
python3 download.py

# 解压mod，提取所有语言文件
cd mods
for modid in `ls`
do
  unzip -o ${modid} assets/*/lang/*.lang -d ${MAIN}/
done
echo "完成语言文件解压"

# 接下来是判定有多少种语言文件
# 一种极为简单的方式就是全放在一起
# 这样同名的会被覆盖，非同名的就不受影响

cd ${MAIN}/assets
for file in `ls`
do
  cp -f ${file}/lang/*.lang ${MAIN}/total
done

i=0
for line in `cut -f1 -d "|" ${MAIN}/country.md | egrep -o "\w{0,}"`
do
  id[${i}]=${line}
  i=`expr ${i} + 1`
done

i=0
for line in `cut -f2 -d "|" ${MAIN}/country.md | egrep -o "\w{0,}"`
do
  name[${i}]=${line}
  i=`expr ${i} + 1`
done

i=0
echo "# 统计列表中的国家代码" > ${MAIN}/total.txt
cd ${MAIN}/total
for c in ${id[*]}
do
  for n in `ls | egrep -o "[[:upper:]]{2}"`
  do
    if [ ${n} = ${c} ]
    then
      echo "${n} -> ${name[${i}]}" >> ${MAIN}/total.txt
    fi
  done
  i=`expr ${i} + 1`
done
