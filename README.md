## Set up

```
./set-up.sh 
```

## Customize 

Drop a reference genome into `data` and change the corresponding entries in `reference.json`. 

Alter `tracks.json` and drop corresponding files into `data`. 

Alter `callSets.json` and drop corresponding files into `data`. 

Customize `port` and `number_thumbnails` (number of thumbnails per call set) in `create-screenshots.sh`.

## Run  

Create thumbnails:

```
./create-screenshots.sh
```

Start web app:
```
./web-app.sh
```
From your local computer, do (change username and host):
```
ssh -N -L localhost:8080:localhost:8080 u6018199@hunnicutt.chpc.utah.edu
```
and visit `localhost:8080` in your web browser. 

## TODOs

See `TODO`s in `create-screenshots/createThumbnails.js`

## Acknowledgements

Web app based upon [Travis Horn's article](https://travishorn.com/creating-a-photo-gallery-with-vue-css-grid-3e0a3dd25285).

