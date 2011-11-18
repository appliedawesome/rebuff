require 'rubygems'
require 'bundler'
Bundler.require(:default)

$: << File.join(File.dirname(__FILE__), "lib")
require 'rebuff'

run Rebuff::Application