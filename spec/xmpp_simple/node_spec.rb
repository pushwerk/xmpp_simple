RSpec.describe XMPPSimple::Node do
  it 'doesn\'t create node without params' do
    expect { XMPPSimple::Node.new }.not_to raise_exception
  end

  it 'creates node with name' do
    node = XMPPSimple::Node.new('foobar')
    expect(node.name).to match('foobar')
  end

  it 'creates node with name, attrs' do
    Struct.new('Attribute', :localname, :value)
    attrs = []
    attrs << Struct::Attribute.new('foo', 'bar')
    attrs << Struct::Attribute.new('oof', 'rab')
    node = XMPPSimple::Node.new('foobar', attrs)
    expect(node.name).to match('foobar')
    expect(node.attributes.size).to eq 2
    expect(node.attributes['foo'].value).to match('bar')
    expect(node.attributes['oof'].value).to match('rab')
  end

  it 'creates node with name, ns' do
    ns = { 'foo' => 'bar', 'oof' => 'rab' }
    node = XMPPSimple::Node.new('foobar', [], ns)
    expect(node.name).to match('foobar')
    expect(node.namespaces.size).to eq 2
    expect(node.namespaces['xmlns:foo']).to match('bar')
    expect(node.namespaces['xmlns:oof']).to match('rab')
  end

  it 'creates node with name, doc' do
    doc = Nokogiri::XML::Document.new
    node = XMPPSimple::Node.new('foobar', [], [], doc)
    expect(node.document).to eq(doc)
  end

  it 'returns value for at' do
    node = XMPPSimple::Node.new('foobar')
    expect(node.at('//foobar').name).to match('foobar')
  end

  it 'returns value for xpath' do
    node = XMPPSimple::Node.new('foobar')
    expect(node.xpath('//foobar')[0].name).to match('foobar')
  end
end
