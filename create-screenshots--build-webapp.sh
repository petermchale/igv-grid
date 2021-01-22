#!/usr/bin/env bash
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=10g # sacct -o reqmem,maxrss,averss,elapsed -j JOBID
#SBATCH --account=redwood-gpu
#SBATCH --partition=redwood-gpu

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace
PS4='+ (${BASH_SOURCE[0]##*/} @ ${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

port="9000" 
number_thumbnails="20"
variant_slop="750"
headless_browser_wait_time="10000"

root_directory="$PWD"
# no need to export PATH since it is already in the environment: https://unix.stackexchange.com/a/26059/406037
PATH="${root_directory}/node/bin:$PATH" 

cd ${root_directory}/create-screenshots
./createThumbnails.sh ${port} ${number_thumbnails} ${variant_slop} ${headless_browser_wait_time}

webApp_directory_absolute="${root_directory}/web-app"
ln --force --symbolic ${root_directory}/reference.json "${webApp_directory_absolute}/src/assets"
cd ${webApp_directory_absolute}
npm run build
mv igv dist
