require 'spec_helper'

describe Pronto::RailsDataSchema do
  it 'has a version number' do
    expect(Pronto::RailsDataSchemaVersion::VERSION).not_to be nil
  end

  subject { described_class.new(patches, nil).run }
  let(:schema_present) { true }

  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with('db/data_schema.rb')
                                   .and_return(schema_present)
  end

  context 'with no patches' do
    let(:patches) { nil }
    it 'adds no messages' do
      expect(subject.count).to eq 0
    end
  end

  context 'with patch but without migration files' do
    include_context 'test repo'
    let(:patches) { repo.diff('e0e21eab5bc017989c56124ac3f603c71023f59d') }

    it 'adds no messages' do
      expect(subject.count).to eq 0
    end
  end

  context 'with migration' do
    include_context 'test repo'
    context 'with schema.rb changes' do
      let(:patches) { repo.diff('4961d13a8e38822cb611b51d3b92f6a27536e08a') }

      it 'adds no messages' do
        expect(subject.count).to eq 0
      end
    end

    context 'without schema.rb changes' do
      let(:patches) { repo.diff('ec60d57b3a79145ef2ba7b18bd1e088361d99acb') }

      it 'adds warning message' do
        expect(subject.first.msg).to match(/Data migration/)
      end

      it 'adds warning message with line containing the commit_sha of migration file creation commit' do
        expect(subject.first.line.content).to match(/class ThirdDataMigration/)
        expect(subject.first.line.commit_sha).to eq 'e0e21eab5bc017989c56124ac3f603c71023f59d'
      end

      context 'without schema file' do
        let(:schema_present) { false }

        it 'adds no messages' do
          expect(subject.count).to eq 0
        end
      end
    end
  end
end
