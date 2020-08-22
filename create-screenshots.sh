port="9000" 
number_thumbnails="2"
slop="250"

root_directory="$PWD"
# no need to export PATH since it is already in the environment: https://unix.stackexchange.com/a/26059/406037
PATH="${root_directory}/node/bin:$PATH" 

cd create-screenshots
./createThumbnails.sh ${port} ${number_thumbnails} ${slop}
