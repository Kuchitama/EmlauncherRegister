# coding: utf-8

require 'spec_helper'

expected = 
{
        :emlauncher => {
          :host => "localhost",
          :is_secure => true,
        },
        :db => {
          :host => "localhost", 
          :username => 'username',
          :password => "password",
          :database => 'emlauncher',
          :encoding => 'utf8'
        },
        :address_filters => ["hoge", "fuga"]
      }

describe Config do
  describe "load" do
    loaded = Emlauncher::Register::Server::Config::get("spec/resources/test_valid.json")

    loaded.should == expected
  end
end
