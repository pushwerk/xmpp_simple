RSpec.describe XMPPSimple::Bind do
  it 'is creatable' do
    expect { @stanza = XMPPSimple::Bind.create }.not_to raise_exception
  end

  it 'returns valid xml' do
    @stanza = XMPPSimple::Bind.create
    expect { Ox.parse(@stanza.to_xml) }.not_to raise_exception
    expected = <<-EXPECTED
<iq id="bind_1" type="set">
  <bind xmlns="urn:ietf:params:xml:ns:xmpp-bind"/>
</iq>
EXPECTED
    expect(@stanza.to_xml).to match(expected.chop)
  end
end
