RSpec.describe XMPPSimple::AuthMechanism do
  it 'is creatable' do
    stub_const('XMPPSimple::AuthMechanism::MECHANISM', 'foobar')
    expect { @stanza = XMPPSimple::AuthMechanism.create }.not_to raise_exception
  end

  it 'returns valid xml' do
    stub_const('XMPPSimple::AuthMechanism::MECHANISM', 'foobar')
    @stanza = XMPPSimple::AuthMechanism.create
    expect { Ox.parse(@stanza.to_xml) }.not_to raise_exception
    expect(@stanza.to_xml).to match('<auth xmlns="urn:ietf:params:xml:ns:xmpp-sasl" mechanism="foobar"/>')
  end
end
