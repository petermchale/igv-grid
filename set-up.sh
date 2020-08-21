set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

node_version="v12.18.3"

mkdir node
cd node
wget "https://nodejs.org/dist/${node_version}/node-${node_version}-linux-x64.tar.xz"
tar -xf "node-${node_version}-linux-x64.tar.xz"
PATH="$PWD/node-${node_version}-linux-x64/bin:$PATH"

which npm 
which node 
exit 1 

pip install cyvcf2

cd create-screenshots
npm install 
cd ../web-app 
npm install 
cd ..
