require 'celluloid/io'
require 'nokogiri'

require 'xmpp_simple/stanzas/base_stanza'
require 'xmpp_simple/stanzas/auth_mechanism'
require 'xmpp_simple/stanzas/plain_auth'
require 'xmpp_simple/stanzas/message'
require 'xmpp_simple/stanzas/iq'
require 'xmpp_simple/stanzas/bind'

require 'xmpp_simple/client'
require 'xmpp_simple/parser'
require 'xmpp_simple/node'
require 'xmpp_simple/jid'

require 'xmpp_simple/version'

module XMPPSimple
  module_function

  def logger=(value)
    @logger = value
  end

  def logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.level = Logger::ERROR
    end
  end
end
