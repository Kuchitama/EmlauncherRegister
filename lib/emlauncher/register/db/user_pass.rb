# coding: utf-8
require 'mysql2-cs-bind'
require 'emlauncher/register/log/log'

module Emlauncher
  module Register
    module DB
      class UserPass

        # conf hash of db configuration
        def initialize(conf = {})
          @insert_sql = "INSERT INTO user_pass(mail, passhash) values (?, '');"
          @select_mail = "SELECT up.mail mail from user_pass up;"
          
          @conf = {
            :host => 'localhost',
            :username => 'emlauncher',
            :password => 'xxxxxxxx',
            :database => 'emlauncher',
            :encoding => 'utf8'
          }
          
          @conf = conf if conf.empty? == false
          Emlauncher::Register::Log::LOGGER.info("db conf: #{@conf}")


        end
        
        def self.use_client
          client = Mysql2::Client.new(@conf)
          Emlauncher::Register::Log::LOGGER.debug("client: #{client}")
          yield client
        end
        
        def insert(mail)
          use_client do |client|
            client.xquery(@insert_sql, mail)
          end
        end
        
        def select_all()
          use_client do |client|
            result = client.xquery(@select_mail)
            result.map do |row|
              row["mail"]
            end
          end
        end
      end
    end
  end
end
