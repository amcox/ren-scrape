require "#{Dir.getwd}/ren_scraper.rb"

rs = RenScraper.new
rs.prepare
rs.get_to_psp_page
rs.get_to_export_school_list
(0..4).each do |i|
  rs.export_school_from_list(i)
end
# rs.session.driver.browser.quit

Dir.glob("#{Dir.getwd}/output_files/*.csv") do |filename|
  File.delete(filename)
end

require "#{Dir.getwd}/merge_files.rb"

Dir.glob("#{Dir.getwd}/downloads/*.csv") do |filename|
  File.delete(filename)
end

require "#{Dir.getwd}/upload.rb"