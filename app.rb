require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'sinatra'
require 'sinatra/json'
require 'sinatra/base'
require 'json'
require 'net/http'
require 'url'
require './models.rb'

helpers do

  def send_database(video_url, video_id, title, img_url )
    #===デバッグコード===
    $view = title
    $img = img_url
    $url = video_url 
    #------------
    # Database.create(video_url: video_url, video_id: video_id, title: title , img_url: img_url )
  end

  def youtube_api(youtube_url)
    p str = URI.escape("https://www.googleapis.com/youtube/v3/videos?id#{youtube_url.slice!(/\=.*$/)}&key=#{ENV["API_KEY"]}&fields=items(id,snippet(channelTitle,title,thumbnails),statistics)&part=snippet,contentDetails,statistics")
    uri = URI.parse(str)
    puts json = JSON.parse(Net::HTTP.get(uri))
    items = json['items']
    items.each do |data|
      if data['snippet']['thumbnails']['standard'].exists?
       send_database(str, data['id'], data['snippet']['title'], data['snippet']['thumbnails']['standard']['url'])
      else
       send_database(str, data['id'], data['snippet']['title'], data['snippet']['thumbnails']['default']['url'])
      end
    end
  end
end

get '/' do
  erb :index
end

post '/search' do
  youtube_api(params[:url])
  redirect '/'
end

get '/admin' do
  @videos = DataBase.all
end
