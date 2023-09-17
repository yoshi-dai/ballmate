number = []
total = 0

(1..57).each do |i|
  if i.odd?
    number << i
  end
end

number.each do |j|
  total += j ** 3
end

puts total