set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

root_directory="$PWD"
dist="${root_directory}/web-app/dist"
igv="${dist}/igv"

echo 'igv-grid.surge.sh' > ${dist}/CNAME

# https://surge.sh/help/adding-a-200-page-for-client-side-routing
cp ${dist}/index.html ${dist}/200.html 

for link in $(find ${igv} -type l); do
  target="$(readlink ${link})"
	rm ${link}
	cp ${target} ${igv} 
done

# https://cli.vuejs.org/guide/deployment.html#surge
cd ${dist}
surge

