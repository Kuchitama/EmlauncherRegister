# coding: utf-8

require 'sinatra/base'
require 'erubis'
require 'net/http'
require 'emlauncher/register/db/user_pass'
require 'emlauncher/register/log/log'
require 'emlauncher/register/http/mail_request'
require 'emlauncher/register/server/config'
require 'emlauncher/register/utils/mail_filter'

module Emlauncher
  module Register
    module Server
      class Application < Sinatra::Base
       
        # indexページの表示
        # /の有無を無視
        get '/?' do 
          eruby = Erubis::Eruby.new(File.read(File.join(@views_path, 'index.html.eruby')))
          eruby.result()
        end
        
        # 登録処理
        post '/register' do
          begin
            mail = params[:mail]
            
            if @mail_filters.isValid?(mail) == false
              raise "invalid mail address."
            end
            Emlauncher::Register::Log::LOGGER.info("posted mail: #{mail}")
            #sql実行
            @user_pass.insert(mail)
            
            # passwd forgetの呼び出し
            @mail_request.requestToSendPassRefreshPass(mail)

            # リダイレクト
            redirect '/registered'
          rescue => e
            Emlauncher::Register::Log::LOGGER.error("#{e}")
            Emlauncher::Register::Log::LOGGER.error(e.backtrace.join("\n\t"))

            status 500
            body "Error is occured. #{e}"
          end
        end
        
        # 完了画面表示
        get '/registered' do
          eruby = Erubis::Eruby.new(File.read(File.join(@views_path, 'registered.html.eruby')))
          eruby.result()
        end
        
        def initialize(conf_path = nil)       
          @views_path = File.expand_path(File.join(File.dirname(__FILE__), 'views'))
          @config = Emlauncher::Register::Server::Config::get(conf_path)
          Emlauncher::Register::Log::LOGGER.info("server configuration: #{@config}")

          @mail_request = Emlauncher::Register::Http::MailRequest.new(@config[:emlauncher][:host], @config[:emlauncher][:is_secure]) 
          @user_pass = Emlauncher::Register::DB::UserPass.new(@config[:db])
          @mail_filters = Emlauncher::Register::Utils::MailDomainFilter.new(@config[:address_filters])
        end
        
      end
    end
  end
end
