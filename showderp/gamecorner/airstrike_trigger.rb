Trigger.new do |t|
  t[:id] = "shank"
  t[:lastused] = Time.now
  t[:cooldown] = 5 # seconds
  t[:killcount] = {}

  t.match do |info|
    info[:kill] = info[:what] =~ /\A!shank ([^,]+)\z/ && $1
    info[:airstrike] = info[:what] =~ /\A!airstrike ([^,]+)\z/ && $1
    info[:nuke] = info[:what] =~ /\A!nuke ([^,]+)\z/ && $1

    info[:kill] or info[:airstrike] or info[:nuke]
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

      # Airstrike someone
      if info[:airstrike]
        who = CBUtils.condense_name(info[:airstrike])
        if t[:killcount][who] and t[:killcount][who] > 4
          info[:respond].call("#{info[:who]} called in air support to rain glorious conspicuous CGI rocketspam down upon #{info[:airstrike]}.")
          t[:killcount][who] += 1
        else
          info[:respond].call("#{info[:airstrike]} hasn't died enough times yet.")
        end
      end

      # Nuke someone
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

