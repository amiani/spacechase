cd /home/amiani/projects/spacechase/

node /home/amiani/.vscode-oss/extensions/kodetech.kha-19.2.0/Kha/make linux --compile --to build/server --projectfile khafile.server.js
#rm -rf /home/amiani/projects/spacechase/build/linux/server
#mkdir /home/amiani/projects/spacechase/build/linux/server
#cp -r /home/amiani/projects/spacechase/build/linux/* /home/amiani/projects/spacechase/build/linux/server
cd /home/amiani/projects/spacechase/build/server/linux
./spacechase
