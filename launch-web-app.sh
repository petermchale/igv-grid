set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

port="8080"

root_directory="$PWD"
# no need to export PATH since it is already in the environment: https://unix.stackexchange.com/a/26059/406037
PATH="${root_directory}/node/bin:$PATH"

cd ${root_directory}/web-app

# use "--proxy" option to serve single-page applications:
# https://github.com/http-party/http-server/pull/513
# https://router.vuejs.org/guide/essentials/history-mode.html#html5-history-mode
node node_modules/http-server/bin/http-server dist --proxy "http://localhost:${port}?" --port ${port} --log-ip

#node node_modules/http-server/bin/http-server --help 
