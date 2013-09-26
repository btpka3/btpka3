检查目录是否为空
http://www.cyberciti.biz/faq/linux-unix-shell-check-if-directory-empty/
`[ "$(/bin/ls -A yourDir)" ] && echo "Not Empty" || echo Empty`