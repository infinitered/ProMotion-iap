# ProMotion-iap

ProMotion-iap is in-app purchase notification support for the
popular RubyMotion gem [ProMotion](https://github.com/clearsightstudio/ProMotion).

## Installation

```ruby
gem 'ProMotion-iap'
```

## Usage

### AppDelegate

Include `PM::IAP` to add some in-app purchase methods to a screen, app delegate, or other class.

```ruby
# app/screens/purchase_screen.rb
class PurchaseScreen < PM::Screen
  include PM::IAP

  def on_load

    retrieve_iaps("productid1", "productid2") do |products|
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
      }, {...}]
    end

    purchase_iap "productid" do |success, transaction|
      if success
        # Notify the user, update any affected UI elements
      else
        transaction.error # some error message?
      end
    end

    restore_iaps do |products|

    end


  end
end
```

#### register_for_iap_notifications(*types)

Method you can call to register your app for iap notifications. You'll also want to implement
`on_iap_notification` and `on_iap_registration`.

```ruby
def on_load(app, options)
    register_for_iap_notifications :badge, :sound, :alert, :newsstand # or :all
    # ...
end
```

#### TODO

Initiates a purchase with the given product ID.

```ruby
def logging_out
  unregister_for_iap_notifications
end
```

Find the Product ID here:

![product id](http://clrsight.co/jh/2015-02-11-d8xw6.png?+)



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make some specs pass
5. Push to the branch (`git iap origin my-new-feature`)
6. Create new Pull Request
