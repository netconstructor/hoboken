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
#require 'Time'
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

  features = Twitter.all :limit => params[:id] || 1000
  @bbox = params[:bbox]
	bbox = @bbox.split(',').collect { |e| e.to_f }
	@articles = features.select do |feature|
		feature.latitude0 <= bbox[3] && feature.latitude0 >= bbox[1] && feature.longitude0 <= bbox[2] && feature.latitude0 >= bbox[0]
	end
  
  features = @articles.collect do |article|
    {
      "latitude0" => article.latitude0,
      "longitude0" => article.longitude0,
      "geometry" => GeoRuby::SimpleFeatures::Geometry.from_ewkt("POINT(#{article.longitude0} #{article.latitude0})").as_hex_wkb
    }
  end
 	features.json 
end

get '/overlay.json' do
  content_type :json

  features = Twitter.all :limit => params[:id] || 1000
  @bbox = params[:bbox]
	bbox = @bbox.split(',').collect { |e| e.to_f }
	@articles = features.select do |feature|
		feature.latitude0 <= bbox[3] && feature.latitude0 >= bbox[1] && feature.longitude0 <= bbox[2] && feature.latitude0 >= bbox[0]
	end
  
  features = @articles.collect do |article|
    {
      "latitude0" => article.latitude0,
      "longitude0" => article.longitude0,
			"user_favo0" => rand(8477).to_f,
      "geometry" => GeoRuby::SimpleFeatures::Geometry.from_ewkt("POINT(#{article.longitude0} #{article.latitude0})").as_hex_wkb
    }
  end

	{"name"=>"tweets in manhattan mentioning starbucks", "short_classification"=>"Y", "icon_link"=>nil, "title"=>"tweets in manhattan mentioning starbucks", "stats"=>{"user_foll1"=>{"median"=>154.0, "stdev"=>1623.39946826309, "max"=>15857.0, "mean"=>597.902280130293, "min"=>1.0, "variance"=>2635425.83355688}, "user_frie0"=>{"median"=>175.0, "stdev"=>1076.58670789785, "max"=>15879.0, "mean"=>440.866449511401, "min"=>0.0, "variance"=>1159038.93962232}, "latitude0"=>{"median"=>40.7517192, "stdev"=>0.0256158958626976, "max"=>40.870411, "mean"=>40.7513905197069, "min"=>40.703253, "variance"=>0.000656174120848569}, "longitude0"=>{"median"=>-73.98684, "stdev"=>0.0153740677888511, "max"=>-73.936566, "mean"=>-73.9859414521499, "min"=>-74.0186, "variance"=>0.00023636196037619}, "user_stat0"=>{"median"=>1783.0, "stdev"=>5622.75570660854, "max"=>35719.0, "mean"=>3853.92508143322, "min"=>12.0, "variance"=>31615381.7361989}, "user_favo0"=>{"median"=>3.0, "stdev"=>518.928212499286, "max"=>8477.0, "mean"=>66.8371335504886, "min"=>0.0, "variance"=>269286.489727704}}, "data_attributes"=>[{"name"=>"user_foll1", "original_name"=>"user_foll1", "statistics"=>{"median"=>154.0, "stdev"=>1623.39946826309, "max"=>15857.0, "mean"=>597.902280130293, "min"=>1.0, "variance"=>2635425.83355688}, "data_type"=>"decimal", "id"=>705, "description"=>"", "overlay_id"=>211}, {"name"=>"user_crea0", "original_name"=>"user_crea0", "statistics"=>nil, "data_type"=>"datetime", "id"=>716, "description"=>"", "overlay_id"=>211}, {"name"=>"user_name0", "original_name"=>"user_name0", "statistics"=>nil, "data_type"=>"string", "id"=>715, "description"=>"", "overlay_id"=>211}, {"name"=>"user_stat0", "original_name"=>"user_stat0", "statistics"=>{"median"=>1783.0, "stdev"=>5622.75570660854, "max"=>35719.0, "mean"=>3853.92508143322, "min"=>12.0, "variance"=>31615381.7361989}, "data_type"=>"decimal", "id"=>714, "description"=>"", "overlay_id"=>211}, {"name"=>"user_favo0", "original_name"=>"user_favo0", "statistics"=>{"median"=>3.0, "stdev"=>518.928212499286, "max"=>8477.0, "mean"=>66.8371335504886, "min"=>0.0, "variance"=>269286.489727704}, "data_type"=>"decimal", "id"=>713, "description"=>"", "overlay_id"=>211}, {"name"=>"user_scre0", "original_name"=>"user_scre0", "statistics"=>nil, "data_type"=>"string", "id"=>712, "description"=>"", "overlay_id"=>211}, {"name"=>"longitude0", "original_name"=>"longitude0", "statistics"=>{"median"=>-73.98684, "stdev"=>0.0153740677888511, "max"=>-73.936566, "mean"=>-73.9859414521499, "min"=>-74.0186, "variance"=>0.00023636196037619}, "data_type"=>"decimal", "id"=>711, "description"=>"", "overlay_id"=>211}, {"name"=>"text0", "original_name"=>"text0", "statistics"=>nil, "data_type"=>"string", "id"=>710, "description"=>"", "overlay_id"=>211}, {"name"=>"user_desc0", "original_name"=>"user_desc0", "statistics"=>nil, "data_type"=>"string", "id"=>709, "description"=>"", "overlay_id"=>211}, {"name"=>"latitude0", "original_name"=>"latitude0", "statistics"=>{"median"=>40.7517192, "stdev"=>0.0256158958626976, "max"=>40.870411, "mean"=>40.7513905197069, "min"=>40.703253, "variance"=>0.000656174120848569}, "data_type"=>"decimal", "id"=>708, "description"=>"", "overlay_id"=>211}, {"name"=>"place_ful0", "original_name"=>"place_ful0", "statistics"=>nil, "data_type"=>"string", "id"=>707, "description"=>"", "overlay_id"=>211}, {"name"=>"user_frie0", "original_name"=>"user_frie0", "statistics"=>{"median"=>175.0, "stdev"=>1076.58670789785, "max"=>15879.0, "mean"=>440.866449511401, "min"=>0.0, "variance"=>1159038.93962232}, "data_type"=>"decimal", "id"=>706, "description"=>"", "overlay_id"=>211}], "extent"=>[-74.018555649, 40.7035869555, -73.936555649, 40.8703869555], "tags"=>"", "link"=>"http://derekdev.dev.fortiusone.local/overlays/211.json", "description"=>"", "features" => features}.to_json

	
     
end
