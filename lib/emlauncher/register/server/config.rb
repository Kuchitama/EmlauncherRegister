# coding: utf-8

require 'json'

module Emlauncher
  module Register
    module Server
      DEFAULT_CONFIG = {
        :emlauncher => {
          :host => "localhost",
          :is_secure => true,
        },
        :db => {
          :host => 'localhost',
          :username => 'emlauncher',
          :database => 'emlauncher',
          :encoding => 'utf8'
        },
        :address_filters => []
      }
      
     
      module Config
         # ハッシュのキーをsymbol化する
        def self.symbolize(hash)
          symbolized = {}
          hash.each do |k, v|
            if v.kind_of?(Hash)
              symbolized.merge!({ k.to_sym => symbolize(v)})
            else
              symbolized.merge!({ k.to_sym => v })
            end
          end
          
          symbolized
        end
        
        def self.get(config_path = nil)
          # jsonの読み込み処理
          if config_path.nil? == false 
            loaded_conf = File.open(config_path) do |io|
              JSON.load(io)
            end
          else 
            loaded_conf = {}
          end
          Emlauncher::Register::Log::LOGGER.info("loaded configuration: #{loaded_conf}")
          
          default_conf = DEFAULT_CONFIG.dup
          
          default_conf.merge(symbolize(loaded_conf))
        end
      end
    end
  end
end
