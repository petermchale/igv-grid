# igv-grid

Create snapshots of [igv.js](https://github.com/igvteam/igv.js/) visualizations of genomic variants and view those thumbnails next to one another in an interactive, responsive web app.

## Demo 

https://igv-grid.surge.sh/

## Applications 

The app was developed to expedite the visual identification of features that differentiate true-positive from false-positive variant calls, such as soft-clipped reads and local sequence context. 

Aside from methods development, other possible applications may include: 
* Quality control: identify samples that harbor unusual alignments
* Benchmarking methods: quick visual comparison of the calls made by a set of variant callers

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
cd igv-grid
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
Visit `localhost:8080` in your web browser. 

If the software is run on a remote machine, then you can view the web-app on a local machine by doing the following from the local machine (change username and host first):
```
ssh -N -L localhost:8080:localhost:8080 username@host
```

## Customize 

Alter `tracks.json` and `callSets.json` to point to the data you want to visualize. Customize `number_thumbnails` (number of thumbnails per call set) in `create-screenshots--build-webapp.sh`.

## Acknowledgements

Web app based upon [Travis Horn's article](https://travishorn.com/creating-a-photo-gallery-with-vue-css-grid-3e0a3dd25285).

