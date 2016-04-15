# XmppSimple

A simle xmpp parser gem with PLAIN auth

## Installation

Add this line to your application's Gemfile:

    gem 'xmpp_simple', git: 'https://github.com/l3akage/xmpp_simple.git'

And then execute:

    $ bundle

## Usage

```
class XMPPConnection
  def initialize
    @xmpp_client = XMPPSimple::Client.new(self,
                                          username,
                                          password,
                                          host,
                                          port).connect
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

  def reconnecting
    puts 'reconnecting'
  end
end
```

## TODO
* Documentation?
* Probably more tests

## Contributing

1. Fork it ( https://github.com/l3akage/xmpp_simple/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
