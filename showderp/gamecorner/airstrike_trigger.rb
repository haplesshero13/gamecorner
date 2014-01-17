Trigger.new do |t|
  t[:lastused] = Time.now
  t[:cooldown] = 5 # seconds
  t[:killcount] = {}
  t[:killstrings] = {
    "shanked" => "with a sharpened katakana.",
    "left" => "in the ocean to sleep with the fishes.",
    "blew" => "to bits with some timely C4 detonation.",
    "fed" => "to a hungry carnivorous dinosaur.",
    "turned" => "into Swiss cheese with a machine-pistol.",
    "sent" => "on a one-way trip to the graveyard.",
    "destroyed" => "once and for all.",
    "backed over" => "with a large truck.",
    "killed" => "dead.",
    "used Splash on" => "and it was super effective! **Fatality!**",
    "murdered" => "in cold blood.",
    "decapitated" => "with a dull spoon.",
    "sliced" => "into pieces with a lightsaber.",
    "melted" => "into slag somehow.",
    "treated" => "to a relaxing spa day in a vat of acid.",
    "blasted" => "into oblivion with a full broadside of cannonfire.",
    "had" => "bite the bullet.",
    "plied" => "with an __oishii__ bleach and ammonia cocktail. Next round's on the house.",
    "gave" => "a case of sudden mortality.",
    "backstabbed" => "after many years of nakama and dai suki desu desu."
  }

  t.match do |info|
    info[:kill] = info[:what] =~ /\A!shank ([^,]+)\z/ && $1
    info[:airstrike] = info[:what] =~ /\A!airstrike ([^,]+)\z/ && $1
    info[:nuke] = info[:what] =~ /\A!nuke ([^,]+)\z/ && $1

    info[:kill] or info[:airstrike] or info[:nuke]
  end
  
  t.act do |info|
    # Wait for cooldown
    if Time.now - t[:lastused] > t[:cooldown]
      # Kill someone
      if info[:kill]
        who = CBUtils.condense_name(info[:kill])
        t[:killcount][who] ||= 0
        t[:killcount][who] += 1
        method = t[:killstrings].keys.sample
        result = t[:killstrings][method]
        info[:respond].call("#{info[:who]} #{method} #{info[:kill]} #{result}")
      end

      if info[:airstrike]
        who = CBUtils.condense_name(info[:airstrike])
        if t[:killcount][who] and t[:killcount][who] > 4
          info[:respond].call("#{info[:who]} called in air support to rain glorious conspicuous CGI rocketspam down upon #{info[:airstrike]}.")
          t[:killcount][who] += 1
        else
          info[:respond].call("#{info[:airstrike]} hasn't died enough times yet.")
        end
      end

      if info[:nuke]
        who = CBUtils.condense_name(info[:nuke])
        if t[:killcount][who] and t[:killcount][who] > 9
          info[:respond].call("#{info[:who]} chose the nuclear option for #{info[:nuke]}. Farewell, cruel world.")
          t[:killcount][who] = 0
        else
          info[:respond].call("#{info[:nuke]} hasn't died enough times yet.")
        end
      end
      t[:lastused] = Time.now
    end
  end
end

