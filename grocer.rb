require 'pry'
def consolidate_cart(cart)
  cart_hash = {}
  uniques = cart.uniq

  cart_keys = cart.map do |hash|
    hash.map { |k, v| k }
  end.flatten

  uniques.each do |hash|
    hash.each do |item, item_hash|
      cart_hash[item] = item_hash
      cart_hash[item][:count] = cart_keys.count(item)
    end
  end

  cart_hash
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
  cart1 = consolidate_cart(cart)
  cart2 = apply_coupons(cart1, coupons)
  cart3 = apply_clearance(cart2)

  total = 0
  cart3.each do |item, item_hash|
    total += item_hash[:price] * item_hash[:count]
  end
  total = total * 0.9 if total > 100
  total
end
