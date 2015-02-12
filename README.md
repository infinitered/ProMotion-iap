# ProMotion-iap

[![Gem Version](https://badge.fury.io/rb/ProMotion-iap.svg)](http://badge.fury.io/rb/ProMotion-iap)
[![Build Status](https://travis-ci.org/clearsightstudio/ProMotion-iap.svg)](https://travis-ci.org/clearsightstudio/ProMotion-iap) 

ProMotion-iap is in-app purchase notification support for the
 popular RubyMotion gem [ProMotion](https://github.com/clearsightstudio/ProMotion).

## Installation

```ruby
gem 'ProMotion-iap'
```

## Usage

### IAP::Product Class

The `Product` class is an abstraction layer that provides a simpler interface when working with a single IAP product.
 If you are dealing with multiple products you will want to use the IAP Module directly (documented below).

```ruby
class PurchaseScreen < PM::Screen

  def on_load

    product = PM::IAP::Product.new("productid")

    product.retrieve do |product, error|
      # product looks something like the following
      {
        product_id:               "productid1",
        title:                    "title",
        description:              "description",
        price:                    <BigDecimal 0.99>,
        formatted_price:          "$0.99",
        price_locale:             <NSLocale>,
        downloadable:             false,
        download_content_lengths: <?>, # TODO: ?
        download_content_version: <?>, # TODO: ?
        product:                  <SKProduct>
      }
    end

    product.purchase do |status, transaction|
      case status
      when :in_progress
        # Usually do nothing, maybe a spinner
      when :deferred
        # Waiting on a prompt to the user
      when :purchased
        # Notify the user, update any affected UI elements
      when :canceled
        # They just canceled, no big deal.
      when :error
        # Failed to purchase
        transaction.error.localizedDescription # => error message
      end
    end

    product.restore do |status, products|
      if status == :restored
        # Update your UI, notify the user
      end
    end

  end
end

```

#### Product.new(product_id)

Stores the product_id for use in the class methods.

#### retrieve(&callback)

Retrieves the product.

#### purchase(&callback)

Begins a purchase of the product.

#### restore(&callback)

Begins a restoration of the previously purchased product.


### IAP Module

Include `PM::IAP` to add some in-app purchase methods to a screen, app delegate, or other class.

```ruby
# app/screens/purchase_screen.rb
class PurchaseScreen < PM::Screen
  include PM::IAP

  def on_load

    retrieve_iaps[ "productid1", "productid2" ] do |products, error|
      # products looks something like the following
      [{
        product_id:               "productid1",
        title:                    "title",
        description:              "description",
        price:                    <BigDecimal 0.99>,
        formatted_price:          "$0.99",
        price_locale:             <NSLocale>,
        downloadable:             false,
        download_content_lengths: <?>, # TODO: ?
        download_content_version: <?>, # TODO: ?
        product:                  <SKProduct>
      }, {...}]
    end

    purchase_iap "productid" do |status, transaction|
      case status
      when :in_progress
        # Usually do nothing, maybe a spinner
      when :deferred
        # Waiting on a prompt to the user
      when :purchased
        # Notify the user, update any affected UI elements
      when :canceled
        # They just canceled, no big deal.
      when :error
        # Failed to purchase
        transaction.error.localizedDescription # => error message
      end
    end

    restore_iaps "productid" do |status, products|
      if status == :restored
        # Update your UI, notify the user
      end
    end


  end
end
```

#### retrieve_iaps(*product_ids, &callback)

Retrieves in-app purchase products in an array of mapped hashes. The callback method should accept `products` and `error`.


#### purchase_iaps(*product_ids, &callback)

Prompts the user to login to their Apple ID and complete the purchase. The callback method should accept `status` and `transaction`.
 The callback method will be called several times with the various statuses in the process. If more than one `product_id` is provided
 the callback method will be called several times per product with the applicable transaction.


#### restore_iaps(*product_ids, &callback)

Restores a previously purchased IAP to the user (for example if they have upgraded their device). This relies on the Apple ID the user
 enters at the prompt. Unfortunately, if there is no purchase to restore for the signed-in account, no error message is generated and 
 will fail silently.





Find the Product ID here:

![product id](http://clrsight.co/jh/2015-02-11-d8xw6.png?+)


## Authors
| Contribuor | Twitter |
| Jamon Holmgren | [@jamonholmgren](http://twitter.com/jamonholmgren) |
| Kevin VanGelder | [@kevinvangelder](http://twitter.com/kevinvangelder) |

## Inspired By
- [Helu](https://github.com/ivanacostarubio/helu)
- [Mark Rickert's Code Example](https://github.com/OTGApps/TheShowCloser/blob/master/app/helpers/iap_helper.rb)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make some specs pass
5. Push to the branch (`git iap origin my-new-feature`)
6. Create new Pull Request
