port="9000" 
number_thumbnails="50"
slop="250"

cd create-screenshots
chmod u+x ./createThumbnails.sh
./createThumbnails.sh ${port} ${number_thumbnails} ${slop}

