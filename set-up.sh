set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

root_directory="$PWD" 

# this section assumes that this script is being run on the cluster
node_version="v12.18.3"
curl --remote-name "https://nodejs.org/dist/${node_version}/node-${node_version}-linux-x64.tar.xz"
tar -xf "node-${node_version}-linux-x64.tar.xz"
rm "node-${node_version}-linux-x64.tar.xz"
PATH="${root_directory}/node-${node_version}-linux-x64/bin:$PATH"

pip install cyvcf2

expand_path () {
  local filename_=$1
  sed "s,{{ROOT_DIRECTORY}},${root_directory},g" ${filename_} > ${filename_}.tmp
  mv ${filename_}.tmp ${filename_}
}

expand_path tracks.json
expand_path reference.json
expand_path callSets.json

cd "${root_directory}/create-screenshots" && npm install
cd "${root_directory}/web-app" && npm install

# this section assumes that this script is being run on the cluster
set +x 
echo "***********************" 
echo "add the following to your PATH environment variable in ~/.bash_profile:"
echo "${root_directory}/node-${node_version}-linux-x64/bin"
echo "***********************" 
