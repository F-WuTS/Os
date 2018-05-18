# 0s

*Preferred OS*: Debian 9 "Stretch"

```bash
# Installs required packages on host
make setup
# Builds all necessary components and creates an image file (0s.img). 
make build
```

## Notes
* Debian build process is *very* slow?  
    [Performance issue with qemu-arm-static](https://lists.nongnu.org/archive/html/qemu-devel/2017-12/msg05236.html). This should hopefully be fixed once Debian 10 rolls around, but in the very unlikely case that it is not, I'd recommend grabbing an old version of qemu-arm-static ([2.8](https://packages.debian.org/en/stretch/qemu-user-static) is not affected).

* Upgrading to Debian 10 should be relatively straight forward, however [packaging the KIPR software stack](https://github.com/F-WuTS/kipr-packages-deb) for a new release could pose problematic. **Consider this a warning.**

* **Do not** attempt to upgrade the Linux kernel.  
	The [Gumstix fork](https://github.com/gumstix/linux) of the Linux kernel (specifically the yocto-v3.18.y release) is heavily modified to run on their hardware. You **will** go nuts if you try to switch to a newer version.

* When in doubt: Use an old GCC version  
	Linux utilizes compiler specific hacks, which [older version](https://github.com/gumstix/linux/blob/yocto-v3.18.y/include/linux/compiler-gcc5.h) obviously do not include. Upgrading to [GCC 6](https://github.com/F-WuTS/wallaby-linux/blob/899f4f2d6dfb486b67853fbb4671856ca5815d2e/include/linux/compiler-gcc6.h) does work, but as far as I'm concerned it is not possible to easily back-port the GCC 7 hacks. 

* [sfdisk](https://linux.die.net/man/8/sfdisk) was upgraded quite some time ago and its user interface changed significantly. Current versions do not provide all required flags to successfully create a working image, therefor an old version is used.

* Corrupt files?  
	`git lfs install && git lfs pull`

* Running out of disk space?  
	I'd recommend at least `20GB` of spare storage.

* WiFi is constantly disconnecting!
	[This *should* hopefully be resolved](https://github.com/F-WuTS/0s/blob/master/root-fs/etc/modprobe.d/8192cu.conf).  
	If it still isn't: Write a program that executes `systemctl restart networking` with root permissions.

* My screen if flipped!  
	[Uncomment the rotate option.](https://github.com/F-WuTS/0s/blob/master/root-fs/usr/share/X11/xorg.conf.d/20-display.conf)

* I want to make changes to the root overlay-fs!
	Be aware that permissions are ignored entirely and everything will be owned by root once copied.

* Is this entirely blob-free?  
	No, U-Boot as well as certain `.dtb` files are included.

* I want to test stuff! 
	```bash
	./combine.sh
	cd build
	# Probably only works on systemd based Linux distributions
	sudo systemd-nspawn -b -D debian
	```

* What the hell are chroot stages?  
	1. Runs the final `debootstrap` stage inside the chroot.  
		Is cached across Debian builds to slightly increase iteration speed.
	2. Should only perform idempotent changes.  
		Stuff like `apt-get`.  
		Should probably be cacheable too, haven't gotten around to that. 
	3. Can perform non-idempotent changes.  
		Should not be cacheable.

* I want to connect to an access point!  
	Add the access point to `/etc/wpa_supplicant/wpa_supplicant.conf` and learn how to Google™ stuff.

* Why is this taking so long?  
	Execute this on a beefy machine with a fast internet connection and it won't take longer than 30 minutes.

* What is the default root password?  
	`wallaby`

* Why is login as root over SSH enabled?  
	The KIPR software stack basically requires root privileges to do anything useful, therefor all security concerns are thrown out of the window. Still, consider changing the root password.

* I want to disable `<insert-service-here>`!  
	```bash
	# Look for unwanted service (for example c0re.service)
	systemctl list-unit-files
	# Disable and mask it
	systemctl disable <service>
	systemctl mask <service>

* I want to publish packages in the F-WuTS repository!  
	Contact either [Daniel Swoboda](https://twitter.com/snoato) or [Philip Trauner](https://twitter.com/PhilipTrauner) to obtain the PGP signing key.

* Why doesn't the F-WuTS package repository use LFS?  
	Packages were corrupting left and right, don't really know why.

* `botui` is crashing!  
	KIPRs fault ¯\\_(ツ)_/¯

* `harrogate` is not working properly!  
	* CTRL-S/CMD-S doesn't work properly  
		Buy a Mac

* The servo ports do not work properly!
	Hardware issue.

* 0s build is failing!
	* Delete `build` folder and try again.
	* Weird `apt-get` errors  
		MITs PGP key-server might be down. Try again later.

* How does a successful build look?  
	[Screencast](https://asciinema.org/a/175222)

* Booting takes *waaay* longer than it does on the original Wallaby OS  
	Debian handles WiFi setup during the boot process, while the original Wallaby OS does not. 

* `E: Sub-process /usr/bin/dpkg returned an error code (1)`  
	Just re-run the build, don't really know why that happens sometimes.

* I want to make changes to 0s!  
	Cool, be aware that applying them on all Wallaby controllers is a major pain in the butt. Consider publishing a package in the F-WuTS repository instead.

* What am I supposed to do with `0s.img`?  
	😒
