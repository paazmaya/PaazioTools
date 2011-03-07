
# Encoding script for HD720 video which comes from Panasonic digital camera.

ls *.mov | while read file; do
        echo $file
        ffmpeg -i "$file" -vcodec libx264 -vtag avc1 -f h264 -vb 6000k -maxrate 7200k -bufsize 12M -an -r 30 -flags2 dct8x8 -pass 1 -passlogfile "$file"\.pass /dev/null
        ffmpeg -i "$file" -vcodec libx264 -vtag avc1 -f h264 -vb 6000k -maxrate 7200k -bufsize 12M -an -r 30 -flags2 dct8x8 -pass 2 -passlogfile "$file"\.pass "$file"\.264
        ffmpeg -i "$file" -aq 99 -acodec libfaac -vn "$file"\.aac
	MP4Box -inter 100 -lang FIN -tight -add "$file"\.264 -add "$file"\.aac -fps 30 -tmp D:\ -new "$file"\.mp4
done
