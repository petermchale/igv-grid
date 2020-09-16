# igv-grid

Create snapshots of [igv.js](https://github.com/igvteam/igv.js/) visualizations of genomic variants and view those thumbnails next to one another in an interactive, responsive web app.

## Demo 

https://igv-grid.surge.sh/

## Applications 

The app was developed to expedite the visual identification of features that differentiate true-positive from false-positive variant calls, such as soft-clipped reads and local sequence context. 

Aside from methods development, other possible applications may include: 
* *Sample quality control*: identify samples that harbor unusual alignments
* *Caller benchmarking*: quick visual comparison of the calls made by a set of variant callers
* *Collaborative variant interrogation*: share a set of variants with colleagues for manual review

## Installation

Use python 3, e.g.,: 
```
conda create -n igv-grid python=3
conda activate igv-grid
```

Then download this repo: 
```
git clone https://github.com/petermchale/igv-grid
```

Then execute: 
```
cd igv-grid
./set-up.sh 
```

Installation successfully tested on Darwin x86_64 and Linux x86_64. 

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

Another parameter in `create-screenshots--build-webapp.sh`, named `headless_browser_wait_time`, represents the length of time `puppeteer` will wait before taking a screenshot. I've occasionally needed to set this as large as 60000 (1min). 

## Acknowledgements

Web app based upon [Travis Horn's article](https://travishorn.com/creating-a-photo-gallery-with-vue-css-grid-3e0a3dd25285).

