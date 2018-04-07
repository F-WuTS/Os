cd ..

mkdir -p root-fs/var/0s/source

cd root-fs/var/0s/source

if [ ! -d c0re ]; then
	git clone https://github.com/F-WuTS/c0re.git --recursive --depth=1
else
	git -C c0re fetch --all
	git -C c0re reset --hard origin/master

fi

if [ ! -d harrogate ]; then
	git clone https://github.com/F-WuTS/harrogate.git --depth=1
else
    git -C harrogate fetch --all
    git -C harrogate reset --hard origin/master

fi


