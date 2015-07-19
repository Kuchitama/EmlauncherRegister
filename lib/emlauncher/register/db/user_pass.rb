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
          @select_mail = "SELECT up.mail mail FROM user_pass up;"
          @delete_sql = "DELETE FROM user_pass WHERE user_pass.mail = ?;"
          
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
        
        def delete!(mail)
          use_client do |client|
            client.xquery(@delete_sql, mail)
          end
        end
        
        private
        def use_client
          client = Mysql2::Client.new(@conf)
          Emlauncher::Register::Log::LOGGER.debug("client: #{client}")
          yield client
        end
        
      end
    end
  end
end
