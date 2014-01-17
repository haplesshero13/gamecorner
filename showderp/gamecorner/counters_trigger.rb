Trigger.new do |t|
  t[:lastused] = Time.now
  t[:cooldown] = 60 # seconds
  t[:sao] ||= 0
  t[:dragonball] ||= 0
  t[:naruto] ||= 0
  t[:fairytail] ||= 0
  t[:attackontitan] ||= 0
  t[:onepiece] ||= 0
  t[:id] = "counter"

  sao_reg = /(\bSword\sArt\sOnline\b|\bSAO\b)/i
  db_reg = /(\bdragon\sball\b|\bdbz\b)/i
  nar_reg = /\bnaruto\b/i
  ft_reg = /\bfairy\stail\b/i
  snk_reg = /(\battack\son\stitan\b|\bshingeki\sno\skyojin\b|\bsnk\b|\baot\b)/i
  op_reg = /\bone\spiece\b/i

  t.match do |info|
    info[:print] = info[:where] == 'c' && info[:what] == '!counter'

    counter = info[:where] == 'c' && info[:what].scan(sao_reg).any? && info[:who].downcase != "gamecorner"
    counter ||= info[:where] == 'c' && info[:what].scan(db_reg).any? && info[:who].downcase != "gamecorner"
    counter ||= info[:where] == 'c' && info[:what].scan(nar_reg).any? && info[:who].downcase != "gamecorner"
    counter ||= info[:where] == 'c' && info[:what].scan(ft_reg).any? && info[:who].downcase != "gamecorner"
    counter ||= info[:where] == 'c' && info[:what].scan(snk_reg).any? && info[:who].downcase != "gamecorner"
    counter ||= info[:where] == 'c' && info[:what].scan(op_reg).any? && info[:who].downcase != "gamecorner"

    info[:print] || counter
  end
  
  t.act do |info|
    t[:sao] += info[:what].scan(sao_reg).length
    t[:dragonball] += info[:what].scan(db_reg).length
    t[:naruto] += info[:what].scan(nar_reg).length
    t[:fairytail] += info[:what].scan(ft_reg).length
    t[:attackontitan] += info[:what].scan(snk_reg).length
    t[:onepiece] += info[:what].scan(op_reg).length

    result = "(Newpleb Counter Results) SAO: #{t[:sao]}, Dragon Ball: #{t[:dragonball]}, Naruto: #{t[:naruto]}, AoT: #{t[:attackontitan]}, Fairy Tail: #{t[:fairytail]}, One Piece: #{t[:onepiece]}"
    if info[:print] and (Time.now - t[:lastused] > t[:cooldown])
      info[:respond].call(result)
      t[:lastused] = Time.now
    end
  end
end
