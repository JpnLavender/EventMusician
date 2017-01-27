require 'bundler/setup'
Bundler.require

class Video < ActiveRecord::Base
  validates :video_id, uniqueness: true
end
