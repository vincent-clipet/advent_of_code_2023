require "json"

lines = IO.readlines("data.txt")
data = []

lines.each do | s |
  h = {}
  regex = s.scan(/^Game (.*): (.*)$/)
  h[:game] = regex[0][0].to_i
  all = regex[0][1].split("; ")
  rolls = []
  all.each_with_index do | trio, index |
    split = trio.split(", ")
    tmp = { :blue => 0, :red => 0, :green => 0}
    split.each do | color |
      tmp[:blue] = color.split(" ")[0].to_i if color =~ /blue/
      tmp[:red] = color.split(" ")[0].to_i if color =~ /red/
      tmp[:green] = color.split(" ")[0].to_i if color =~ /green/
    end
    rolls << tmp
    h[:data] = rolls
    h[:valid] = h[:data].all? { |e| e[:red] <= 12 && e[:green] <= 13 && e[:blue] <= 14 }
    h[:power] = h[:data].map { |e| e[:red]}.max * h[:data].map { |e| e[:green]}.max * h[:data].map { |e| e[:blue]}.max
  end
  data << h
end

puts JSON.pretty_generate(data[0])

sum = data.map {|value| value[:game] if value[:valid] == true}.compact.sum
puts "Sum = #{sum}"

power = data.map {|value| value[:power] }.compact.sum
puts "Power sum = #{power}"
