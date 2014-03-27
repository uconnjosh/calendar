require 'active_record'

require "./lib/calendar"
require "./lib/event"
require "time_difference"

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main
  clear
  puts " Welcome to the calendar "
  list_calendars
  puts " " +  "*"*23
  puts " 'add [calendarName]' - to create a calendar"
  puts " 'enter [calendarName]' - to enter a calendar"
  puts " 'delete [calendarName]' - to delete a calendar"
  puts " 'exit' - to exit the app"
  puts " " +  "*"*23
  print "►"
  input = gets.chomp.split
  case input[0]
  when "add"
    input.shift
    Calendar.create({:name => input.join(" ")})
  when "enter"
    input.shift
    calendar = Calendar.find_by(name: input.join(" "))
    enter_calendar(calendar)
  when "delete"
    input.shift
    calendar = Calendar.find_by(name: input.join(" "))
    calendar.destroy
  when "exit"
    exit
  end
end

def list_calendars
  puts " Here are your calendars..."
  Calendar.all.each_with_index do |cal, index|
    puts " #{index+1}. #{cal.name}"
  end
end

#FIX THIS ----- how doesnt work
def list_events(calendar, how, month_to_view=false)
  puts " Here are your events...(#{how})"
  events = Event.where(calender_id: calendar.id).order('start_time')
  events.each_with_index do |event, index|
    begin
      case how
      when "today"
        if DateTime.now.to_date == event.start_time.to_date
          puts " #{index+1}. #{event.name}"
        end
      when "week"
        if DateTime.now.to_date <= event.start_time.to_date && event.start_time.to_date <= DateTime.now.to_date + 7.days
          puts " #{index+1}. #{event.name}"
        end
      when "month"
        if month_to_view
          if month_to_view == event.start_time.to_s[5..6]
            puts " #{index+1}. #{event.name}"
          end
        else
          if DateTime.now.to_s[5..6] == event.start_time.to_s[5..6]
            puts " #{index+1}. #{event.name}"
          end
        end
      else
        puts " #{index+1}. #{event.name}"
      end
    rescue
      error
    end
  end
end
#__________________
def enter_calendar(calendar, how="by_date", month_to_view=false)
  clear
  puts " #{calendar.name} "
  list_events(calendar, how, month_to_view)
  puts " " +  "*"*23
  puts " 'add [eventName]' - to create a event"
  puts " 'enter [eventName]' - to enter a event"
  puts " 'delete [eventName]' - to delete a event"
  puts " 'view [how]' - to sort events by..."
  puts " 'how: by_date, today, week, month, month 12"
  puts " 'exit' - to exit the app"
  puts " " +  "*"*23
  print "►"
  input = gets.chomp.split
  case input[0]
  when "add"
    input.shift
    add_event(input.join(" "), calendar)
  when "enter"
    input.shift
    event = Event.find_by(name: input.join(" "))
    enter_event(event)
  when "delete"
    input.shift
    event = Event.find_by(name: input.join(" "))
    event.destroy
  when "view"
    input.shift
    how = input[0]
    month_to_view = input[1]
  when "exit"
    exit
  end
  enter_calendar(calendar, how, month_to_view)
end

def add_event(name, calendar)
  clear
  puts "Enter a description for #{name}:"
  description = gets.chomp.upcase
  puts "Got it!! Enter a location if you would like to add it, otherwise, press enter:"
  location = gets.chomp.upcase
  puts "Okay, now enter a date and time to start doing #{name}:"
  start_time = gets.chomp
  puts "Phewwww, almost done! Just enter an ending day and time, and we should be finished here!!!"
  end_time = gets.chomp
  Event.create({:name => name, :description => description, :location => location, :start_time => start_time, :end_time => end_time, :calender_id => calendar.id})
end

def enter_event(event)
  clear
  puts " name: #{event.name}"
  puts " description: #{event.description}"
  puts " when: #{event.start_time.to_s} - #{event.end_time.to_s}"
  puts " " +  "*"*23
  puts "You have #{TimeDifference.between(event.start_time + 7.hours, Time.now).in_hours} before #{event.name} starts"
  puts "You have #{TimeDifference.between(event.end_time + 7.hours, Time.now).in_hours} hours to complete #{event.name}"
  puts " 'update [whatToUpdate], [toWhat]' - to update event"
  puts " 'press enter to go back"
  puts " " +  "*"*23
  print "►"
  input = gets.chomp.split
  case input[0]
  when "update"
    input.shift
    case input[0]
    when "name"
      input.shift
      event.name = input.join(" ")
    when "description"
      input.shift
      event.description = input.join(" ")
    else
      error
    end
  end
end

def error
  puts "ERROR"
  sleep(3)
end

def clear
  system("clear")
end

def main_loop
  until 1 == 3
    main
  end
end

main_loop

