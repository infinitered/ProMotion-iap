describe "#purchase_iap" do
  class TestIAP
    include PM::IAP
  end

  mock_transaction = Struct.new(:transactionState, :error, :payment) do
    def matchingIdentifier; end
  end
  mock_payment = Struct.new(:productIdentifier)

  it "responds to #purchase_iap" do
    TestIAP.new.respond_to?(:purchase_iap).should.be.true
  end

  context "successful transaction" do
    successful_transaction = mock_transaction.new(SKPaymentTransactionStatePurchased, Struct.new(:code).new(nil), mock_payment.new("successfulproductid"))

    it "returns success" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-successfulproductid" => ->(success, transaction) {
          success.should === :purchased
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ successful_transaction ])
    end
  end

  context "canceled transaction" do
    canceled_transaction = mock_transaction.new(SKPaymentTransactionStateFailed, Struct.new(:code).new(SKErrorPaymentCancelled), mock_payment.new("canceledproductid"))

    it "returns nil error" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-canceledproductid" => ->(success, transaction) {
          success.should == :canceled
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ canceled_transaction ])
    end
  end

  context "invalid product" do
    invalid_transaction = mock_transaction.new(SKPaymentTransactionStateFailed, Struct.new(:code).new(nil), mock_payment.new("invalidproductid"))

    it "returns an error" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-invalidproductid" => ->(success, transaction) {
          success.should == :error
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ invalid_transaction ])
    end
  end

end
