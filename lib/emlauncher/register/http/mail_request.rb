# coding: utf-8

require 'emlauncher/register/log/log'

module Emlauncher
  module Register
    module Http
      class MailRequest
        def initialize(host, secure = true)
          @host = host
          if secure then
            @scheme = "https"
          else
            @scheme = "http"
          end
        end
        
        def requestToSendPassRefreshPass(mail)
          uri = URI.parse("#{@scheme}://#{@host}/login/password_confirm")
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = (@scheme == "https")
           
          http.start do |h|
            #リクエストインスタンス生成
            request = Net::HTTP::Post.new(uri.path)
            request.set_form_data({"email"=>mail})
            
            #time out
            h.open_timeout = 30
            h.read_timeout = 30
            
            response = h.request(request)
            Emlauncher::Register::Log::LOGGER.info("response status: #{response.code}")
            code = response.code.to_i

            if code < 200 || 400 <= code then
              raise "Failed to access. status[#{code}] to[#{uri.host}]" 
            end
          end
        end
 
      end
    end
  end
end

