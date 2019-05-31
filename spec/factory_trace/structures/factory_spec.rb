RSpec.describe FactoryTrace::Structures::Factory do
  describe '#==' do
    let(:user_factory) { find_factory('user') }
    let(:comment_factory) { find_factory('comment') }
    let(:article_factory) { find_factory('article') }

    it { expect(user_factory == user_factory).to be_truthy }
    it { expect(comment_factory == comment_factory).to be_truthy }
    it { expect(article_factory == article_factory).to be_truthy }

    it { expect(user_factory == comment_factory).to be_falsey }
    it { expect(user_factory == article_factory).to be_falsey }
    it { expect(comment_factory == article_factory).to be_falsey }
  end
end
