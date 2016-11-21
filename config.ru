require 'bundler'
Bundler.require
require './app'

use ActiveRecord::ConnectionAdapters::RefreshConnectionManagement
