require 'net/http'
require 'uri'

base_uri = 'https://your.owncloud.install.com/owncloud/ocs/v1.php/apps/files_sharing/api/v1/'
uri = URI("#{base_uri}/shares/115464")

Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  req = Net::HTTP::Get.new uri
  req.basic_auth 'your.username', 'your.password'
  res = http.request req

  puts res.body
end