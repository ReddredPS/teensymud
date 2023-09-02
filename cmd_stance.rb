module Cmd
  def cmd_stance(args)
    case args
      when 'defensive', 'defense'
        if self.attributes['stance'] != 'defensive'
          self.attributes['stance'] = 'defensive'
          sendto("You enter a defensive stance.")
        else
          sendto("You are already in a defensive stance.")
        end
      when 'offensive', 'offense'
        if self.attributes['stance'] != 'offensive'
          self.attributes['stance'] = 'offensive'
          sendto("You enter an offensive stance.")
        else
          sendto("You are already in an offensive stance.")
        end
      when 'evasive', 'evade'
        if self.attributes['stance'] != 'evasive'
          self.attributes['stance'] = 'evasive'
          sendto("You enter an evasive stance.")
        else
          sendto("You are already in an evasive stance.")
        end
      when 'relaxed', 'relax'
        if self.attributes['stance'] != 'relaxed'
          self.attributes['stance'] = 'relaxed'
          sendto("You relax your stance.")
        else
          sendto("You have already relaxed your stance.")
        end
      when nil, ""
        sendto("You must select a stance. Options are relaxed, offensive, defensive and evasive.")
      else
        sendto("That stance has not been implemented.")
      end
  end
end
