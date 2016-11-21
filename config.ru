require 'bundler'
Bundler.require
require './app'
require 'activerecord-refresh_connection'

use ActiveRecord::ConnectionAdapters::RefreshConnectionManagement

run Sinatra::Application
