#hoboken.rb
# 
# A simple server that exposes a SQLite database as an OpenSearch-Geo with GeoJSON output
# 
# Usage:
# 
# ruby hoboken.rb db/mydb.sqlite tablename
# 
# curl "http://localhost:4567/features.json?bbox=-122,35,-60,55"
# 
# {"features": [ 
#   { "latitude0":"-0.45032625E2","longitude0":"0.168659022E3",
#       "geometry":"0101000020FFFFFFFF062B4EB5161565401904560E2D8446C0"},
#   {"latitude0":"-0.43904027E2","longitude0":"0.17174578E3",
#     "geometry":"0101000020FFFFFFFF59C0046EDD776540BAD91F28B7F345C0"} ] }

database, table = ARGV

require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'Time'
require 'geo_ruby'
require 'json'

DataMapper.setup(:default, "sqlite:#{database}")

puts "Table: #{@table}"
class Twitter
  include DataMapper::Resource
  storage_names[:default] = ARGV[1]
  property "OGC_FID", Serial
  property "text0", String
  property "latitude0", Decimal
  property "longitude0", Decimal
end

get '/features' do
  @articles = Twitter.get(1)
  @bbox = params[:bbox]
  erb :features
end

get '/features.json' do
  content_type :json

  @articles = Twitter.all :limit => params[:id] || 10
  @bbox = params[:bbox]
  
  features = @articles.collect do |article|
    {
      "latitude0" => article.latitude0,
      "longitude0" => article.longitude0,
      "geometry" => GeoRuby::SimpleFeatures::Geometry.from_ewkt("POINT(#{article.longitude0} #{article.latitude0})").as_hex_ewkb
    }
  end
  {:features => features}.to_json
  
end