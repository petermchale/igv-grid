set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

root_directory="$PWD" 

# cluster-specific code block
node_version="v12.18.3"
curl --remote-name "https://nodejs.org/dist/${node_version}/node-${node_version}-linux-x64.tar.xz"
tar -xf "node-${node_version}-linux-x64.tar.xz"
rm "node-${node_version}-linux-x64.tar.xz"
rm -rf "node"
mv "node-${node_version}-linux-x64" "node"
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

