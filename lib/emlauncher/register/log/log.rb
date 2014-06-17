# coding: utf-8
require 'logger'

module Emlauncher
  module Register
    module Log
      LOGGER = Logger.new(File::join(Dir::pwd(), "application.log"), 5)
    end
  end
end
