# Cpucolored sublet file
# Created with sur-0.2
configure :cpucolored do |s|
  s.interval = 1
  s.cpus     = 0
  s.last     = []
  s.delta    = []
  s.sum      = []
  s.icon     = Subtlext::Icon.new("cpucolored.xbm")

  s.low_value_color =     Subtlext::Color.new(s.config[:low_value_color] || "#93d44f")
  s.medium_value_color =  Subtlext::Color.new(s.config[:medium_value_color] || "#d4aa00")
  s.hight_value_color =   Subtlext::Color.new(s.config[:hight_value_color] || "#d45500")
  s.percent_color =       Subtlext::Color.new(s.config[:percent_color] || "#757575")
  s.ascii_drawing =       Subtlext::Color.new(s.config[:ascii_drawing] || "#757575")   
  # Init and count CPUs
  begin
    file = IO.readlines("/proc/stat").join

    file.scan(/cpu(\d+)/) do |num| 
      n           = num.first.to_i
      s.cpus     += 1
      s.last[n]   = 0
      s.delta[n]  = 0
      s.sum[n]    = 0
    end
  rescue
    raise "Init error"
  end
end

on :run do |s|
  begin
    data = ""
    time = Time.now.to_i
    file = IO.readlines("/proc/stat").join

    file.scan(/cpu(\d+) (\d+) (\d+) (\d+)/) do |num, user, nice, system| 
      n          = num.to_i
      s.delta[n] = time - s.last[n]
      s.delta[n] = 1 if(0 == s.delta[n])
      s.last[n]  = time

      sum       = user.to_i + nice.to_i + system.to_i
      use       = ((sum - s.sum[n]) / s.delta[n] / 100.0)
      s.sum[n]  = sum
      percent   = (use * 100.0).ceil % 100
      case percent
      when 0..25
        data << s.low_value_color + sprintf("%-3s",percent.to_s) + s.percent_color + "% "
      when 26..60
        data << s.medium_value_color + sprintf("%-3s",percent.to_s) + s.percent_color + "% "
      when 61..100
        data << s.hight_value_color + sprintf("%-3s",percent.to_s) + s.percent_color + "% "
      end
    end

    s.data =  s.ascii_drawing + "[" + s.icon + "]-[" + data.chop +  s.ascii_drawing + "]"
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end  
end
