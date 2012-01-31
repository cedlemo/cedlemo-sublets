# -*- encoding: utf-8 -*-
# Cpubar specification file
# Created with sur-0.2
Sur::Specification.new do |s|
  # Sublet information
  s.name        = "Cpubar"
  s.version     = "1.0"
  s.tags        = [ "Cpu", "Bar", "Color"]
  s.files       = [ "cpubar.rb" ]
  s.icons       = [ ]

  # Sublet description
  s.description = "Show an ascii bar of cpu usage with dynamic coloration"
  s.notes       = <<NOTES
LONG DESCRIPTION
NOTES

  # Sublet authors
  s.authors     = [ "cedlemo" ]
  s.contact     = "cedlemo@gmx.com"
  s.date        = "Tue Jan 31 12:43 CET 2012"

  # Sublet config
  s.config = [
    {
      :name        => "interval",
      :type        => "integer",
      :description => "Interval in seconds between each value update",
      :def_value   => "1"
    }
    {
      :name        => "low_value_color",
      :type        => "string",
      :description => "Color for value in range [0,limit_1]",
      :def_value   => "#93d44f"
    }
    {
      :name        => "medium_value_color",
      :type        => "string",
      :description => "Color for value in range ]limit_1,limit_2]",
      :def_value   => "#d4aa00"
    }
    {
      :name        => "hight_value_color",
      :type        => "string",
      :description => "Color for value in range ]limit_2,100]",
      :def_value   => "#d45500"
    }
    {
      :name        => "normal_color",
      :type        => "string",
      :description => "Color for normal characters",
      :def_value   => "#757575"
    }
    {
      :name        => "ascii_drawing",
      :type        => "string",
      :description => "Color for ascii characters used for decoration",
      :def_value   => "#757575"
    }
    {
      :name        => "ascii_background",
      :type        => "string",
      :description => "Color for non used ascii characters in the bar",
      :def_value   => "#757575"
    }
    {
      :name        => "bar",
      :type        => "string",
      :description => "Pattern used in the bar",
      :def_value   => ":"
    }
]


  # Sublet grabs
  #s.grabs = {
  #  :CpubarGrab => "Sublet grab"
  #}

  # Sublet requirements
  # s.required_version = "0.9.2127"
  # s.add_dependency("subtle", "~> 0.1.2")
end
