describe "#restore_iaps" do
  class TestIAP
    include PM::IAP
  end

  mock_transaction = Struct.new(:transactionState, :error, :productIdentifier) do
    def matchingIdentifier; end
  end

  it "responds to #restore_iaps" do
    TestIAP.new.respond_to?(:restore_iaps).should.be.true
  end

  context "restored transaction" do
    restored_transaction = mock_transaction.new(SKPaymentTransactionStateRestored, Struct.new(:code).new(nil), "restoredproductid")

    it "returns success" do
      subject = TestIAP.new
      subject.mock!(:completion_handlers, return: {
        "restore-restoredproductid" => ->(success, transaction) {
          success.should.be.true
        },
      })
      subject.paymentQueue(nil, updatedTransactions:[ restored_transaction ])
    end
  end

end
