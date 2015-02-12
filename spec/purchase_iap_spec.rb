describe "#purchase_iap" do
  class TestIAP
    include PM::IAP
  end

  mock_transaction = Struct.new(:transactionState, :error, :productIdentifier) do
    def matchingIdentifier; end
  end

  it "responds to #purchase_iap" do
    TestIAP.new.respond_to?(:purchase_iap).should.be.true
  end

  context "successful transaction" do
    successful_transaction = mock_transaction.new(SKPaymentTransactionStatePurchased, Struct.new(:code).new(nil), "successfulproductid")

    it "returns success" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-successfulproductid" => ->(success, transaction) {
          success.should.be.true
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ successful_transaction ])
    end
  end

  context "canceled transaction" do
    canceled_transaction = mock_transaction.new(SKPaymentTransactionStateFailed, Struct.new(:code).new(SKErrorPaymentCancelled), "canceledproductid")

    it "returns nil error" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-canceledproductid" => ->(success, transaction) {
          success.should.be.nil
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ canceled_transaction ])
    end
  end

  context "invalid product" do
    invalid_transaction = mock_transaction.new(SKPaymentTransactionStateFailed, Struct.new(:code).new(nil), "invalidproductid")

    it "returns an error" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-invalidproductid" => ->(success, transaction) {
          success.should.be.false
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ invalid_transaction ])
    end
  end

end
