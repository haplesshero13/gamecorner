Trigger.new do |t|
  t[:id] = "jak"
  t[:cooldown] = 5 # seconds
  t[:lastused] = Time.now - t[:cooldown]
  
  t.match { |info|
    info[:what][0..3].downcase == '!jak' &&
    (info[:where] == 'pm' || info[:room] == 'showderp')
  }
  
  t.act do |info|
    t[:lastused] + t[:cooldown] < Time.now or next

    t[:lastused] = Time.now

    info[:respond].call('**DarkJak**')
    info[:respond].call('**Ace:** Mega Charizard-X')
    info[:respond].call('**Catchphrase:** The Darkside cannot be extinguished, when you fight')
  end
end
