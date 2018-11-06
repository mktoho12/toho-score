RSpec.describe Touhou::Score::Koumakyou::BinaryData do
  describe "read raw" do
    it "readメソッドは現在位置を進めながら読む" do
      b = Touhou::Score::Koumakyou::BinaryData.new("12345")

      expect(b.read_raw(3)).to eq("123")
      expect(b.current).to eq(3)
    end
  end

  describe "read int*" do
    it "整数値を読む" do
      b = Touhou::Score::Koumakyou::BinaryData.new([1,2,3,4,5].pack('C*'))

      expect(b.read_int8).to eq(0b0000_0001)
      expect(b.read_int16).to eq(0b0000_0011_0000_0010)
    end
  end
end
