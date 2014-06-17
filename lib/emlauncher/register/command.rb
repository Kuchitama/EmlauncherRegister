# coding: utf-8

require 'emlauncher/register/command/option'
require 'erubis'

module Emlauncher
  module Register
    # コマンドラインベースの処理を行うクラス
    # @authore kuchitama
    class Command
    
      def self.run(argv)
        new(argv).execute
      end

      def initialize(argv)
        @argv = argv
      end
      
      def execute
        puts "argv: #{@argv}"
        options = Emlauncher::Register::Command::Options.parse!(@argv)
        puts "options: #{options}"
        sub_command = options.delete(:command)

        case sub_command
          when 'run'
            # TODO
            run_server(options)
        end
      rescue => e
          abort "Error: #{e.message}"
      end

      def run_server(opts)
        default_conf_path = File.expand_path(File::join(File::dirname(__FILE__), "..", ".." ,"..", "config.json"))
        default_conf = {:port => 4567, :conf => default_conf_path}
       
        conf = default_conf.merge(opts)
        
        conf_path = conf[:conf]
        
        puts 'Start server process...'

        # generate 'config.ru' from 'config.ru.eruby'
        eruby_path = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'config.ru.eruby'))
        eruby = Erubis::Eruby.new(File.read(eruby_path))
        rack_config = File.join(File.dirname(eruby_path), 'config.ru')

        File.open(rack_config, 'w') do |f|
          f.write(eruby.result(:path => conf_path))
        end
        
        #rack_config = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'config.ru'))
        exec "cd #{File.dirname(rack_config)} && rackup -E production -p #{conf[:port]} ./config.ru"
      end
      
    end
  end
end
