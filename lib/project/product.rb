module ProMotion
  class IAP::Product
    include ProMotion::IAP

    attr_reader :product_id

    def initialize(product_id)
      @product_id = product_id
    end

    def retrieve(&callback)
      retrieve_iaps(product_id) do |products, error|
        callback.call products.first, error
      end
    end

    def purchase(&callback)
      purchase_iaps(product_id, &callback)
    end

    def restore(&callback)
      restore_iaps(product_id) do |status, products|
        callback.call status, products.find{|p| p[:product_id] == product_id }
      end
    end
  end
end
::PM = ProMotion unless defined?(PM)
