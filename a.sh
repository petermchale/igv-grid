set -x 

port="1000" 

root_directory="$PWD"
# no need to export PATH since it is already in the environment: https://unix.stackexchange.com/a/26059/406037
PATH="${root_directory}/node/bin:$PATH"

cd web-app

npm run build
cp -r public/igv dist
# node ~/igv-grid/create-screenshots/node_modules/http-server/bin/http-server
npx serve --single --symlinks --listen ${port} dist
