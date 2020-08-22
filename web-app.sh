root_directory="$PWD"
# no need to export PATH since it is already in the environment: https://unix.stackexchange.com/a/26059/406037
PATH="${root_directory}/node/bin:$PATH"

cd web-app 
which node 
echo $PATH
exit 1
npm run serve

