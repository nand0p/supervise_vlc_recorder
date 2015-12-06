#!/usr/bin/ruby

require 'erb'
include ERB::Util

supd_home = '/var/backup/cameras'
supd_conf_file = 'supervisord.conf'
supd_conf_template = 'supervisord.conf.erb'
supd_prog_template = 'supervisord.program.sh.erb'
supd_prog_prefix = '000-'
supd_exec = "supervisord -c #{supd_conf_file}"
supd_sock = "#{supd_home}/supervisord.sock"
supd_pid = "#{supd_home}/supervisord.pid"
supd_log = "#{supd_home}/supervisord.log"
data_dir = "#{supd_home}/data"
resolution = 4
cycle_time = 3600

cameras = eval(File.open(File.expand_path('load_camera_hash.rb')).read)
cameras ||=
  Hash[ 'camera-1' => "10.0.0.1",
        'camera-2' => "10.0.0.2",
        'camera-3' => "10.0.0.3",

class MakeSupdConf
  def initialize(cameras, template, supd_home, supd_prog_prefix, supd_sock, supd_pid, supd_log)
    @cameras = cameras
    @template = template
    @supd_home = supd_home
    @supd_prog_prefix = supd_prog_prefix
    @supd_sock = supd_sock
    @supd_pid = supd_pid
    @supd_log = supd_log
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def save(file)
    File.open(file, "w+") do |tmplout|
      tmplout.write(render)
    end
  end
end

class MakeSupdProg
  def initialize(ip, camera, template, supd_home, resolution, cycle_time, data_dir)
    @ip = ip
    @camera = camera
    @template = template
    @supd_home = supd_home
    @resolution = resolution
    @cycle_time = cycle_time
    @data_dir = data_dir
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def save(file)
    File.open(file, "w+") do |tmplout|
      tmplout.write(render)
    end
  end
end


supd_conf = MakeSupdConf.new(cameras, File.read(supd_conf_template), supd_home, supd_prog_prefix, supd_sock, supd_pid, supd_log)
supd_conf.save(supd_conf_file)
Dir.mkdir(data_dir) unless Dir.exist?(data_dir)

cameras.each do | camera, ip | 
  camera_data_dir = "#{data_dir}/#{camera}"
  Dir.mkdir(camera_data_dir) unless Dir.exist?(camera_data_dir)
  supd_prog = MakeSupdProg.new(ip, camera, File.read(supd_prog_template), supd_home, resolution, cycle_time, data_dir)
  supd_prog.save("#{supd_prog_prefix}#{camera}.sh")
  File.chmod(0700, "#{supd_prog_prefix}#{camera}.sh")
end

system(supd_exec)
