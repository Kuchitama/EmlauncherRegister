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
            @user_pass.insert!(mail)
            
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
        
        # Basic認証
        helpers do
          def authenticate!
            unless authorized?
              response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
              throw(:halt, [401, "Not authorized\n"])
            end
          end
          def authorized?
            @auth ||=  Rack::Auth::Basic::Request.new(request.env)
            if @auth.provided? && @auth.basic? && @auth.credentials then
              return @config[:admins].any?{|admin| @auth.credentials == [admin["username"], admin["password"]]}
            else 
              return false
            end
          end
        end
        
        get '/users' do
          authenticate!
          
          eruby = Erubis::Eruby.new(File.read(File.join(@views_path, 'users.html.eruby')))
          eruby.result(:mails => @user_pass.select_all )
        end
        
        get '/users/delete' do
          authenticate!
          
          @mail = params['mail']
          @user_pass.delete!(@mail)
          
          redirect '/users/deleted'
        end
        
        get '/users/deleted' do
          authenticate!
          
          "finish to delete mail. <a href='/users'>戻る</a>"
        end
        
        get '/logout' do 
            throw(:halt, [401, "Logouted\n"])
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
