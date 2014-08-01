require 'net/ftp'
require 'double_bag_ftps'

hostname = "38.97.204.25"
username = "ReNEW"
password = "j6ax622ij"

ftps = DoubleBagFTPS.new
ftps.ssl_context = DoubleBagFTPS.create_ssl_context(:verify_mode => OpenSSL::SSL::VERIFY_NONE)
ftps.connect(hostname)
ftps.login(username, password)
ftps.passive = true

ftps.chdir("StarRenaissance")

Dir.glob("#{Dir.getwd}/output_files/*.csv") do |filename|
  ftps.put(File.new(filename))
end

ftps.quit