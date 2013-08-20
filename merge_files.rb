require 'csv'

math_files = []
reading_files = []
Dir.glob("#{Dir.getwd}/downloads/*.csv") do |filename|
  if /Math/.match(filename)
    math_files.push filename
  end
  if /Reading/.match(filename)
    reading_files.push filename
  end
end

def summarize_csv(output_filename="", file_list=[])
  CSV.open("#{Dir.getwd}/output_files/#{output_filename}", "wb") do |csv|
    header_flag = false
    file_list.each do |filename|
      existing_csv = CSV.read(filename)
      if !header_flag
        csv << existing_csv[1]
        header_flag = true
      end
      2.times do existing_csv.delete_at(0) end
      existing_csv.each do |existing_row|
        csv << existing_row
      end
    end
  end
end

summarize_csv("reading_summary#{Time.now.strftime('%Y%m%d-%H%M%S')}.csv", reading_files)
summarize_csv("math_summary#{Time.now.strftime('%Y%m%d-%H%M%S')}.csv", math_files)