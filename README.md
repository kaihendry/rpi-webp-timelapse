# rpi security camera scripts

I'm leveraging Archlinux-Arm, hence systemd is used to maintain services.

* camera.service is very stupid and assumes snapshot.sh takes a few seconds, which it does. This currently generates about 1GB of compressed data a day.

* snapshot.sh - I'm using the WEBP image format since it keeps file sizes low.

* httpd - [darkhttpd](http://unix4lyfe.org/darkhttpd/) seems like the sanest httpd on Archlinux

Thought: `python -m http.server` might be saner/easier.

However it needs some extramime information to serve the webp with the correct content type.

* webp2mp4.sh - turns WEBP into an MP4, demo: <http://mp4.dabase.com/2014-06-14-2.mp4>

## How I move WEBP images off the rpi camera

On another machine which has more disk space, there is a cronjob:

	@hourly flock -o -n /tmp -c "rsync --remove-source-files -ar rpicam:camera/2* /mnt/huge-disk-store"

## TODO

* reduce data to interesting bits
	* investigate image diff tools like pdiff

Be cool if we could serve a live video stream so that it always shows the
latest image. Manually reloading the browser sucks.
