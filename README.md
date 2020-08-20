## Install 

```
# TODO: install npm
chmod u+x install.sh
./install.sh 
```

## Customize 

Alter `reference.json`, `tracks.json` and `callSets.json` to suit your needs. 

Set `port` and `number_thumbnails` (number of thumbnails per call set) in `create-screenshots.sh`.

## Run  

1. Create thumbnails (this may take some time):

```
chmod u+x create-screenshots.sh
./create-screenshots.sh
```

2. Visualize thumbnails in web app:
```
chmod u+x web-app.sh
./web-app.sh
```

## TODOs

See `create-screenshots/createThumbnails.js`

## Acknowledgements

web-app based upon https://travishorn.com/creating-a-photo-gallery-with-vue-css-grid-3e0a3dd25285

