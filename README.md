## Demo

https://igv-grid.surge.sh/

## Installation

Use python 3, e.g.,: 
```
conda create -n igv-grid python=3
conda activate igv-grid
```

Download this repo: 
```
git clone https://github.com/petermchale/igv-grid
```

Then run: 
```
./set-up.sh 
```

## Usage  

Create thumbnails:

```
./create-screenshots--build-webapp.sh
```

Start web app:
```
./launch-web-app.sh
```
From your local computer, do (change username and host):
```
ssh -N -L localhost:8080:localhost:8080 u6018199@hunnicutt.chpc.utah.edu
```
and visit `localhost:8080` in your web browser. 

## Customize 

Alter `tracks.json` and `callSets.json` to point to the data you want to visualize. Customize `number_thumbnails` (number of thumbnails per call set) in `create-screenshots--build-webapp.sh`.

## Acknowledgements

Web app based upon [Travis Horn's article](https://travishorn.com/creating-a-photo-gallery-with-vue-css-grid-3e0a3dd25285).

