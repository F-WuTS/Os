#!/usr/bin/env python3

from subprocess import check_output, call

bot_id = "bot"

for i2c in range(4):
	bot_id += check_output("i2cget -y 0 0x50 0x4%i" % i2c, shell=True).decode()[-2]

new_hosts_content = ""

for line in open("/etc/hosts", "r").read().split("\n"):
	if line.startswith("127.0.1.1"):
		new_hosts_content += "127.0.1.1\t%s\n" % bot_id
	elif line != "":
		new_hosts_content += "%s\n" % line

open("/etc/hosts", "w").write(new_hosts_content)

call("hostnamectl set-hostname %s" % bot_id, shell=True)
call("systemctl restart avahi-daemon", shell=True)

print("Hostname set: '%s'" % bot_id)
