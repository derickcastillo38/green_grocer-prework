require 'pry'
def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item|
    item.each do |key, value|
      count = cart.count(item)
      consolidated_cart[key] = {}
      value.each do |extra, extra_value|
        consolidated_cart[key][extra] = extra_value
      end
      consolidated_cart[key][:count] = count
    end
  end
  consolidated_cart
  # cart_hash = {}
  # uniques = cart.uniq
  #
  # cart_keys = cart.map do |hash|
  #   hash.map { |k, v| k }
  # end.flatten
  #
  # uniques.each do |hash|
  #   hash.each do |item, item_hash|
  #     cart_hash[item] = item_hash
  #     cart_hash[item][:count] = cart_keys.count(item)
  #   end
  # end
  #
  # cart_hash
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    item = coupon[:item]
    coupon_key = item + " W/COUPON"

    if cart[item] && cart[item][:count] >= coupon[:num]

      if cart[coupon_key]
        cart[coupon_key][:count] += 1
      else
        cart[coupon_key] = {
          :price => coupon[:cost],
          :clearance => cart[item][:clearance],
          :count => 1
        }
      end

      cart[item][:count] -= coupon[:num]
    end
  end

  cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance]
      item_hash[:price] = item_hash[:price] -
      (item_hash[:price] * 0.2)
    end
  end

  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  cart_with_coupon_applied = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(cart_with_coupon_applied)
  total = 0.0
  final_cart.each do |item, options|
    total = options[:price] * options[:count]
  end

  if total > 100.0
    total = total - (total * 0.1)
  end
  total
end
