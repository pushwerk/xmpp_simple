# XmppSimple

A simle xmpp implementation using celluloid
intended to work with https://github.com/pushwerk/ccs

## Installation

Add this line to your application's Gemfile:

    gem 'xmpp_simple', '~> 0.1'

And then execute:

    $ bundle

## Usage

```
class XMPPConnection
  def initialize
    xmpp_params = {
      handler: self,
      username: 'foobar',
      password: 's3cr3t',
      host: 'jabber.example.com',
      port: 5222
    }
    @xmpp_client = XMPPSimple::Client.new(xmpp_params).connect
  end

  def send(xml)
    @xmpp_client.write_data(xml)
  end

  # methods called by XMPPSimple
  def message(node)
    puts "received #{node.inspect}"
  end

  def disconnected
    puts 'disconnected'
  end

  def connected
    puts 'connected'
  end
end
```

## TODO
* Probably more tests

## Contributing

1. Fork it ( https://github.com/pushwerk/xmpp_simple/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
