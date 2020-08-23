port="1000" 

npm run build
cp -r public/igv dist
# node ~/igv-grid/create-screenshots/node_modules/http-server/bin/http-server
serve --single --symlinks --listen ${port} dist
