# coding: utf-8

require 'spec_helper'

describe Emlauncher::Register::Utils::MailDomainFilter do
  describe "isValid" do
    it "should return true if mail_domains contains mail address domain" do
      filters = Emlauncher::Register::Utils::MailDomainFilter::new(["yahoo.com", "gmail.com", "hoge.com"])
      filters.isValid?("hoge.fuga@gmail.com").should == true
    end
    
    it "should return false if mail_domains not contains mail address domain" do
      filters = Emlauncher::Register::Utils::MailDomainFilter::new(["yahoo.com" "gmail.com" "hoge.com"])
      
      filters.isValid?("hoge.fuga@mail.com").should == false
    end
  end
end
