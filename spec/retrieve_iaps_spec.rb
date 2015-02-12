describe "#retrieve_iaps" do
  class TestIAP
    include PM::IAP
  end

  mock_product = Struct.new(:productIdentifier, :localizedTitle, :localizedDescription, :price, :priceLocale, :isDownloadable, :downloadContentLengths, :downloadContentVersion)

  it "responds to #retrieve_iaps" do
    TestIAP.new.respond_to?(:retrieve_iaps).should.be.true
  end

  context "successful request" do

    it "returns an array of hashes with the result" do
      subject = TestIAP.new

      mock_response = Struct.new(:products, :error, :invalidProductIdentifiers).new([
        mock_product.new("id", "title", "desc", BigDecimal.new("0.99"), NSLocale.alloc.initWithLocaleIdentifier("en_US@currency=USD"), false, 0, nil)
      ], nil, [])

      subject.mock!(:completion_handlers, return: { "retrieve_iaps" => ->(products, error) {
        products.length.should == 1
        product = products.first
        product[:product_id].should == "id"
        product[:title].should == "title"
        product[:description].should == "desc"
        product[:price].should == BigDecimal.new("0.99")
        product[:formatted_price].should == "$0.99"
        product[:price_locale].should == NSLocale.alloc.initWithLocaleIdentifier("en_US@currency=USD")
        product[:downloadable].should == false
        product[:download_content_lengths].should == 0
        product[:download_content_version].should == nil

        error.should.be.nil
      } })

      subject.productsRequest(nil, didReceiveResponse:mock_response)
    end

  end

  context "unsuccessful request" do

    subject = TestIAP.new
    mock_response = Struct.new(:products, :error, :invalidProductIdentifiers).new([], "Invalid product ID", ["invalidproductid"])

    it "fails with error" do
      subject.mock!(:completion_handlers, return: {
        "retrieve_iaps" => ->(products, error) {
          products.length.should == 0
          error.error.should == "Invalid product ID"
        },
      })
      subject.request(nil, didFailWithError:mock_response)
    end

  end
end
