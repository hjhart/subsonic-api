module Subsonic
  class Client
    include ::HTTParty

    API_VERSION = {
        '3.8' => '1.0.0',
        '3.9' => '1.1.1',
        '4.0' => '1.2.0',
        '4.1' => '1.3.0',
        '4.2' => '1.4.0',
        '4.3.1' => '1.5.0'
    }

    attr_accessor :url, :version, :api_version, :user, :uri_prepend

    def initialize(url, username, password, options={})
      pass_prefix = options[:enc] ? "enc:" : ""
      version = @version = options[:version] || API_VERSION.values.last
      @api_version = API_VERSION[@version] || version

      if(@api_version == '1.5.0')
        @uri_prepend = '/rest'
      end

      format = options[:format] || "json"

      Struct.new("User", :username, :password)
      @user = Struct::User.new(username, "#{pass_prefix}#{password}")
      username, password = @user.username, @user.password
  
      self.class.class_eval do
        base_uri url
        default_params :u => username, :p => password,
                       :v => version, :f => format, :c => "subsonic-rb.gem"
      end
    end

    def now_playing
      response = self.class.get(@uri_prepend + '/getNowPlaying.view')
      if response.code == 200
        response.parsed_response['subsonic-response']['nowPlaying']['entry']
      end
    end

    def say(message)
      response = self.class.post(@uri_prepend + '/addChatMessage.view', :query => {:message => message})
      response.code == 200 ? message : false
    end

    def messages
      response = self.class.get(@uri_prepend + '/getChatMessages.view')
      if response.code == 200
        chat_messages = response.parsed_response['subsonic-response']['chatMessages']['chatMessage']
        chat_messages.map do |msg|
          time = Time.at(msg['time'] / 1000)
          "[#{time.strftime("%b-%e")}] #{msg['username']}: #{msg['message']}"
        end
      end
    end

    def random_songs
      response = self.class.get(@uri_prepend + '/getRandomSongs')
      if response.code == 200
        response['subsonic-response']['randomSongs']['song']
      end
    end

    def add_song(*ids)
      count = ids.length
      ids = ids.join(',').gsub(/\s/, '')
      response = self.class.post(@uri_prepend + '/jukeboxControl.view', :query => {:action => 'add', :id => ids})
      response.code == 200 ? "#{count} songs added" : false
    end

  end
end
