class FakeClassName
  include Ars::Familiar
  include Ars::Familiar::Scribe
  scribable
  # def self.scribable
  #   {save: :me}
  # end
end

module Ars::Familiar
  RSpec.describe Scribe do

    xdescribe '.register(class_name)' do
      before { described_class.register('FakeClassName') }
      subject { described_class.register }

      it { is_expected.to contain_exactly 'FakeClassName' }
    end

    xdescribe '.commit()', type: :aruba do
      before { described_class.register('FakeClassName') }
      before { described_class.commit }
      subject { described_class.register.first.to_filename }

      example do
        is_expected.to be_an_existing_file
      end
    end

  end

  RSpec.describe Scribe::Entry do
    describe '.new(class_name)' do
      subject { described_class.new('FakeClassName') }

      it { is_expected.to eq 'FakeClassName' }

      context 'when a constant' do
        subject { described_class.new(FakeClassName) }

        it { is_expected.to eq 'FakeClassName' }
      end
    end

    context 'when an instance' do
      let(:instance) { described_class.new('FakeClassName') }

      describe '#to_filename' do
        subject { instance.to_filename }

        it { is_expected.to eq 'fake_class_name.dump' }
      end

      describe '#to_class' do
        subject { instance.to_class }

        it { is_expected.to eq FakeClassName }
      end
    end
  end
end
