# HLS Video Transcoder: Stream Your Videos Anywhere
This project allows you to easily transcode your local video files into a format compatible with HLS (HTTP Live Streaming). This enables smooth streaming of your videos across various platforms and devices.

# High-Level Architecture

![High Level Design](/media/hld.png)

# Demo: Efficient Video Streaming

The included video demonstrates how our application streams videos efficiently. You'll see how it loads only the relevant segments based on the user's playback position. Additionally, switching video quality triggers segment reloading and adapts the file size accordingly.


# Want to run this project?

## Prerequisite
To run this project, you'll need:

- Docker installed
- An MP4 video file in videos folder named sample.mp4

## Steps to follow 

- Clone the repository: `git clone https://github.com/Sumit0709/local-video-transcoding.git`
- Navigate to the project directory
- Build the docker image: `docker build -t hls-video-transcoder .`
- Run the docker container:

```
docker run -it -v <local folder containing videos>:/home/app/videos \
-e AWS_ACCESS_KEY_ID=Your_AWS_Access_Key \
-e AWS_SECRET_ACCESS_KEY=Your_AWS_Secret_Access_key \
hls-video-transcoder
```

## Note:

- Replace <your_local_video_folder> with the actual path to your folder containing video files.
- Ensure your AWS user has the necessary permissions to upload videos to your S3 bucket.

### Your video will be transcoded and uploaded into your s3 bucket.