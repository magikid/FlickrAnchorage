#!/usr/ruby
require 'flickraw'
require 'heatmap'

FlickRaw.api_key = '8ae842cd467ee53bb5413ecad09edb99'
FlickRaw.shared_secret = '4bedd2447b006d17'
FlickRaw.secure = true

def initial_login
    token = flickr.get_request_token
    auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'read')
    
    puts "Open this url in your process to complete the authication process : #{auth_url}"
    puts "Copy here the number given when you complete the process."
    verify = gets.strip
    
    begin
      flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
      login = flickr.test.login
      puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
    rescue FlickRaw::FailedResponse => e
      puts "Authentication failed : #{e.msg}"
    end
end

def returning_login
    flickr.access_token = "72157637951808514-38f21bb289bcdc91"
    flickr.access_secret = "4784dd03a1d87297"
    
    # From here you are logged:
    login = flickr.test.login
    puts "You are now authenticated as #{login.username}"
end

returning_login()
anc = flickr.places.find :query => "Anchorage, AK"
latitude = anc[0]['latitude'].to_f
longitude = anc[0]['longitude'].to_f

# within 60 miles of new brunswick, let's use a bbox
radius = 1
args = {}
args[:bbox] = "#{longitude - radius},#{latitude - radius},#{longitude + radius},#{latitude + radius}"

# requires a limiting factor, so let's give it one
args[:min_taken_date] = '1993-01-01 00:00:00'
args[:max_taken_date] = '2013-01-01 00:00:00'
args[:accuracy] = 1 # the default is street only granularity [16], which most images aren't...
discovered_pictures = flickr.photos.search args

puts "Number of pics found: ", discovered_pictures.length
discovered_pictures.each{|pic|
    puts pic.title
    info = flickr.photos.geo.getLocation(:photo_id => pic.id)
    puts info.location.latitude.to_s + ", " + info.location.longitude.to_s
} 
