#--
# Copyright (c) 2016 Translation Exchange, Inc.
#
#
#  _______                  _       _   _             ______          _
# |__   __|                | |     | | (_)           |  ____|        | |
#    | |_ __ __ _ _ __  ___| | __ _| |_ _  ___  _ __ | |__  __  _____| |__   __ _ _ __   __ _  ___
#    | | '__/ _` | '_ \/ __| |/ _` | __| |/ _ \| '_ \|  __| \ \/ / __| '_ \ / _` | '_ \ / _` |/ _ \
#    | | | | (_| | | | \__ \ | (_| | |_| | (_) | | | | |____ >  < (__| | | | (_| | | | | (_| |  __/
#    |_|_|  \__,_|_| |_|___/_|\__,_|\__|_|\___/|_| |_|______/_/\_\___|_| |_|\__,_|_| |_|\__, |\___|
#                                                                                        __/ |
#                                                                                       |___/
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

module Trex
  module Commands
    class Remote < Trex::Commands::Base
      namespace :remote

      map 'a' => :add
      desc 'add', 'adds a TrEx service location'
      method_option :name, :type => :string, :aliases => '-n', :required => false, :banner => 'remote name', :default => nil
      method_option :host, :type => :string, :aliases => '-h', :required => false, :banner => 'host url (starting with http[s]://)', :default => nil
      def add
        say('Please provide the following information for setting up a TrEx remote host:')
        name = options[:name] || ask('What is the name of this remote? ')

        unless remotes[name].nil?
          return unless yes?('This remote already exists, would you like to overwrite it? (Y/n)')
        end

        url = options[:host] || ask('Remote URL (starting with http/s): ')
        remotes[name] = {
            'url' => url,
        }

        update_config

        say('Configuration has been updated')
      end

      map 'l' => :list
      desc 'list', 'lists all configured TrEx services'
      def list
        paginate(remote_list, {
            :header => 'Tr8n services:',
            :with_numbers => true
        })
        say("'Default service: #{current_config['remote']}'")
        say
      end

      map 'r' => :remove
      desc 'remove', 'removes a remote TrEx service'
      def remove
        paginate(remote_list, {
            :header => 'Trex services:',
            :with_numbers => true
        })

        say('Note: all applications from this remote service will be removed. Which service would you like to remove?')
        value = ask_for_number(remote_list.size)
        remote = remote_list[value-1]
        remotes.delete(remote['key'])
        update_config

        say('The remote has been removed')
        say
      end
    end
  end
end
