require 'faye/websocket'
require 'eventmachine'
require 'net/http'
require 'json'
require 'fileutils'
require 'optparse'


require './app/chatbot.rb'
require './app/chathandler.rb'
require './app/consoleinput.rb'
require './app/socketinput.rb'
require './app/utils.rb'


$data = {}
$login = {}
$options = {room: 'showderp'}


op = OptionParser.new do |opts|
  opts.banner = 'Usage: connector.rb [options]'
  
  opts.on('-n', '--name NAME', 'specify name (required)') do |v|
    $login[:name] = v
  end
  
  opts.on('-p', '--pass PASS', 'specify password (required)') do |v|
    $login[:pass] = v
  end
  
  opts.on('-r', '--room ROOM', 'specify room to join (default is showderp)') do |v|
    $options[:room] = v
  end
  
  opts.on_tail('-h', '--help', 'Show this message') do
    puts opts
    Process.exit
  end
end

if ARGV.empty?
  puts op
  Process.exit
end

op.parse!(ARGV)




if __FILE__ == $0
  
  
  #trap("INT") do
  #  puts "\nExiting"
  #  puts "Writing ignore list to file..."
  #  IO.write("./#{$chat.group}/ignored.txt", $chat.ignorelist.join("\n"))
  #  exit
  #end
  
  EM.run do
    bot = Chatbot.new($login[:name], $login[:pass], $options[:room])
    EM.start_server('127.0.0.1', 8081, InputServer)
  end
  


end
