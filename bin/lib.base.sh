#!/usr/bin/env bash


DOCKER_REG=o-docker.alibaba-inc.com
DOCKER_NAMESPACE=dev

if [[ -z "${EXIT_ON_ERROR}" ]] ; then
  EXIT_ON_ERROR=true
fi

# Usage: mylog error xxx error msg
#
# @param 1 level (info/error/warn/noop)
#
# for colors, see man terminfo
#
mylog(){
  level=$1
  case $1 in
    info)   c=2   ;;
    error)  c=1   ;;
    warn)   c=3   ;;
    *)      level="noop";;
  esac
  shift
  if [[ "${level}" = "noop" ]]
  then
    echo -e "$@"
  else
    echo -e "$(tput setaf $c)$@$(tput op)"
  fi
}

# 检查给定命令的 exit code, 如果不是0， 则打印错误消息，并以该 exit code 退出；否则仅仅打印正常消息
# Usage: check_and_exit $? error_msg success_msg
#
# @param 1 要检查的命令的 exit code，如果是要检查前一个命令的话，通常是 $?
# @param 2 错误消息
# @param 3 成功消息
#
check_and_exit(){
  status=$1
  error_msg=$2
  success_msg=$3
  if [[ $status -ne 0 ]] ; then
    mylog error "${error_msg}"
    if [[ "$EXIT_ON_ERROR" != "false" ]] ; then
      exit $status
    fi
  elif [[ ! -z  "${success_msg}" ]] ; then
    mylog info "${success_msg}"
  fi
}

# 打印数组，值有空格的，则两边加双引号
# arr=(curl -v -X POST -H "Content-Type: application/json"-d /path/to/file)
# printArr "${arr[@]}"
function printArr(){
  tmp_arr=("$@")
  # 有双引号时特殊打印
  for arg in "${tmp_arr[@]}"; do
      # testing if the argument contains space(s)
      if [[ $arg =~ \  ]]; then
        # enclose in double quotes if it does
        arg=\"$arg\"
      fi
      echo -n "$arg "
  done
  echo
}

