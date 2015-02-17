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
      called_callback = false
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-successfulproductid" => ->(status, data) {
          status.should === :purchased
          data[:transaction].transactionState.should == SKPaymentTransactionStatePurchased
          data[:error].code.should.be.nil
          called_callback = true
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ successful_transaction ])
      called_callback.should.be.true
    end
  end

  context "canceled transaction" do
    canceled_transaction = mock_transaction.new(SKPaymentTransactionStateFailed, Struct.new(:code).new(SKErrorPaymentCancelled), mock_payment.new("canceledproductid"))

    it "returns nil error" do
      called_callback = false
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-canceledproductid" => ->(status, data) {
          status.should == :canceled
          data[:transaction].should == canceled_transaction
          data[:error].code.should == SKErrorPaymentCancelled
          called_callback = true
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ canceled_transaction ])
      called_callback.should.be.true
    end
  end

  context "invalid product" do
    invalid_transaction = mock_transaction.new(SKPaymentTransactionStateFailed, Struct.new(:code).new(nil), mock_payment.new("invalidproductid"))

    it "returns an error" do
      called_callback = false
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "purchase-invalidproductid" => ->(status, data) {
          status.should == :error
          data[:transaction].should == invalid_transaction
          data[:error].code.should.be.nil
          called_callback = true
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ invalid_transaction ])
      called_callback.should.be.true
    end
  end

end
