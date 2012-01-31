# Memorycolored sublet file
# Created with sur-0.2
configure :memorycolored do |s|
  s.interval = 5 
  s.icon     = Subtlext::Icon.new("memorycolored.xbm")
  s.low_value_color =     Subtlext::Color.new(s.config[:low_value_color] || "#93d44f")
  s.medium_value_color =  Subtlext::Color.new(s.config[:medium_value_color] || "#d4aa00")
  s.hight_value_color =   Subtlext::Color.new(s.config[:hight_value_color] || "#d45500")
  s.normal_color =        Subtlext::Color.new(s.config[:normal_color] || "#757575")
  s.ascii_drawing =       Subtlext::Color.new(s.config[:ascii_drawing] || "#757575")   
end

on :run do |s|
  file = ""

  begin
    File.open("/proc/meminfo", "r") do |f|
      file = f.read
    end

    # Collect data
    total   = file.match(/MemTotal:\s*(\d+)\s*kB/)[1].to_i || 0
    free    = file.match(/MemFree:\s*(\d+)\s*kB/)[1].to_i || 0
    buffers = file.match(/Buffers:\s*(\d+)\s*kB/)[1].to_i || 0
    cached  = file.match(/Cached:\s*(\d+)\s*kB/)[1].to_i || 0

    used    = (total - (free + buffers + cached)) / 1024
    total   = total / 1024
    percent = (used / total )*100
    
    #s.data="itoto"
    case percent.ceil
    when 0..25
      s.data = s.ascii_drawing + "[" + s.icon + "]-[" + s.low_value_color + used.to_s + s.normal_color + "/" + total.to_s + s.ascii_drawing + "]"
    when 26..60
      s.data = s.ascii_drawing + "[" + s.icon + "]-[" + s.medium_value_color + used.to_s + s.normal_color + "/" + total.to_s + s.ascii_drawing +  "]"
    when 61..100
      s.data = s.ascii_drawing + "[" + s.icon + "]-[" + s.hight_value_color + used.to_s + s.normal_color + "/" + total.to_s + s.ascii_drawing + "]"
    end
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end
