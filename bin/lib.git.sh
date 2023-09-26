#!/usr/bin/env bash


# git log -n 1 --walk-reflogs --grep-reflog=origin/master --pretty=tformat:"%H"  # fb9d82f5855f5c2169de0843ff0feb0d78ffa001
# git log -n 1 --walk-reflogs --grep-reflog=origin/master --pretty=tformat:"%H" --branches=feature/20230925_k8sMtee3App2 # fb9d82f5855f5c2169de0843ff0feb0d78ffa001
# git

# 检查 branch1 是否 在 branch2 后面（即是否需要再重新 合并）
# gitCheckBranchIsBehind repoLocalDir branch1 branch2
function gitCheckBranchIsBehind(){
  repoLocalDir=$1
  branch1=$2
  branch2=$3

  cd "$repoLocalDir"
  git fetch > /dev/null

  parentCommitId=$(git merge-base ${branch1} ${branch2})
  latestCommitIdOnBranch2=$(git log -n 1 --pretty=tformat:"%H" ${branch2})

  [ "${parentCommitId}" = "${latestCommitIdOnBranch2}" ]

  check_and_exit \
    $? \
    "gitCheckBranchIsBehind : repoLocalDir="${repoLocalDir}", branch \"${branch1}\" is behind branch \"${branch2}\", parentCommitId=${parentCommitId}, latestCommitIdOnBranch2=${latestCommitIdOnBranch2} . Please do a rebase/merge and push." \
    "gitCheckBranchIsBehind : repoLocalDir="${repoLocalDir}", branch \"${branch1}\" no need to merge/rebasebranch \"${branch2}\", parentCommitId=${parentCommitId}, latestCommitIdOnBranch2=${latestCommitIdOnBranch2} ."
  return

}





