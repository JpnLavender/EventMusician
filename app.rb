require 'bundler/setup'
Bundler.require
require 'json'
require 'net/http'
require 'url'
require './models.rb'

# WebSocket用にマルチスレッド対応サーバであるthinを利用する（標準はWebrick）
set :server, 'thin'
set :sockets, Hash.new { |h, k| h[k] = [] }

helpers do

  def youtube_api(youtube_url)
    str = URI.escape("https://www.googleapis.com/youtube/v3/videos?id#{youtube_url.slice(/\=.*$/)}&key=#{ENV["API_KEY"]}&fields=items(id,snippet(channelTitle,title,thumbnails),statistics)&part=snippet,contentDetails,statistics")
    uri = URI.parse(str)
    puts $hash = JSON.parse(Net::HTTP.get(uri))#RubyようにJsonをHashに変換
    $hash['items'].each do |data|
      if data['snippet']['thumbnails']['standard']
        send_database(youtube_url, data['id'], data['snippet']['title'], data['snippet']['thumbnails']['standard']['url'])
      else
        send_database(youtube_url, data['id'], data['snippet']['title'], data['snippet']['thumbnails']['high']['url'])
      end
    end
  end

  def send_database(video_url, video_id, title, img_url )
    @video_url , @video_id , @title , @img_url = video_url , video_id , title , img_url
    Video.create(video_url: video_url, video_id: video_id, title: title , img_url: img_url )
  end

end

get '/' do
  @id = "send"
  if !request.websocket?
    erb :'home/index', :layout => :'layout/layout'
  else
    request.websocket do |ws|
      ws.onopen do
        settings.sockets[@id] << ws
      end
      ws.onmessage do |url|
        EM.next_tick do
          settings.sockets[@id].each do |s|
            youtube_api(url)
            s.send({ video: { video_id: @video_id, title: @title, video_url: @video_url , img_url: @img_url }}.to_json)
          end
        end
      end

      ws.onclose do
        warn("websocket closed")
        settings.sockets[@id].delete(ws)
      end
    end
  end
end

get '/admin' do 
  @videos = Video.all 
  erb :'admin/index', :layout => :'layout/layout'
end

get '/video_delete/:id' do
  Video.find_by(id: params[:id]).destroy
  redirect '/admin'
end
