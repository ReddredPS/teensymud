module Cmd
  def cmd_attack(args)
    # Input validation
    args = args.split(" ")
    if args.length != 2
      sendto("Usage: attack <target> <body part>")
      return
    end

    target_name = args[0].downcase
    body_part = args[1].downcase

    place = get_object(location)

    if place.characters.size < 2
      sendto("There's no one else here to attack.")
    else
      target_found = false

      place.characters(id).each do |target|
        if target.name.downcase == target_name
          target_found = true
          damage_modifier = 1

          # Determine damage based on body part
          case body_part
          when 'head'
            damage_modifier += 0.5
            target_body_part = 'head'
          when 'body'
            target_body_part = 'body'
          when 'legs'
            damage_modifier -= 0.2
            target_body_part = ['left leg', 'right leg'].sample
          when 'arms'
            damage_modifier -= 0.1
            target_body_part = ['left arm', 'right arm'].sample
          else
            target_body_part = 'body'
          end

          # Calculate damage
          attack_roll = rand(20) + 1
          defense_roll = rand(20) + 1
          damage = [(attack_roll - defense_roll) * damage_modifier, 1].max.to_i

          if damage > 0
            target_health = target.attributes['health'] - damage
            target_health = [target_health, 0].max
            add_event(id, target.id, :show, "#{name} hits you in the #{target_body_part} for #{damage} damage. Your health is now #{target_health}.")
            add_event(target.id, id, :show, "You have been hit by #{name} in the #{target_body_part} for #{damage} damage. Your health is now #{target_health}.")
            sendto("You hit #{target.name} in the #{target_body_part} for #{damage} damage.")
            target.damage('health', damage, id, target.id)
          else
            add_event(id, target.id, :show, "#{name} takes a swing at your #{target_body_part} and misses you.")
            add_event(target.id, id, :show, "#{target.name} takes a swing at your #{target_body_part} and misses.")
            sendto("You take a swing at #{target.name}'s #{target_body_part} and miss.")
          end
        end
      end

      unless target_found
        sendto("They are not here.")
      end
    end
  end
end