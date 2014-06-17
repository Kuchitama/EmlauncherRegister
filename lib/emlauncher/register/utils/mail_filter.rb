# coding: utf-8

require 'emlauncher/register/log/log'

module Emlauncher
  module Register
    module Utils
      class MailDomainFilter
        
        def initialize(mail_domains = [])
          @domain_regs = Array.new()
          
          mail_domains.each do |domain|
            @domain_regs.push(/^.+@#{domain}$/)
          end
          
          Emlauncher::Register::Log::LOGGER.info("domain filters: #{@domain_regs}")

        end
        
        # メールアドレスのバリデーション
        # 指定のホストに一致すればtrueを返す
        def isValid?(mail)
          @domain_regs.each do |reg|
            if reg =~ mail 
              return true
            end
          end
          
          return false
        end

      end
    end
  end
end
 
