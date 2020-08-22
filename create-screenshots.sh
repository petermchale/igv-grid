port="9000" 
number_thumbnails="2"
slop="250"

root_directory="$PWD"
PATH="${root_directory}/node/bin:$PATH" 
# export PATH

cd create-screenshots
./createThumbnails.sh ${port} ${number_thumbnails} ${slop}
