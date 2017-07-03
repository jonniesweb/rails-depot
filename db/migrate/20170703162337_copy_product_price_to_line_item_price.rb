class CopyProductPriceToLineItemPrice < ActiveRecord::Migration[5.1]
  def up
    # Get each line item and set the price to the product's price only if price
    # didn't exist previously
    Cart.all.each do |cart|
      cart.line_items.each do |item|
        item.price = item.product.price unless item.price
        item.save!
      end
    end
  end

  def down
    # choose not to remove price from line_item since the user may have prices
    # which have changed on the product since being added to the cart
  end
end
