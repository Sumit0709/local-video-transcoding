#!/bin/bash
uuid=$(shuf -i 1000-9999 -n 1)
mkdir -p "/home/app/videos/outputs/video_${uuid}"

master_playlist="#EXTM3U\n"  # Initialize empty master playlist
master_file_path="/home/app/videos/outputs/video_${uuid}"

# Function to transcode a video to a specific resolution
transcode_video() {
local resolution="$1"
local input_file="$2"
local output_file="/home/app/videos/outputs/video_${uuid}/${resolution}"

local aws_file_location="uploads/video_${uuid}/${resolution}"

mkdir -p "/home/app/videos/outputs/video_${uuid}/${resolution}"

# Define ffmpeg command with scaling filter for each resolution
case $resolution in
    360p)
    ffmpeg -i "$input_file" -vf scale=640:360 -codec:v libx264 -codec:a aac -hls_time 10 -hls_playlist_type vod -hls_segment_filename "${output_file}/segment%03d.ts" -start_number 0 "${output_file}/index.m3u8"
    ;;
    480p)
    ffmpeg -i "$input_file" -vf scale=854:480 -codec:v libx264 -codec:a aac -hls_time 10 -hls_playlist_type vod -hls_segment_filename "${output_file}/segment%03d.ts" -start_number 0 "${output_file}/index.m3u8"
    ;;
    720p)
    ffmpeg -i "$input_file" -vf scale=1280:720 -codec:v libx264 -codec:a aac -hls_time 10 -hls_playlist_type vod -hls_segment_filename "${output_file}/segment%03d.ts" -start_number 0 "${output_file}/index.m3u8"
    ;;
    1080p)
    ffmpeg -i "$input_file" -vf scale=1920:1080 -codec:v libx264 -codec:a aac -hls_time 10 -hls_playlist_type vod -hls_segment_filename "${output_file}/segment%03d.ts" -start_number 0 "${output_file}/index.m3u8"
    ;;
esac

# Add reference to the playlist in the master playlist
master_playlist+="\n#EXT-X-STREAM-INF:BANDWIDTH=AUTO,RESOLUTION=$resolution\n"
master_playlist+="${resolution}/index.m3u8\n"

# Upload the transcoded video to S3
aws s3 cp --recursive "$output_file" s3://your-s3-bucket-name/"${aws_file_location}"

# Clean up temporary file
# rm -r -f "$output_file"
}

# Get input file from mounted volume (replace /data with your volume path)
input_file="/home/app/videos/sample.mkv"

# Transcode to all resolutions
transcode_video 360p "$input_file"
transcode_video 480p "$input_file"
transcode_video 720p "$input_file"
transcode_video 1080p "$input_file"

# Write master playlist to file
echo -e "$master_playlist" > "${master_file_path}/master.m3u8"  # Write to a file inside the final output directory


aws s3 cp "${master_file_path}/master.m3u8" s3://your-s3-bucket-name/uploads/video_"${uuid}"/master.m3u8

# Clean up temporary file
rm -r -f "${master_file_path}/master.m3u8"

echo "Transcoding complete!"
