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
  attr_accessor :log

  module_function :log, :log=

  module_function

  @log = false

  def logger
    @logger ||= Logger.new($stdout).tap do |logger|
      logger.level = Logger::DEBUG
    end
  end

  def logger=(logger)
    raise 'Logger needs to define: debug, info, error' unless logger.nil? ||
                                                              (logger.respond_to?(:debug) &&
                                                              logger.respond_to?(:info) &&
                                                              logger.respond_to?(:error))
    @logger = logger
  end

  def debug(message)
    logger.debug(message.inspect) if @log
  end

  def info(message)
    logger.info(message.inspect) if @log
  end

  def error(message)
    logger.error(message.inspect) if @log
  end
end
