# Cpubar sublet file
# Created with sur-0.2
configure :cpubar do |s|
  s.interval = s.config[:interval] || 1
  s.cpus     = 0
  s.last     = []
  s.delta    = []
  s.sum      = []

  s.low_value_color =     Subtlext::Color.new(s.config[:low_value_color] || "#93d44f")
  s.medium_value_color =  Subtlext::Color.new(s.config[:medium_value_color] || "#d4aa00")
  s.hight_value_color =   Subtlext::Color.new(s.config[:hight_value_color] || "#d45500")
  s.normal_color =        Subtlext::Color.new(s.config[:normal_color] || "#757575")
  s.ascii_drawing =       Subtlext::Color.new(s.config[:ascii_drawing] || "#757575")   
  s.ascii_background =    Subtlext::Color.new(s.config[:ascii_background] || "#000000")
  s.bar=s.config[:bar] || ":"
  
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
    data = 0
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
      percent   = (use * 100.0).ceil % 100.0
      data = data + percent
    end
    nb_indicators=20
    average_percent = (data / (s.cpus)*1.00)
    nb_bars=0
    if average_percent == 0
      nb_bars = 0
    else
      0.step(100,5) do |x|
        if average_percent.ceil >= x and average_percent.ceil < x + 5
          nb_bars = (x + 5) / 5
        end
      end
    end
    case nb_bars
    when 1..7
      s.data = s.ascii_drawing +  "[" + s.low_value_color    + s.bar*nb_bars + s.ascii_background + s.bar*(20 -nb_bars) + s.normal_color  + sprintf("%5s",average_percent.to_s ) + "%" + s.ascii_drawing + "]"  
    when 8..14
      s.data = s.ascii_drawing +  "[" + s.medium_value_color + s.bar*nb_bars + s.ascii_background + s.bar*(20 -nb_bars) + s.normal_color + sprintf("%5s",average_percent.to_s ) + "%" + s.ascii_drawing + "]"  
    when 15..20
      s.data =  s.ascii_drawing + "[" + s.hight_value_color  + s.bar*nb_bars + s.ascii_background + s.bar*(20 -nb_bars) + s.normal_color + sprintf("%5s",average_percent.to_s ) + "%" + s.ascii_drawing + "]"  
    else
      s.data =  s.ascii_drawing + "[" + s.ascii_background + s.bar*(20) + s.normal_color + sprintf("%5s",average_percent.to_s ) + "%" + s.ascii_drawing + "]"  
    end
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end  
end
