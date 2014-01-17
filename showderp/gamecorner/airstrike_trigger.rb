Trigger.new do |t|
  t[:id] = "shank"
  t[:lastused] = Time.now
  t[:cooldown] = 5 # seconds
  t[:killcount] = {}
  t[:killstrings] = {
    "shanked" => "with a sharpened katakana.",
    "left" => "in the ocean to sleep with the fishes.",
    "blew" => "to bits.",
    "fed" => "to a hungry carnivorous dinosaur.",
    "turned" => "into Swiss cheese with a machine-pistol.",
    "sent" => "on a one-way trip to the graveyard.",
    "destroyed" => "once and for all.",
    "backed over" => "with a large truck.",
    "killed" => "dead.",
    "used Splash on" => "with fatal results.",
    "murdered" => "in cold blood.",
    "decapitated" => "with a dull spoon.",
    "sliced" => "into pieces with a lightsaber.",
    "melted" => "into slag somehow.",
    "treated" => "to a relaxing spa treatment in a vat of acid."
  }

  t.match do |info|
    info[:kill] = info[:what] =~ /\A!shank ([^,]+)\z/ && $1
    info[:airstrike] = info[:what] =~ /\A!airstrike ([^,]+)\z/ && $1

    info[:kill] or info[:airstrike]
  end
  
  t.act do |info|
    killstrings = File.read('./showderp/gamecorner/list').split("\n")


    # Wait for cooldown
    if Time.now - t[:lastused] > t[:cooldown]
      # Kill someone
      if info[:kill]
        who = CBUtils.condense_name(info[:kill])
        t[:killcount][who] ||= 0
        t[:killcount][who] += 1
        result = killstrings.sample
        result["::killer::"] = info[:who]
        result["::killee::"] = info[:kill]
        info[:respond].call(result)
      end

      if info[:airstrike]
        who = CBUtils.condense_name(info[:airstrike])
        if t[:killcount][who] and t[:killcount][who] > 9
          info[:respond].call("#{info[:who]} rained glorious conspicuous CGI rocketspam down upon #{info[:airstrike]}.")
          t[:killcount][who] = 0
        else
          info[:respond].call("#{info[:airstrike]} hasn't died enough times yet.")
        end
      end
      t[:lastused] = Time.now
    end
  end
end

