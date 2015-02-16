describe "#restore_iaps" do
  class TestIAP
    include PM::IAP
  end

  mock_transaction = Struct.new(:transactionState, :error, :payment) do
    def matchingIdentifier; end
  end
  mock_payment = Struct.new(:productIdentifier)

  it "responds to #restore_iaps" do
    TestIAP.new.respond_to?(:restore_iaps).should.be.true
  end

  context "restored transaction" do
    restored_transaction = mock_transaction.new(SKPaymentTransactionStateRestored, Struct.new(:code).new(nil), mock_payment.new("restoredproductid"))

    it "returns success" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "restore-restoredproductid" => ->(status, transaction) {
          status.should == :restored
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ restored_transaction ])
    end
  end

  context "error in restore" do
    restored_transaction = mock_transaction.new(SKPaymentTransactionStateRestored, Struct.new(:code).new(nil), mock_payment.new("restoredproductid"))

    it "returns success" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "restore-all" => ->(status, transaction) {
          status.should == :error
          transaction.localizedDescription.should == "Failed to restore"
        },
      })
      subject.paymentQueue(nil, restoreCompletedTransactionsFailedWithError:Struct.new(:localizedDescription).new("Failed to restore"))
    end
  end

end
