require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra'
require 'sinatra/json'
require 'sinatra/base'
require 'json'
require 'net/http'
require 'url'

get '/' do
  erb :index
end

post '/search' do
  str = URI.escape("https://www.googleapis.com/youtube/v3/videos?id#{params[:url].slice!(/\=.*$/)}&key=#{ENV["API_KEY"]}&fields=items(id,snippet(channelTitle,title,thumbnails),statistics)&part=snippet,contentDetails,statistics")
  uri = URI.parse(str)
  puts Net::HTTP.get(uri)
end
