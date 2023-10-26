require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'phonelib'
require 'date'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def validate_phone_number(phone_number)
  # Remove any non-digit characters
  digits = phone_number.gsub(/\D/, '')

  # Check the length of the phone number
  case digits.length
  when 10
    # If the phone number is 10 digits, it is good
    return digits
  when 11
    # If the phone number is 11 digits and the first number is 1,
    # trim the 1 and use the remaining 10 digits
    if digits[0] == '1'
      return digits
    else
      # If the phone number is 11 digits and the first number is not 1, it is a bad number
      return false
    end
  else
    # If the phone number is less than 10 digits or more than 11 digits, it is a bad number
    return false
  end
end

def peak_hours(registration_times)
  hours = registration_times.map do |time|
    DateTime.strptime(time, '%m/%d/%y %H:%M').hour
  end

  frequencies = Hash.new(0)
  hours.each { |hour| frequencies[hour] += 1 }
  frequencies
end

def find_peak_hours(frequencies)
  max_frequency = frequencies.values.max
  peak_hours = frequencies.select { |k, v| v == max_frequency }.keys
  peak_hours
end

def peak_days(registration_times)
  days = registration_times.map do |time|
    Date.strptime(time, '%m/%d/%y %H:%M').wday
  end

  frequencies = Hash.new(0)
  days.each { |day| frequencies[Date::DAYNAMES[day]] += 1 }
  frequencies
end

def find_peak_days(frequencies)
  max_frequency = frequencies.values.max
  peak_days = frequencies.select { |k, v| v == max_frequency }.keys
  peak_days
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

registration_times = []

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone_number = validate_phone_number(row[:homephone])
  legislators = legislators_by_zipcode(zipcode)
  registration_times << row[:regdate]

  form_letter = erb_template.result(binding)

  save_thank_you_letter(id,form_letter)
end

frequencies = peak_hours(registration_times)
peak_hours = find_peak_hours(frequencies)
puts "Peak Hours: #{peak_hours}"

frequencies = peak_days(registration_times)
peak_days = find_peak_days(frequencies)
puts "Peak Days: #{peak_days}"
