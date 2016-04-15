RSpec.describe XMPPSimple::Jid do
  it 'fails when username doesn\'t contain @ and no host is set' do
    expect { XMPPSimple::Jid.new('foobar') }.to raise_exception('set either host or username@host')
  end

  context 'username with @ and no host' do
    it 'does\'t fail' do
      expect { XMPPSimple::Jid.new('foobar@bar.de') }.not_to raise_exception
    end

    it 'returns domain' do
      jid = XMPPSimple::Jid.new('foobar@bar.de')
      expect(jid.domain).to match('bar.de')
    end

    it 'returns username' do
      jid = XMPPSimple::Jid.new('foobar@bar.de')
      expect(jid.username).to match('foobar')
    end

    it 'concats username and domain' do
      jid = XMPPSimple::Jid.new('foobar@bar.de')
      expect(jid.to_s).to match('foobar@bar.de')
    end
  end

  context 'username with @ and host is set' do
    it 'does\'t fail' do
      expect { XMPPSimple::Jid.new('foobar@bar.de', 'lorem.ipsum') }.not_to raise_exception
    end

    it 'returns domain' do
      jid = XMPPSimple::Jid.new('foobar@bar.de', 'lorem.ipsum')
      expect(jid.domain).to match('bar.de')
    end

    it 'returns username' do
      jid = XMPPSimple::Jid.new('foobar@bar.de', 'lorem.ipsum')
      expect(jid.username).to match('foobar')
    end

    it 'concats username and domain' do
      jid = XMPPSimple::Jid.new('foobar@bar.de', 'lorem.ipsum')
      expect(jid.to_s).to match('foobar@bar.de')
    end
  end

  context 'username without @ and host is set' do
    it 'does\'t fail' do
      expect { XMPPSimple::Jid.new('foobar', 'lorem.ipsum') }.not_to raise_exception
    end

    it 'returns domain' do
      jid = XMPPSimple::Jid.new('foobar', 'lorem.ipsum')
      expect(jid.domain).to match('lorem.ipsum')
    end

    it 'returns username' do
      jid = XMPPSimple::Jid.new('foobar', 'lorem.ipsum')
      expect(jid.username).to match('foobar')
    end

    it 'concats username and domain' do
      jid = XMPPSimple::Jid.new('foobar', 'lorem.ipsum')
      expect(jid.to_s).to match('foobar@lorem.ipsum')
    end
  end
end
