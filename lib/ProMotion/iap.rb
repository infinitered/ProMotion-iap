module ProMotion
  module IAP
    attr_accessor :completion_handler

    def purchase_iap(product_id, &callback)
      iap_setup
      retrieve_iaps product_id do |products|
        products.each do |product|
          payment = SKPayment.paymentWithProduct(product)
          SKPaymentQueue.defaultQueue.addPayment(payment)
        end
      end
    end

    def restore_iap(&callback)

    end

    def retrieve_iaps(*product_ids, &callback)
      self.completion_handler = callback
      @products_request = SKProductsRequest.alloc.initWithProductIdentifiers(NSSet.setWithArray(product_ids.flatten))
      @products_request.delegate = self
      @products_request.start
    end
    alias retrieve_iap retrieve_iaps

    # private methods

    private def iap_setup
      SKPaymentQueue.defaultQueue.addTransactionObserver(self)
    end

    private def retrieved_iaps_handler(products, &callback)
      sk_products = products.map do |sk_product|
        {
          product_id:               sk_product.productIdentifier,
          title:                    sk_product.localizedTitle,
          description:              sk_product.localizedDescription,
          formatted_price:          formatted_iap_price(sk_product.price, sk_product.priceLocale),
          price:                    sk_product.price,
          price_locale:             sk_product.priceLocale,
          downloadable:             sk_product.isDownloadable,
          download_content_lengths: sk_product.downloadContentLengths,
          download_content_version: sk_product.downloadContentVersion,
        }
      end

      callback.call(sk_products)
    end

    private def formatted_iap_price(price, price_locale)
      num_formatter = NSNumberFormatter.new
      num_formatter.setFormatterBehavior NSNumberFormatterBehaviorDefault
      num_formatter.setNumberStyle NSNumberFormatterCurrencyStyle
      num_formatter.setLocale price_locale
      num_formatter.stringFromNumber price
    end

    # Cocoa Touch methods

    public def productsRequest(request, didReceiveResponse:response)
      retrieved_iaps_handler(response.products, &self.completion_handler)
      @products_request = nil
      self.completion_handler = nil
    end

    public def request(request, didFailWithError:error)
      if self.completion_handler.arity == 2
        self.completion_handler.call(false, error)
      else
        self.completion_handler.call(false)
      end
      @products_request = nil
      self.completion_handler = nil
    end

  end
end
