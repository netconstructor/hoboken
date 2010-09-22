#hoboken.rb

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