RSpec.describe Touhou::Score do
  it "has a version number" do
    expect(Touhou::Score::VERSION).not_to be nil
  end

  it "紅魔郷クラスがある" do
    expect(Touhou::Score::Koumakyou).not_to be nil
  end
end
