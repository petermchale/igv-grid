set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

port="9000" 
number_thumbnails="2"
slop="250"

root_directory="$PWD"
# no need to export PATH since it is already in the environment: https://unix.stackexchange.com/a/26059/406037
PATH="${root_directory}/node/bin:$PATH" 

cd ${root_directory}/create-screenshots
./createThumbnails.sh ${port} ${number_thumbnails} ${slop}

cd ${root_directory}/web-app
npm run build
mv igv dist
