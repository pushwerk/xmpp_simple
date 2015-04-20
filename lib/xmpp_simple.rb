require 'celluloid/io'
require 'nokogiri'
require 'xmpp_simple/version'
require 'xmpp_simple/stanzas/base_stanza'
require 'xmpp_simple/stanzas/auth_mechanism'
require 'xmpp_simple/stanzas/plain_auth'
require 'xmpp_simple/stanzas/message'
require 'xmpp_simple/stanzas/iq'
require 'xmpp_simple/stanzas/bind'
require 'xmpp_simple/client'
require 'xmpp_simple/api'
require 'xmpp_simple/jid'
require 'xmpp_simple/node'
require 'xmpp_simple/parser'

module XMPPSimple
  attr_writer :logger

  module_function

  def logger
    @logger ||= Logger.new($stdout).tap do |logger|
      logger.level = Logger::DEBUG
      logger.formatter = proc do |severity, datetime, progname, msg|
        "#{severity} :: #{datetime.strftime('%d-%m-%Y :: %H:%M:%S')} :: #{progname} :: #{msg}\n"
      end
    end
  end

  def debug(message)
    logger.debug(message.inspect)
  end

  def info(message)
    logger.info(message.inspect)
  end

  def error(message)
    logger.error(message.inspect)
  end
end
