describe "#purchase_iap" do
  class TestIAP
    include PM::IAP
  end

  # mock_product = Struct.new(:productIdentifier, :localizedTitle, :localizedDescription, :price, :priceLocale, :isDownloadable, :downloadContentLengths, :downloadContentVersion)

  context "valid product" do
    it "successfully returns the transaction details" do
      subject = TestIAP.new
      subject.purchase_iap "productid" do |success, transaction|
        success.should.be.true
      end
    end
  end

end
