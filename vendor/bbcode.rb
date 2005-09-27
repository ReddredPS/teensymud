#--
# BBCode
#
# Copyright (c) 2002 Thomas-Ivo Heinen
#
# Ruby License
#
# This module is free software. You may use, modify, and/or redistribute this
# software under the same terms as Ruby.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.
#
#
# ==========================================================================
# Revision History ::
# --------------------------------------------------------------------------
#  2002-07-16  TH    Bugfix BBCODE=>ANSI, bbcode_to_html, ansi_to_html,
#                    html_to_bbcode, html_to_ansi
#
#  2002-11-11  TH    Comment fixes, more case insensitive matching,
#                    convert deprecated HTML styles (<b>, <i>), more
#                    space-tolerant matching, img-tags in html_to_bbcode
#                    works now, some error-preventing stripping and
#                    downcasing.
# ==========================================================================
#++

#:title: BBCode
#
# This module helps easening the separation of core and frontend with the
# core (or submodules) being still able to say, what colors shall be used
# in it's responses. This is achieved by encoding formatting information
# using the BBCode tokens. This enables you to "pipe" layout information
# such as colors, style, fonttype, size and alignment through the core to
# the frontend.
#
# Additionally it converts markups/codes between ANSI, HTML and BBCode
# almost freely ;)
#
# == Usage
#
#   # Converting a bbcode string to ANSI and XHTML
#
#   require 'mega/bbcode'
#
#   str = "this is [COLOR=red]red[/COLOR], this is [B]bold[/B]"
#   print( BBCode.bbcode_to_ansi(str) )
#   print( BBCode.bbcode_to_html(str) )
#
# == Author(s)
#
# * Thomas-Ivo Heinen
#

module BBCode

  ## ANSIname => ANSIcode LUT
  ANSINAME2CODE= { "reset"     => "\e[0m",    "bold"       => "\e[1m",
                    "underline" => "\e[4m",    "blink"      => "\e[5m",
                    "reverse"   => "\e[7m",    "invisible"  => "\e[8m",
                    "black"     => "\e[0;30m", "darkgrey"   => "\e[1;30m",
                    "red"       => "\e[0;31m", "lightred"   => "\e[1;31m",
                    "green"     => "\e[0;32m", "lightgreen" => "\e[1;32m",
                    "brown"     => "\e[0;33m", "yellow"     => "\e[1;33m",
                    "blue"      => "\e[0;34m", "lightblue"  => "\e[1;34m",
                    "purple"    => "\e[0;35m", "magenta"    => "\e[1;35m",
                    "cyan"      => "\e[1;36m", "lightcyan"  => "\e[1;36m",
                    "grey"      => "\e[0;37m", "white"      => "\e[1;37m",
                    "bgblack"   => "\e[40m",   "bgred"      => "\e[41m",
                    "bggreen"   => "\e[42m",   "bgyellow"   => "\e[43m",
                    "bgblue"    => "\e[44m",   "bgmagenta"  => "\e[45m",
                    "bgcyan"    => "\e[46m",   "bgwhite"    => "\e[47m"
                  }

  ## BBColor => ANSIname LUT
  BBCOLOR2ANSI  = { "skyblue"   => "blue",     "royalblue" => "blue",
                    "blue"      => "blue",     "darkblue"  => "blue",
                    "orange"    => "red",      "orangered" => "red",
                    "crimson"   => "red",      "red"       => "lightred",
                    "firebrick" => "red",      "darkred"   => "red",
                    "green"     => "green",    "limegreen" => "green",
                    "seagreen"  => "green",    "darkgreen" => "green",
                    "deeppink"  => "magenta",  "tomato"    => "red",
                    "coral"     => "cyan",     "purple"    => "purple",
                    "indigo"    => "blue",     "burlywood" => "red",
                    "sandybrown"=> "red",      "sierra"    => "sierra",
                    "chocolate" => "brown",    "teal"      => "teal",
                    "silver"    => "white",
                    "black"     => "black",    "yellow"    => "yellow",
                    "magenta"   => "magenta",  "cyan"      => "cyan",
                    "white"     => "white"
                  }

  ## ANSInames => BBCode LUT
  ANSINAME2BBCODE = { "bold" => "B", "underline" => "U", "reverse" => "I",

                      "red"    => "COLOR=red",      "blue"   => "COLOR=blue",
                      "green"  => "COLOR=green",    "cyan"   => "COLOR=cyan",
                      "magenta"=> "COLOR=deeppink", "purple" => "COLOR=purple",
                      "black"  => "COLOR=black",    "white"  => "COLOR=white",
                      "yellow" => "COLOR=yellow",   "brown"  => "COLOR=chocolate"
                    }

  ## Needed for alignments
  @@width = 80


  # ---------------------------

  # Returns the ANSI sequence for given color, if existant
  def BBCode.ansi(colorname)
      colorname.strip!
      return ANSINAME2CODE[ colorname.downcase ]
  end

  # --- strip_bbcode( string )
  # Will strip any BBCode tags from the given string.
  def BBCode.strip_bbcode(string)
      string.gsub!(/\[COLOR=.*?\]|\[\/COLOR\]/i, "")
      string.gsub!(/\[SIZE=.*?\]|\[\/SIZE\]/i, "")
      string.gsub!(/\[FONT=.*?\]|\[\/FONT\]/i, "")
      string.gsub!(/\[[BUI]\]|\[\/[BUI]\]/i, "")
      return string
  end

  # Returns the string with all ansi escape sequences converted to BBCodes
  def BBCode.ansi_to_bbcode(string)
      return "" if string.nil? || string.to_s.strip.empty?
      result = ""
      tagstack = []

      ## Iterate over input lines
      string.split("\n").each do |line|
          ansi = line.scan(/\e\[[0-9;]+m/)
          continue if ansi.nil? || ansi.empty?

          ## Iterate over found ansi sequences
          ansi.each do |seq|
              ansiname = ANSINAME2CODE.invert["#{seq}"]

              ## Pop last tag and form closing tag
              if ansiname == "reset"
                  lasttag = tagstack.pop
                  bbname = "/" + String.new( lasttag.split("=")[0] )

              ## Get corresponding BBCode tag + Push to stack
              else
                  bbname   = ANSINAME2BBCODE[ansiname]
                  tagstack.push(bbname)
              end

              ## Replace ansi sequence by BBCode tag
              replace = sprintf("[%s]", bbname)
              line.sub!("#{Regexp.quote(seq)}", replace)
          end

          ## Append converted line
          result << sprintf("%s\n", line)
      end


      ## Some tags are unclosed
      while !tagstack.empty?
          result << sprintf("[/%s]", String.new(tagstack.pop.split("=")[0])  )
      end

      return result
  end

  # Converts a BBCode string to one with ANSI sequences.
  # Returns the string with all formatting instructions in BBCodes converted
  # to ANSI code sequences / aligned with spaces to specified width.
  def BBCode.bbcode_to_ansi(string, usecolors = true)
      return "" if string.nil? || string.to_s.strip.empty?
      result = ""

      return BBCode.strip_bbcode(string) if !usecolors

      ## Iterate over lines
      string.split("\n").each do |line|

          ## TODO: stacking? other styles!
          ANSINAME2BBCODE.each do |key,val|
              line.gsub!(/\[#{val}\]/, ANSINAME2CODE[key])
              line.gsub!(/\[\/#{val}\]/, ANSINAME2CODE["reset"])
          end

          ## Fonttypes and sizes not available
          line.gsub!(/\[SIZE=\d\]/, "")
          line.gsub!(/\[\/SIZE\]/, "")
          line.gsub!(/\[FONT=[^\]]*\]/, "")
          line.gsub!(/\[\/FONT\]/, "")

          ## Color-mapping
          colors = line.scan(/\[COLOR=(.*?)\]/i)
          colors = colors.collect{|s|  s[0].to_s} if !colors.nil?
          colors.each do |col|
              name = BBCOLOR2ANSI[col.downcase]
              name = BBCOLOR2ANSI["white"] if name.nil?
              code = ANSINAME2CODE[name]

              line.gsub!(/\[COLOR=#{col}\]/i, code)
          end
          line.gsub!(/\[\/COLOR\]/, ANSINAME2CODE["reset"])

          ## TODO: Alignment
          ## TODO: IMGs
          ## TODO: EMAILs
          ## TODO: URLs
          ## TODO: QUOTEs
          ## TODO: LISTs

          result << sprintf("%s\n", line)
      end

      return result
  end


  # Converts a HTML string into one with BBCode markup (TODO)
  # Returns the (X)HTML markup string as BBCode
  def BBCode.html_to_bbcode(string)
      return "" if string.nil? || string.to_s.strip.empty?
      result = ""

      ## Iterate over lines
      string.split(/<br *\/?>/i).each do |line|
          styles = { "strong" => "b", "b" => "b",
                      "em"     => "i", "i" => "i",
                      "u"      => "u" }

          ## preserve B, I, U
          styles.each do |html,code|
              line.gsub!(/<#{html}>/i, "[#{code.upcase}]")
              line.gsub!(/<\/#{html}>/i, "[/#{code.upcase}]")
          end

          ## TODO: COLORs
          ## TODO: SIZEs
          ## TODO: FONTs

          ## EMAIL
          line.gsub!(/<a +href *= *\"mailto:(.*?)\".*?>.*?<\/a>/i, "[EMAIL]\\1[/EMAIL]")

          ## URL
          line.gsub!(/<a +href *= *\"((?:https?|ftp):\/\/.*?)\".*?>(.*?)<\/a>/i, "[URL=\\1]\\2[/URL]")

          ## Other refs + closing tags => throw away
          line.gsub!(/<a +href *= *\".*?\".*?>/i, "")
          line.gsub!(/<\/a>/i,            "")

          ## IMG
          line.gsub!(/<img +src *= *\"(.*?)\".*?\/?>/i, "[IMG=\\1]")

          ## CENTER (right/left??)
          line.gsub!(/<center>/i,   "[ALIGN=center]")
          line.gsub!(/<\/center>/i, "[/ALIGN]")

          ## QUOTE
          line.gsub!(/<(?:xmp|pre)>/i,   "[QUOTE]")
          line.gsub!(/<\/(?:xmp|pre)>/i, "[/QUOTE]")

          ## LIST
          line.gsub!(/<ul>/i,      "\n[LIST]\n")
          line.gsub!(/<\/ul>/i,    "\n[/LIST]\n")
          line.gsub!(/<li *\/?> */i, "\n[*] ")

          ## Unkown tags => throw away
          line.gsub!(/<.*? *\/?>/, "")

          result << sprintf("%s<br />\n", line)
      end

      return result.gsub!(/<br *\/?>/i, "\n")
  end

  # Converts a BBCode string to one with HTML markup.
  # Returns the string with all formatting instructions in
  # BBCodes converted to XHTML markups.
  def BBCode.bbcode_to_html(string)
      return "" if string.nil? || string.to_s.strip.empty?
      result = ""
      quote = 0

      ## Iterate over lines
      string.split("\n").each do |line|
          styles = { "b" => "strong", "i" => "em", "u" => "u" }

          ## preserve B, I, U
          styles.each do |code,html|
              line.gsub!(/\[#{code}\]/i, "<#{html}>")
              line.gsub!(/\[\/#{code}\]/i, "</#{html}>")
          end

          ## COLOR => font color=... (TODO: should be numeric!)
          line.gsub!(/\[COLOR=(.*?)\]/i, "<font color=\"\\1\">")
          line.gsub!(/\[\/COLOR\]/i,     "</font>")

          ## SIZE => font size=...
          line.gsub!(/\[SIZE=(.*?)\]/i, "<font size=\"\\1\">")
          line.gsub!(/\[\/SIZE\]/i,     "</font>")

          ## URL
          line.gsub!(/\[URL\]([^\[]+?)\[\/URL\]/i, "<a href=\"\\1\">\\1</a>")
          line.gsub!(/\[URL=(.*?)\](.+?)\[\/URL\]/i, "<a href=\"\\1\">\\2</a>")

          ## IMG
          line.gsub!(/\[IMG=(.*?)\]/i, "<img src=\"\\1\" />")

          ## ALIGN=center (TODO: right, left)
          line.gsub!(/\[ALIGN=center\]/i, "<center>")
          line.gsub!(/\[ALIGN=right\]/i,  "<center>")
          line.gsub!(/\[ALIGN=left\]/i,   "<center>")
          line.gsub!(/\[\/ALIGN\]/i,      "</center>")

          ## QUOTE
          quote+=1 if line =~ /\[QUOTE\]/i
          quote-=1 if (line =~ /\[\/QUOTE\]/i) && (quote > -1)
          line.gsub!(/\[QUOTE\]/i,   "<pre>\n")
          line.gsub!(/\[\/QUOTE\]/i, "</pre>\n")
          line.gsub!(/^/, "&#62;"*quote) if quote > 0

          ## EMAIL
          line.gsub!(/\[EMAIL\](.*?)\[\/EMAIL\]/i, "<a href=\"mailto:\\1\">\\1</a>")

          ## LIST (TODO: LIST=1, LIST=A)
          line.gsub!(/\[LIST(?:=(.*?))?\]/i, "\n<ul>\n")
          line.gsub!(/\[\/LIST\]/i,          "\n</ul>\n")
          line.gsub!(/\[\*\]/i,              "\n<li />")

          ## FONT => font ??????
          ## ?BLUR?, FADE?

          result << sprintf("%s<br />\n", line)
      end

      return result
  end


  # -- Transitive methods ---------------

  # Converts a ANSI string to one with HTML markup.
  # Returns the string with ANSI code sequences converted to XHTML markup.
  def BBCode.ansi_to_html(string)
      bbcoded = BBCode.ansi_to_bbcode(string )
      htmled  = BBCode.bbcode_to_html(bbcoded)

      return htmled
  end

  # Returns the (X)HTML markup code as ANSI sequences
  def BBCode.html_to_ansi(string)
      bbcoded = BBCode.html_to_bbcode(string )
      ansied  = BBCode.bbcode_to_ansi(bbcoded)

      return ansied
  end

end #module BBCode
