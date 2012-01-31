# Memorybar sublet file
# Created with sur-0.2
configure :memorybar do |s|
  s.interval = s.config[:interval] || 1
  s.low_value_color =     Subtlext::Color.new(s.config[:low_value_color] || "#93d44f")
  s.medium_value_color =  Subtlext::Color.new(s.config[:medium_value_color] || "#d4aa00")
  s.hight_value_color =   Subtlext::Color.new(s.config[:hight_value_color] || "#d45500")
  s.normal_color =        Subtlext::Color.new(s.config[:normal_color] || "#757575")
  s.ascii_drawing =       Subtlext::Color.new(s.config[:ascii_drawing] || "#757575")   
  s.ascii_background =    Subtlext::Color.new(s.config[:ascii_background] || "#000000")
  s.bar=s.config[:bar] || ":"
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
    percent = (used / (total*1.0))*100.0
    #dirty hack for having only 2 digits
    percent = (percent*100).ceil
    percent = percent / 100.0
    nb_indicators=20
    nb_bars=0
    if percent == 0
      nb_bars = 0
    else
      0.step(100,5) do |x|
        if percent.ceil >= x and percent.ceil < x + 5
          nb_bars = (x + 5) / 5
        end
      end
    end
    case nb_bars
    when 1..7
      s.data = s.ascii_drawing + "[" + s.low_value_color    + s.bar*nb_bars + s.ascii_background + s.bar*(20 -nb_bars) + s.normal_color  + sprintf("%5s",percent.to_s ) + "%" + s.ascii_drawing + "]" 
    when 8..14
      s.data = s.ascii_drawing + "[" + s.medium_value_color + s.bar*nb_bars + s.ascii_background + s.bar*(20 -nb_bars) + s.normal_color + sprintf("%5s",percent.to_s ) + "%"  + s.ascii_drawing + "]" 
    when 15..20
      s.data = s.ascii_drawing + "[" + s.hight_value_color  + s.bar*nb_bars + s.ascii_background + s.bar*(20 -nb_bars) + s.normal_color + sprintf("%5s",percent.to_s ) + "%" + s.ascii_drawing + "]"
    else
      s.data = s.ascii_drawing + "[" + s.ascii_background + s.bar*(20) + s.normal_color + sprintf("%5s",percent.to_s ) + "%" + s.ascii_drawing + "]"
    end

  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end
