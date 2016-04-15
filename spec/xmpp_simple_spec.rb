RSpec.describe XMPPSimple do
  let(:msg) { 'foobar' }

  context 'with default logger' do
    before(:each) do
      XMPPSimple.log = true
      XMPPSimple.logger = nil # to_stdout needs to replace $stdout before Logger is created
    end

    it 'creates logger on access' do
      expect(XMPPSimple.logger).to be_a(Logger)
    end

    it 'prints debug messages to stdout' do
      expect { XMPPSimple.debug(msg) }.to output(/DEBUG.+foobar/).to_stdout
      expect { XMPPSimple.debug(msg) }.not_to output(/INFO.+foobar/).to_stdout
    end

    it 'prints info messages to stdout' do
      expect { XMPPSimple.info(msg) }.to output(/INFO.+foobar/).to_stdout
      expect { XMPPSimple.info(msg) }.not_to output(/DEBUG.+foobar/).to_stdout
    end

    it 'prints error messages to stdout' do
      expect { XMPPSimple.error(msg) }.to output(/ERROR.+foobar/).to_stdout
      expect { XMPPSimple.error(msg) }.not_to output(/DEBUG.+foobar/).to_stdout
    end

    it 'doesn\'t print messages with log level on fatal' do
      XMPPSimple.logger.level = Logger::FATAL
      expect { XMPPSimple.debug(msg) }.not_to output.to_stdout
      expect { XMPPSimple.info(msg) }.not_to output.to_stdout
      expect { XMPPSimple.error(msg) }.not_to output.to_stdout
    end
  end

  context 'with overridden logger' do
    before(:all) do
      XMPPSimple.logger = TestLogger.new
    end

    it 'delegates debug messages' do
      expect(XMPPSimple.debug(msg)).to match(msg)
    end

    it 'delegates info messages' do
      expect(XMPPSimple.info(msg)).to match(msg)
    end

    it 'delegates error messages' do
      expect(XMPPSimple.error(msg)).to match(msg)
    end
  end
end
