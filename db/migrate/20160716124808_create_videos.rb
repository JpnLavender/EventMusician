class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :video_id, nil: false, default: "3rJTJJc458c"
      t.string :video_url, nil: false, default: "https://www.youtube.com/watch?v=3rJTJJc458c"
      t.string :title, nil: false, default: "ポケモンダイヤモンドパールプラチナ チャンピオン シロナBGM "
      t.string :img_url, nil: false, default: "https://i.ytimg.com/vi/3rJTJJc458c/hqdefault.jpg"
      t.timestamps null: false
    end
  end
end
