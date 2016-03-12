require 'json'
require 'byebug'

class Order

  TAX_RATE = 0.0864
  FIFTY_DISCOUNT = 0.05
  MUFFIN_DISCOUNT = 0.10

  attr_reader :cart, :menu_list, :cash, :name, :table_number

  def initialize(name, table_number)
    @name = name
    @table_number = table_number
    @cart = []
    @cash = 0
    @menu_list = JSON.parse(File.read('hipstercoffee.json'))
  end

  def add_item(product, quantity)
    fail 'Item is not on the menu' unless menu.keys.include?(product)
      quantity.times{ @cart << product}
  end

  def menu
    menu_list[0]['prices'][0]
  end

  def subtotal
    cart.inject(0) { |sum, product| sum += menu[product] }.round(2)
  end

  def tax
    (TAX_RATE * subtotal).round(2)
  end

  def print_receipt
    receipt = shop_summary
    receipt << order_receipt
  end

  def pre_payment_print_receipt
    receipt = shop_summary
    receipt << cart.uniq.inject(""){ |str, item| str << (item + " #{cart.count(item)} x #{menu[item]}" + "\n") }
    receipt << "\nDisc 5% from #{subtotal}\n"
    receipt << "Tax #{tax}\n"
    receipt << "Total: #{discounts}"

  end

  def order_receipt
    receipt = cart.uniq.inject(""){ |str, item| str << (item + " #{cart.count(item)} x #{menu[item]}" + "\n") }
    receipt << "\nDisc 5% from #{subtotal}\n"
    receipt << "Tax #{tax}\n"
    receipt << "Total: #{discounts}\n"
    receipt << "Cash: #{cash}\n"
    receipt << "Change: #{change}\n\n"
    receipt << message
  end

  def shop_summary
    shop = "#{time}\n"
    shop << "#{menu_list[0]['shopName']}\n\n"
    shop << "#{menu_list[0]['address']}\n"
    shop << "Phone #{menu_list[0]['phone']}\n\n"
    shop << "#{voucher}\n"
    shop << "#{discount_date}\n"
    shop << "Table: #{table_number} / [4]\n"
    shop << "#{name}\n"
  end

  def payment(amount)
    @cash += amount
    print_receipt
  end

  def change
    change = (cash - (subtotal + tax)).round(2)
  end

  def time
    Time.now.strftime('%F %T')
  end

  def message
    "Thankyou"
  end

  def fifty_plus_discount?
    subtotal > 50
  end

  def muffin_discount?
    cart.inject(0) { |total, product| product.include?('Muffin') }
  end

  def discount_date
    "Valid 01/04/16 01/04/16"
  end

  def discounts
    if fifty_plus_discount? && muffin_discount? == true
      sub = subtotal - (fifty_plus_total + muffin_discount_total)
      sub += (TAX_RATE * sub)
      sub.round(2)
      # (subtotal + tax - (muff + fifty)).round(2)
    elsif fifty_plus_discount? == true
      sub = subtotal - fifty_plus_total
      sub += (TAX_RATE * sub)
      sub.round(2)
    elsif  muffin_discount? == true
      sub = subtotal - muffin_discount_total
      sub += (TAX_RATE * sub)
      sub.round(2)
    else
      (subtotal + tax).round(2)
    end
  end

  def fifty_plus_total
    (FIFTY_DISCOUNT * subtotal).round(2)
  end

  def muffin_discount_total
    cart.inject(0) do |total, product|
      product.include?('Muffin')
      (menu[product] * (MUFFIN_DISCOUNT)).round(2)
    end
  end

  def voucher
    "Voucher 10% off all muffins"
  end
end
