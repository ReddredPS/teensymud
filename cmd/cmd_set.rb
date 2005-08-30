#
# file::    cmd_set.rb
# author::  Jon A. Lambert
# version:: 2.2.0
# date::    08/29/2005
#
# This source code copyright (C) 2005 by Jon A. Lambert
# All rights reserved.
#
# Released under the terms of the TeensyMUD Public License
# See LICENSE file for additional information.
#
module Cmd

  # sets the description for an object (ex. @set #1 A beautiful rose.)
  def cmd_set(*args)
    case args[0]
    when /#(\d+) (.*)/
      o = $world.find_by_oid($1.to_i)
      case o
      when nil, 0
        sendto("No object."+EOL)
      else
        o.desc = $2
        sendto("Object #" + $1 + " description set." + EOL)
      end
    else
      sendto("What??")
    end
  end

end