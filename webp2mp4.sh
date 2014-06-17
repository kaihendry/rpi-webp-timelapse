test -d "$1" || exit
tmpdir=$(mktemp -d -p .)
counter=0
find $1 -iname '*.webp' | sort | while read webp
do
	test -s "$webp" || continue
	cp $webp $tmpdir/IMG_$(printf "%04d" $counter).webp
	counter=$((counter + 1))
done
command=( ffmpeg -i $tmpdir/IMG_%4d.webp
		# H264 at http://en.wikipedia.org/wiki/1080p
		# 1.333 aspect ratio to match rpi camera: 2592 x 1944
		-s 1440x1080

		# These options failed to playback
		# http://ffmpeg.org/ffmpeg-filters.html#scale
		#-c:v libx264 -vf scale=1920:-2

		# https://trac.ffmpeg.org/wiki/Encode/H.264#iOS
		-profile:v high -level 4.2

		# quality
		#-crf 20

		# Makes mp4 "streamable", so it starts quickly
		-movflags +faststart

		# Use dir for filename by default
		${2:-$(basename $1)}.mp4 )

${command[@]}

rm -rf $tmpdir
