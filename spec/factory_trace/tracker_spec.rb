RSpec.describe FactoryTrace::Tracker do
  subject(:tracker) { described_class.new }

  describe "#track!" do
    before { tracker.track! }

    it "collects used factories without traits" do
      build(:user)

      expect(tracker.storage).to eq("user" => Set.new)
    end

    it "collects used factories with traits" do
      build(:user, :with_phone)

      expect(tracker.storage).to eq("user" => Set.new(["with_phone"]))
    end

    it "collects used factories with global traits" do
      build(:user, :with_address)

      expect(tracker.storage).to eq("user" => Set.new(["with_address"]))
    end

    it "collects all used factories" do
      build(:user)
      build(:admin, :with_phone, :with_email)
      build(:company, :with_address)

      expect(tracker.storage).to eq("user" => Set.new, "admin" => Set.new(["with_phone", "with_email"]), "company" => Set.new(["with_address"]))
    end
  end
end
