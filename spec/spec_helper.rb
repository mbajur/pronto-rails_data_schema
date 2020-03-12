$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pronto/rails_data_schema'

RSpec.shared_context 'test repo' do
  let(:git) { 'spec/fixtures/test.git/git' }
  let(:dot_git) { 'spec/fixtures/test.git/.git' }

  before { FileUtils.mv(git, dot_git) }
  let(:repo) { Pronto::Git::Repository.new('spec/fixtures/test.git') }
  after { FileUtils.mv(dot_git, git) }
end
