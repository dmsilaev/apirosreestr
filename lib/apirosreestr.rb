require 'virtus'
require 'logger'
require 'json'
require 'faraday'
require 'pry'

require "apirosreestr/version"
require "apirosreestr/api"
require "apirosreestr/client"
require "apirosreestr/configuration"
require "apirosreestr/exceptions"

module Apirosreestr
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
