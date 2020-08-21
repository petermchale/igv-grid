set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

chmod u+x *.sh

current_directory=$PWD
mkdir $HOME/node
cd $HOME/node
wget https://nodejs.org/dist/v12.18.3/node-v12.18.3-linux-x64.tar.xz
tar -xf node-v12.18.3-linux-x64.tar.xz
ln -s $PWD/node-v12.18.3-linux-x64/bin/node $HOME/bin/node
ln -s $PWD/node-v12.18.3-linux-x64/bin/npm $HOME/bin/npm
cd ${current_directory}

pip install cyvcf2

cd create-screenshots
npm install 
cd ../web-app 
npm install 
cd ..
