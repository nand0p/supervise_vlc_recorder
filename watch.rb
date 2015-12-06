#!/usr/bin/ruby

resolution = 0
cameras = eval(File.open(File.expand_path('load_camera_hash.rb')).read)

cameras.each do | camera, ip |
  vlc_cmd = "vlc rtsp://#{ip}/#{resolution}?tcp &"
  system(vlc_cmd)
end
