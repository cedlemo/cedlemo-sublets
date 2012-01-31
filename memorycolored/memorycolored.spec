# -*- encoding: utf-8 -*-
# Memorycolored specification file
# Created with sur-0.2
Sur::Specification.new do |s|
  # Sublet information
  s.name        = "Memorycolored"
  s.version     = "1.0"
  s.tags        = [ "Mem", "Icon", "Color" ]
  s.files       = [ "memorycolored.rb" ]
  s.icons       = [ "icons/memorycolored.xbm" ]

  # Sublet description
  s.description = "Show used and total memory with dynamic colors"
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
      :description => "Color for normal caracters",
      :def_value   => "#757575"
    }
    {
      :name        => "ascii_drawing",
      :type        => "string",
      :description => "Color for ascii caracters used for decoration",
      :def_value   => "#757575"
    }
  ]
  # Sublet grabs
  #s.grabs = {
  #  :MemorycoloredGrab => "Sublet grab"
  #}

  # Sublet requirements
  # s.required_version = "0.9.2127"
  # s.add_dependency("subtle", "~> 0.1.2")
end
