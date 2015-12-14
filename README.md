# supervise_vlc_recorder

> ruby make_record_cameras.rb

- generates supervisord configuration via erb template

- generates vlc camera capture shell wrappers via erb template

- launches supervisord to begin recording camera feeds

- uses environment vars to define cameras
  - CAMERA_1_NAME
  - CAMERA_1_IP
  - CAMERA_2_NAME
  - CAMERA_2_IP
  - [etc]
