## Set up

```
chmod u+x set-up.sh
./set-up.sh 
```

## Customize 

Alter `reference.json`, `tracks.json` and `callSets.json` to suit your needs. 

Set `port` and `number_thumbnails` (number of thumbnails per call set) in `create-screenshots.sh`.

## Run  

1. Create thumbnails (this may take some time):

```
./create-screenshots.sh
```

2. Visualize thumbnails in web app:
```
./web-app.sh
```
Then, from your local computer, do (change username and host):
```
ssh -N -L localhost:8080:localhost:8080 u6018199@hunnicutt.chpc.utah.edu
```

## TODOs

See `TODO`s in `create-screenshots/createThumbnails.js`

## Acknowledgements

Web app based upon [Travis Horn's article](https://travishorn.com/creating-a-photo-gallery-with-vue-css-grid-3e0a3dd25285).

