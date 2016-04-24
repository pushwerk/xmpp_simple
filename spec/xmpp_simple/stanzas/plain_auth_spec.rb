RSpec.describe XMPPSimple::PlainAuth do
  let(:jid) { XMPPSimple::Jid.new('foo', 'bar') }

  it 'is creatable' do
    stub_const('XMPPSimple::PlainAuth::NAME', 'foobar')
    expect { @stanza = XMPPSimple::PlainAuth.create(jid, 'bar') }.not_to raise_exception
  end

  it 'returns valid xml' do
    stub_const('XMPPSimple::PlainAuth::NAME', 'foobar')
    expected = '<foobar xmlns="urn:ietf:params:xml:ns:xmpp-sasl" mechanism="PLAIN">AGZvb0BiYXIAYmFy</foobar>'
    @stanza = XMPPSimple::PlainAuth.create(jid, 'bar')
    expect { Nokogiri::XML(@stanza.to_xml) }.not_to raise_exception
    expect(@stanza.to_xml).to be_equivalent_to(expected)
  end
end
