# This program is free software; you can redistribute it and/or modify it under the terms of the GNU
# General Public License as published by the Free Software Foundation; either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.

require 'shortbus'
require_relative 'credentials'

# Remote control plugin
module Remote
  class RemoteShortBus < ShortBus::ShortBus
    def initialize()
      super
      @commandregex = Regexp.new(":#{PASSPHRASE}\s+(.*)")
      @execregex = /^exec/i
      hook_server('PRIVMSG', ShortBus::XCHAT_PRI_NORM, method(:process_message))
    end

    # Processes an incoming server message
    # * words[0] -> ':' + user that sent the text
    # * words[1] -> PRIVMSG
    # * words[2] -> channel
    # * words[3..(words.size-1)] -> ':' + text
    # * words_eol is the joining of each array of words[i..words.size]
    # * (e.g. ["all the words", "the words", "words"]
    def process_message(words, words_eol, data)
      if(3 < words_eol.size && (match = @commandregex.match(words_eol[3])))
        if(!@execregex.match(match[1]))
          command(match[1])
        end
      end

      return ShortBus::XCHAT_EAT_NONE
    end
  end # RemoteShortBus
end # Remote
