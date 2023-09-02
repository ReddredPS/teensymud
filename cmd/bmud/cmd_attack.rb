module Cmd
  def cmd_attack(args)
    args = args.split(" ")
    args.map!(&:downcase)  # Ensure all arguments are converted to lowercase

    place = get_object(location)

    if place.characters.size < 2
      sendto("There's no one else here to attack.")
    else
      target_found = false

      place.characters(id).each do |x|
        if x.name == args[0].proper_name
          target_found = true
          atk_r = rand(20) + 1
          def_r = rand(20) + 1
          dam_r = rand(6) + 1

          case args[1]
          when 'head'
            atk_r -= 4
            dam_r += 2
            target = 'head'
          when 'body'
            # No need to modify atk_r and dam_r
            target = 'body'
          when 'legs'
            atk_r -= 2
            dam_r += 1
            rand(100) > 49 ? target = 'left leg' : target = 'right leg'
          when 'arms'
            atk_r += 2
            dam_r -= 1
            rand(100) > 49 ? target = 'left arm' : target = 'right arm'
          else
            # No need to modify atk_r and dam_r
            target = 'body'
          end

          case self.attributes['stance']
          when 'relaxed'
            # No need to modify atk_r and dam_r
          when 'defensive'
            atk_r -= 2
          when 'evasive'
            dam_r -= 2
          when 'offensive'
            atk_r += 2
            dam_r += 2
          else
            sendto("There has been a serious bug, please report it.")
            return
          end

          case x.attributes['stance']
          when 'relaxed', 'evasive'
            def_r += 0
          when 'defensive'
            def_r += 2
          when 'offensive'
            def_r -= 2
          else
            add_event(id, x.id, :show, "There has been a serious bug, please report it.")
            return
          end

          dam_r = 1 if dam_r <= 0  # Ensure damage is at least 1

          if atk_r > def_r
            damage_dealt = x.attributes['health'] - dam_r
            damage_dealt = [damage_dealt, 0].max
            add_event(id, x.id, :show, "#{name} hits you in the #{target} for #{dam_r} damage. Your health is now #{damage_dealt}.")
            add_event(x.id, id, :show, "You have been hit by #{name} in the #{target} for #{dam_r} damage. Your health is now #{damage_dealt}.")
            sendto("You hit #{x.name} in the #{target} for #{dam_r} damage.")
            x.damage('health', dam_r, id, x.id)
          else
            add_event(id, x.id, :show, "#{name} takes a swing at your #{target} and misses you.")
            add_event(x.id, id, :show, "#{x.name} takes a swing at your #{target} and misses.")
            sendto("You take a swing at #{x.name}'s #{target} and miss.")
          end
        end
      end

      unless target_found
        sendto("They are not here.")
      end
    end
  end
end
