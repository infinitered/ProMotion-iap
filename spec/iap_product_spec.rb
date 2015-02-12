describe PM::IAP::Product do
  

  it "#retrieve" do
    subject = PM::IAP::Product.new("retrieveid")
    subject.mock!(:retrieve_iaps) do |product_ids, &callback|
      product_ids.should.include "retrieveid"
    end
    subject.retrieve do |products, error|
    end

  end

  it "#purchase" do
    subject = PM::IAP::Product.new("purchaseid")
    subject.mock!(:purchase_iaps) do |product_ids, &callback|
      product_ids.should.include "purchaseid"
    end
    subject.purchase do |status, transaction|
    end
  end

  it "#restore" do
    subject = PM::IAP::Product.new("restoreid")
    subject.mock!(:restore_iaps) do |product_ids, &callback|
      product_ids.should.include "restoreid"
      callback.call(:restored, [{product_id: "restoreid2"}, {product_id: "restoreid"}, {product_id: "restoreid4"}])
    end
    subject.restore do |status, product|
      status.should == :restored
      product.should == { product_id: "restoreid" }
    end
  end

end