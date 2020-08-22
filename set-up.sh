set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

root_directory="$PWD" 

kernel=$(uname --kernel-name)
machine=$(uname --machine)

rm -rf "node"
node_version="v12.18.3"

if [[ ${machine} == 'x86_64' ]]; then
  if [[ ${kernel} == 'Darwin'* ]]; then
    curl --remote-name "https://nodejs.org/dist/${node_version}/node-${node_version}-darwin-x64.tar.gz"
    tar -xf "node-${node_version}-darwin-x64.tar.gz"
		rm "node-${node_version}-darwin-x64.tar.gz"
		mv "node-${node_version}-darwin-x64" "node"
  elif [[ ${kernel} == 'Linux'* ]]; then
    curl --remote-name "https://nodejs.org/dist/${node_version}/node-${node_version}-linux-x64.tar.xz"
    tar -xf "node-${node_version}-linux-x64.tar.xz"
    rm "node-${node_version}-linux-x64.tar.xz"
    mv "node-${node_version}-linux-x64" "node"
  else
    echo 'neither Darwin nor Linux'
    exit 1
  fi
else
  echo 'not x86_64'
  exit 1
fi

# no need to export PATH since it is already in the environment: https://unix.stackexchange.com/a/26059/406037
PATH="${root_directory}/node/bin:$PATH"

pip install cyvcf2

expand_path () {
  local stem_=$1
  sed "s,{{ROOT_DIRECTORY}},${root_directory},g" ${stem_}.template.json > ${stem_}.json
}

expand_path tracks
expand_path reference
expand_path callSets

cd "${root_directory}/create-screenshots" && npm install
cd "${root_directory}/web-app" && npm install

