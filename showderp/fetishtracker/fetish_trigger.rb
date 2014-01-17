
def is_num?(str)
  begin
    !!Integer(str)
  rescue ArgumentError, TypeError
    false
  end
end

def record_entry(user, fetish, level, path)
  user = CBUtils.condense_name(user)
  index = nil
  path = path + '/' + fetish
  FileUtils.touch(path)
  entries = File.read(path).split("\n")
  


  entries.each_with_index {|entry, i| 
    elements = entry.split(' ')
    if elements[0] == user
      index = i
      break
    end
  }


  if index == nil
    newentry = user + ' ' +  level + "\n"
    File.open(path, "a") do |f|
      f.puts(newentry)
    end

  else
    newentry = user + ' ' + level
    entries[index] = newentry
    result = entries.join("\n")
    File.open(path, "w") do |f|
      f.puts(result)
    end
  end
end

Trigger.new do |t|

  t[:id] = 'fetish'
  t[:lastused] = Time.now
  t[:cooldown] = 5 # seconds
  
  t.match { |info|
    # checks
    info[:what][0..6] == '!fetish' &&
    info[:what][7..-1].strip
  }
  

  fetishstatspath = './showderp/fetishtracker/stats'
  t.act { |info|

    info[:where] == "pm" or (info[:where] == "c" and t[:lastused] + t[:cooldown] < Time.now and t[:lastused] = Time.now) or next

    if info[:where] == 'c' && !(info[:all][2][0] == '#' || info[:all][2][0] == '@' || info[:all][2][0] == '%')
      info[:respond].call('To broadcast the full results of this command in a room you must be a driver or higher. Try pming')
      next
    end 


    
    fetishes = File.read('./showderp/fetishtracker/list').split(' ')
    # if those checks pass
    
    args = info[:result].split(' ')

    if args.count != 2

      
      result = 'Pm to me "!fetish <fetishid> <acceptancelevel>" to register your toleration of a fetish.'
      info[:respond].call(result)
      result = 'Available fetish ids are: '
      result += fetishes.join(', ')
      info[:respond].call(result)
      result = 'Levels are: 0-Prohibition 1-Links w/ warning 2-Links w/o warning 3-Declares ok 4-I love it'
      info[:respond].call(result)
      info[:respond].call('Example: If you would tolerate images with shoes as long as links have warnings, you would pm to me "!fetish shoes 1"')
    elsif !is_num?(args[1]) || Integer(args[1]) < 0 || Integer(args[1]) > 4
      
      info[:respond].call('The acceptance level must be an integer from 0-4.')
    elsif !fetishes.include?(args[0])
      
      info[:respond].call('The fetish id must be one in the list. Type !fetish for a list.')
    elsif info[:where] == 'c'
    
      info[:respond].call('Please pm your entries to me')
    else
      
      record_entry(info[:who], args[0], args[1], fetishstatspath)
      info[:respond].call('Records Updated')
    end

  }
end
