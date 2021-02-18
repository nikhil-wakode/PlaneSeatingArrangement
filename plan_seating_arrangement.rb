require 'pry'
require 'json'

puts "Enter Seating arrangement array:"
seat_sections = gets.chomp
seat_sections = JSON.parse seat_sections

puts "Enter number of passengers:"
passengers = gets.chomp.to_i

seats_avalilble = 0
aisle_seats = 0
window_seats = 0
middle_seats = 0
aisle_seats_passengers = []
window_seats_passengers = []
middle_seats_passengers = []
output = []
seat_couter = passengers

#Calculate Seat Count
seat_sections.each do |seat_section|
  seats_avalilble += seat_section.inject(:*)
end

puts "Only #{seats_avalilble} seats are availble." if passengers > seats_avalilble

#counting Aisle Seats
seat_sections.each_with_index do |seat_section, index|
  if (index == 0 || index == (seat_sections.size - 1))
    aisle_seats += seat_section[1] if (!seat_section[1].nil? &&  seat_section[0] > 1)
    window_seats += seat_section[1] if (!seat_section[1].nil? &&  !seat_section[0].nil?)
  else
    if (!seat_section[1].nil? &&  seat_section[0] > 1)
      aisle_seats += seat_section[1]*2
    elsif (!seat_section[1].nil? &&  seat_section[0] == 1)
      aisle_seats += seat_section[1]
    end
  end
  middle_seats += seat_section[1]*(seat_section[0]-2) if (!seat_section[1].nil? &&  seat_section[0] > 2)
end

if aisle_seats > 0
  1.upto(aisle_seats) do |index|
    break if seat_couter == 0 
    aisle_seats_passengers << index
    seat_couter -=1
  end
end

if window_seats > 0
  1.upto(window_seats) do |index|
    break if seat_couter == 0
    window_seats_passengers << (aisle_seats_passengers[-1]+index)
    seat_couter -=1
  end
end

if middle_seats > 0
  1.upto(middle_seats) do |index|
    break if seat_couter == 0
    middle_seats_passengers << (window_seats_passengers[-1]+index)
    seat_couter -=1
  end
end
max_rows = 0
seat_sections.each do |seat_section|
  max_rows = seat_section[1] if seat_section[1] > max_rows
end

lines = {}
counter = {}

seat_sections.each_with_index {|seat_section, index| counter["seat_section_#{index}"] = seat_section[1]}

1.upto(max_rows) do |row|
  line_elemt = ""
  seat_sections.each_with_index do |seat_section, index|
    if counter["seat_section_#{index}"] > 0
      line_elemt << " | "

      if index == 0
        if seat_section[0] == 1
          line_elemt << " #{sprintf '%02d', window_seats_passengers[0] rescue "**"} "
          window_seats_passengers.shift
        elsif seat_section[0] == 2
          line_elemt << " #{sprintf '%02d', window_seats_passengers[0] rescue "**"} "
          line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} "
          window_seats_passengers.shift
          aisle_seats_passengers.shift
        elsif seat_section[0] >= 2
          1.upto(seat_section[0]) do |n|
            if n == 1
              line_elemt << " #{sprintf '%02d', window_seats_passengers[0] rescue "**"} "
              window_seats_passengers.shift
            elsif n == seat_section[0]
              line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} "
              aisle_seats_passengers.shift
            else
              line_elemt << " #{sprintf '%02d', middle_seats_passengers[0] rescue "**"} "
              middle_seats_passengers.shift
            end
          end
        end
      
      elsif index == seat_sections.size - 1
        if seat_section[0] == 1
          line_elemt << " #{sprintf '%02d', window_seats_passengers[0] rescue "**"} |"
          window_seats_passengers.shift
        elsif seat_section[0] == 2
          line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} |"
          line_elemt << " #{sprintf '%02d', window_seats_passengers[0] rescue "**"} |"
          aisle_seats_passengers.shift
          window_seats_passengers.shift
        elsif seat_section[0] >= 2 
          1.upto(seat_section[0]) do |n|
            if n == 1
              line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} |"
              aisle_seats_passengers.shift
            elsif n == seat_section[0]
              line_elemt << " #{sprintf '%02d', window_seats_passengers[0] rescue "**"} |"
              window_seats_passengers.shift
            else
              line_elemt << " #{sprintf '%02d', middle_seats_passengers[0] rescue "**"} |"
              middle_seats_passengers.shift
            end
          end
        end

      else
        if seat_section[0] == 1
          line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} "
          aisle_seats_passengers.shift
        elsif seat_section[0] == 2
          line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} "
          aisle_seats_passengers.shift
          line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} "
          aisle_seats_passengers.shift
        elsif seat_section[0] >= 2 
          1.upto(seat_section[0]) do |n|
            if n == 1
              line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} "
              aisle_seats_passengers.shift
            elsif n == seat_section[0]
              line_elemt << " #{sprintf '%02d', aisle_seats_passengers[0] rescue "**"} "
              aisle_seats_passengers.shift
            else
              line_elemt << " #{sprintf '%02d', middle_seats_passengers[0] rescue "**"} "
              middle_seats_passengers.shift
            end
          end
        end
      end

      counter["seat_section_#{index}"] -= 1
    else
      line_elemt << "   "
      seat_section[0].times { line_elemt << "    "}
    end
  end
  lines[row] = line_elemt
end
lines.each do |line|
  puts line[1]
end
puts "\n\n** represents availble seats."