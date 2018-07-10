RSpec.describe Touhou::Score::Koumakyou::BinaryData do
  describe "read_raw" do
    it "readメソッドは現在位置を進めながら読む" do
      b = Touhou::Score::Koumakyou::BinaryData.new("12345")
      
      expect(b.read_raw(3)).to eq("123")
      expect(b.current).to eq(3)
    end
  end

  describe "read_int*" do
    it "整数値を読む" do
      b = Touhou::Score::Koumakyou::BinaryData.new([1,2,3,4,5].pack('C*'))
      
      expect(b.read_int8).to eq(0b00000001)
      expect(b.read_int16).to eq(0b0000001100000010)
    end
  end
end
