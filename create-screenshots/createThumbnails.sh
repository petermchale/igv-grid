set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# Would be nice to start the server and puppeteer in a single js file, like ...
# https://masteringjs.io/tutorials/fundamentals/puppeteer (Using Puppeteer with a Local Web Server)
# ... but this would require configuring express to accept range requests. 
# The solution below circumvents that complication by using "http-server", 
# a CLI-based server that is pre-configured to handle range requests 

port=$1 
number_thumbnails=$2 
slop=$3 

server="http-server"

script_directory="$PWD"

webApp_assets_directory_relative="/src/assets"
webApp_igv_directory_relative="igv"
createScreenshots_assets_directory_relative="/assets"

parent_directory="$(dirname "${script_directory}")"
webApp_assets_directory_absolute="${parent_directory}/web-app${webApp_assets_directory_relative}" 
webApp_igv_directory_absolute="${parent_directory}/web-app/public/${webApp_igv_directory_relative}" 
createScreenshots_assets_directory_absolute="${parent_directory}/create-screenshots${createScreenshots_assets_directory_relative}" 

thumbnails_directory="thumbnails"

mkdir --parents ${webApp_assets_directory_absolute}/${thumbnails_directory}
rm --force ${webApp_assets_directory_absolute}/${thumbnails_directory}/*.png 
rm --force ${webApp_assets_directory_absolute}/${thumbnails_directory}.json

mkdir --parents ${webApp_igv_directory_absolute}
rm --force ${webApp_igv_directory_absolute}/*.gz
rm --force ${webApp_igv_directory_absolute}/*.tbi
rm --force ${webApp_igv_directory_absolute}/*.cram
rm --force ${webApp_igv_directory_absolute}/*.crai

get_tracks () {
  cat ../tracks.json | python get_tracks.py
}

clean_up_createScreenshots_assets_directory () {
  rm --force ${createScreenshots_assets_directory_absolute}/*.vcf
  rm --force ${createScreenshots_assets_directory_absolute}/*.bed
  rm --force ${createScreenshots_assets_directory_absolute}/*.gz
  rm --force ${createScreenshots_assets_directory_absolute}/*.tbi 
  for track_ in $(get_tracks); do
    IFS=',' read track_url_ track_indexURL_ track_directory_ <<< "${track_}"
    rm --force ${createScreenshots_assets_directory_absolute}/${track_url_} 
    rm --force ${createScreenshots_assets_directory_absolute}/${track_indexURL_}
  done
}

clean_up_createScreenshots_assets_directory

get_call_sets () {
  cat ../callSets.json | python get_call_sets.py
}

get_chromosome_sizes () {
  cat ../reference.json | python get_chromosome_sizes.py
}

for call_set in $(get_call_sets); do
  IFS=',' read call_set_stem call_set_suffix call_set_directory <<< "${call_set}"
  IFS=',' read chromosome_sizes chromosome_sizes_directory <<< "$(get_chromosome_sizes)"

  if [[ ${call_set_suffix} != 'vcf' ]]; then
    echo "call set should be uncompressed vcf but has suffix:" ${call_set_suffix}
    exit 1
  fi

	ln --symbolic \
    ${call_set_directory}/${call_set_stem}.${call_set_suffix} \
    ${createScreenshots_assets_directory_absolute}

  call_set_path=${createScreenshots_assets_directory_absolute}/${call_set_stem}
  
  python vcf_to_bed.py ${call_set_path}.vcf |
    shuf --head-count=${number_thumbnails} |
    bedtools slop -i stdin -g ${chromosome_sizes_directory}/${chromosome_sizes} -b ${slop} \
    > ${call_set_path}.sampled.slopped.bed
    
  (grep ^"#" ${call_set_path}.vcf; (grep --invert-match ^"#" ${call_set_path}.vcf || true) \
    | sort --version-sort -k1,1 -k2,2) \
    > ${call_set_path}.sorted.vcf
  bgzip --force ${call_set_path}.sorted.vcf
  tabix --preset vcf ${call_set_path}.sorted.vcf.gz  
  cp ${call_set_path}.sorted.vcf.gz ${webApp_igv_directory_absolute}
  cp ${call_set_path}.sorted.vcf.gz.tbi ${webApp_igv_directory_absolute}
done

make_symbolic_link () { 
  local target_=$1
  ln --symbolic ${target_} ${createScreenshots_assets_directory_absolute}
  ln --symbolic ${target_} ${webApp_igv_directory_absolute}
}

for track in $(get_tracks); do
  IFS=',' read track_url track_indexURL track_directory <<< "${track}"
  make_symbolic_link ${track_directory}/${track_url} 
  make_symbolic_link ${track_directory}/${track_indexURL} 
done

# Use "less -R" to view ${server}.out and ${server}.err,
# c.f., https://en.wikipedia.org/wiki/ANSI_escape_code
# use node version 10 to avoid http-server error: 
# https://github.com/http-party/http-server/issues/537
node node_modules/http-server/bin/${server} -p ${port} > ${server}.log 2> ${server}.err &
which node 
exit 1

url="http://127.0.0.1:${port}/igv.html"
node createThumbnails.js \
  ${url} \
  ${webApp_assets_directory_absolute} \
  ${thumbnails_directory} \
  ${webApp_igv_directory_relative} \
  ${createScreenshots_assets_directory_relative} \
  ${createScreenshots_assets_directory_absolute}

kill $(pgrep -f "${server}")

clean_up_createScreenshots_assets_directory
