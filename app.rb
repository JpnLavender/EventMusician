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
    p str = URI.escape("https://www.googleapis.com/youtube/v3/videos?id#{youtube_url.slice!(/\=.*$/)}&key=#{ENV["API_KEY"]}&fields=items(id,snippet(channelTitle,title,thumbnails),statistics)&part=snippet,contentDetails,statistics")
    uri = URI.parse(str)
    puts $hash = JSON.parse(Net::HTTP.get(uri))#RubyようにJsonをHashに変換
    $hash['items'].each do |data|
      if data['snippet']['thumbnails']['standard']
        send_database(str, data['id'], data['snippet']['title'], data['snippet']['thumbnails']['standard']['url'])
      else
        send_database(str, data['id'], data['snippet']['title'], data['snippet']['thumbnails']['high']['url'])
      end
    end
  end

  def send_database(video_url, video_id, title, img_url )
    # Database.create(video_url: video_url, video_id: video_id, title: title , img_url: img_url )
  end

end

get '/' do
  @id = "send"
  if !request.websocket?
    erb :index
  else
    request.websocket do |ws|
      ws.onopen do
        settings.sockets[@id] << ws
      end
      # websocketのメッセージを受信したとき
      ws.onmessage do |url|
        EM.next_tick do
          settings.sockets[@id].each do |s|
            youtube_api(url)
            s.send($hash.to_json)
          end
        end
      end

      # websocketのコネクションが閉じられたとき
      ws.onclose do
        warn("websocket closed")
        settings.sockets[@id].delete(ws)
      end
    end
  end
end

get '/admin' do 
  erb :admin
end
