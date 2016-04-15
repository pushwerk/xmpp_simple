RSpec.describe XMPPSimple::Iq do
  it 'is creatable' do
    expect { @stanza = XMPPSimple::Iq.create }.not_to raise_exception
  end

  it 'returns valid xml' do
    @stanza = XMPPSimple::Iq.create
    expect { Ox.parse(@stanza.to_xml) }.not_to raise_exception
    expect(@stanza.to_xml).to match('<iq id="bind_1" type="set"/>')
  end
end
