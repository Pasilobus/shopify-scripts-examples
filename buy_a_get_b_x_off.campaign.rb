class ProductsSelector
  def initialize(product_ids)
    @product_ids = Array(product_ids)
  end

  def match?(line_item)
    @product_ids.include?(line_item.variant.product.id)
  end
end

# Apply a percentage discount to a line item.
class PercentageDiscount
  def initialize(percent, message)
    @percent = Decimal.new(percent) / 100.0
    @message = message
  end

  def apply(line_item)
    line_discount = line_item.line_price * @percent
    new_line_price = line_item.line_price - line_discount
    line_item.change_line_price(new_line_price, message: @message)
    puts "Discounted line item with variant #{line_item.variant.id} by #{line_discount}."
  end

end

class InterleavedPartitioner
  def initialize(paid_item_count, discounted_item_count)
    @paid_item_count = paid_item_count
    @discounted_item_count = discounted_item_count
  end

  def partition(cart, line_items)
    # Sort the items by price from high to low
    sorted_items = line_items.sort_by{|line_item| line_item.variant.price}.reverse
    # Create an array of items to return
    discounted_items = []
    # Keep counters of items seen and discounted, to avoid having to recalculate on each iteration
    total_items_seen = 0
    discounted_items_seen = 0

    # Loop over all the items and find those to be discounted
    sorted_items.each do |line_item|
      total_items_seen += line_item.quantity
      # After incrementing total_items_seen, see if any items must be discounted
      count = discounted_items_to_find(total_items_seen, discounted_items_seen)
      # If there are none, skip to the next item
      next if count <= 0

      if count >= line_item.quantity
        # If the full item quantity must be discounted, add it to the items to return
        # and increment the count of discounted items
        discounted_items.push(line_item)
        discounted_items_seen += line_item.quantity
      else
        # If only part of the item must be discounted, split the item
        discounted_item = line_item.split(take: count)
        # Insert the newly-created item in the cart, right after the original item
        position = cart.line_items.find_index(line_item)
        cart.line_items.insert(position + 1, discounted_item)
        # Add it to the list of items to return
        discounted_items.push(discounted_item)
        discounted_items_seen += discounted_item.quantity
      end
    end

    # Return the items to be discounted
    discounted_items
  end

  private

  # Returns the integer amount of items that must be discounted next
  # given the amount of items seen
  #
  def discounted_items_to_find(total_items_seen, discounted_items_seen)
    Integer(total_items_seen / (@paid_item_count + @discounted_item_count) * @discounted_item_count) - discounted_items_seen
  end
end

class BuyAGetBXOffCampaign
  def initialize(productA, productB, discount)
    @selectorA = productA
    @selectorB = productB
    @discount = discount
  end

  def run(cart)
    switch = false
    countA = 0
    countB = 0

    cart.line_items.select do |line_item|
      if @selectorA.match?(line_item)
        countA = line_item.quantity
        switch = true
      end
    end

    if switch

      applicable_items = cart.line_items.select do |line_item|
        @selectorB.match?(line_item)
        if @selectorB.match?(line_item)
          countB = line_item.quantity
        end
      end

      partitioner = InterleavedPartitioner.new(countB-countA,countA)

      discounted_items = partitioner.partition(cart, applicable_items)

      discounted_items.each do |line_item|
        @discount.apply(line_item)
      end
    end
  end
end

# Campaign Variables
prodA = 118060358
prodB = 118028404
discX = 50
message = "Buy Cloaking Device and Get 50% OFF on Ultimate Nullifier"

# List of campaigns.
CAMPAIGNS = [
    BuyAGetBXOffCampaign.new(
        ProductsSelector.new(prodA),
        ProductsSelector.new(prodB),
        PercentageDiscount.new(discX, message)
    )
]

# Apply all defined campaigns to the cart.
CAMPAIGNS.each do |campaign|
  campaign.run(Input.cart)
end

Output.cart = Input.cart
