RSpec.describe XMPPSimple::Bind do
  it 'is creatable' do
    expect { @stanza = XMPPSimple::Bind.create }.not_to raise_exception
  end

  it 'returns valid xml' do
    @stanza = XMPPSimple::Bind.create
    expect { Nokogiri::XML(@stanza.to_xml) }.not_to raise_exception
    expected = '<iq id="bind_1" type="set"><bind xmlns="urn:ietf:params:xml:ns:xmpp-bind"/></iq>'
    expect(@stanza.to_xml).to be_equivalent_to(expected)
  end
end
