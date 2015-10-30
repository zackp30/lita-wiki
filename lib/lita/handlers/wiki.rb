require 'media_wiki'
module Lita
  module Handlers
    class Wiki < Handler
      @aliases = {'mcwiki': 'http://minecraft.gamepedia.com/api.php'}
      def get_page(wiki, name)
        client = MediaWiki::Gateway.new(wiki)
        resp = client.get(name)[1..50]
        return 'Not found' unless resp
        return resp
      end
      route(/^wiki (.+)/) do |response|
        response.reply(get_page(response.args[0]))
      end
      @aliases.each_pair do |k, w|
        route(/^#{k} (.+)/) do |response|
          response.reply(get_page("#{w}", "#{response.args[0]}"))
        end
      end
      Lita.register_handler(self)
    end
  end
end
