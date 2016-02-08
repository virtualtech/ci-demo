#!/bin/bash

function get_package_info() {
  func_result=`cat $1 | grep $2 |awk -v OFS=, '{print $1,$2}'`
  if [ -z "${func_result}" ]; then
    func_result=`echo $2,Not installed`
  fi
  echo $func_result
}

### installed_package.csv を1世代バックアップを取っておく
installed_package_list="./installed_package.csv"
if [ -e $installed_package_list ]; then
  rm ${installed_package_list}.bak
  mv $installed_package_list ${installed_package_list}.bak
fi

### インスール済みのパッケージリストを取得
all_package_list=`mktemp /tmp/pkglist.XXXXXX`
yum list installed > $all_package_list

### fixed_package.csv に記載されているパッケージがインストールされているか
### 確認し、installed_package.csvへ書き込み
while read line
do
  package_name=`echo $line | awk -F, '{print $1}'`
  fixed_version=`echo $line | awk -F, '{print $2}'`
  installed_package_info=`get_package_info $all_package_list $package_name`

  installed_version=`echo $installed_package_info | awk -F, '{print $2}'`
  if [ "$installed_version" == "Not installed" ]; then
    echo $package_name is not installed.
  elif [ "$installed_version" != "$fixed_version" ]; then
    echo $package_name is version missmatch.
    installed_package_info="$installed_package_info,Version missmatch"
  fi

  echo $installed_package_info >> $installed_package_list
done < fixed_package.csv

rm $all_package_list
