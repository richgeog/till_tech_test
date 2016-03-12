require 'order'
require 'Timecop'

describe Order do
  subject(:order) { described_class.new('Sam', 1) }

  it "initializes with customer name" do
    expect(order.name).to eq('Sam')
  end

  it "initializes with a table number" do
    expect(order.table_number).to eq(1)
  end

  context '#basket' do
    it 'begins with an empty cart' do
      expect(order.cart).to be_empty
    end

    it 'holds the menu information' do
      menu_list = JSON.parse(File.read('hipstercoffee.json'))
      expect(order.menu).to eq(menu_list[0]['prices'][0])
    end

    it 'adds an item to the cart' do
      order.add_item('Tea', 1)
      expect(order.cart).to include('Tea')
    end

    it 'raises an error if item not in menu' do
      error_message = 'Item is not on the menu'
      expect{ order.add_item('Ice tea', 1) }.to raise_error(error_message)
    end

    it 'counts products amount' do
      order.add_item('Tea', 2)
      order.add_item('Tea', 1)
      expect(order.cart.count).to eq(3)
    end
  end

  describe '#receipt' do
    context '#subtotal' do
      it 'calculates the subtotal' do
        order.add_item('Tea', 1)
        expect(order.subtotal).to eq(3.65)
      end
    end

    context '#tax' do
      it 'calclautes the amount of tax' do
        order.add_item('Tea', 1)
        order.add_item('Muffin Of The Day', 1)
        expect(order.tax).to eq(0.71)
      end
    end

    context '#print receipt' do
      before do
        Timecop.freeze(Time.local(2016,3,9,23,04,53))
      end
      it 'shows summary of the order receipt' do
        order.add_item('Tea', 1)
        order.add_item('Choc Mudcake', 1)
        order.payment(11)
        order.change
        order_summary = "Tea 1 x 3.65\n" \
                        "Choc Mudcake 1 x 6.4\n\n" \
                        "Disc 5% from 10.05\n" \
                        "Tax 0.87\n" \
                        "Total: 10.92\n" \
                        "Cash: 11\n" \
                        "Change: 0.08\n\n" \
                        "Thankyou"
        expect(order.order_receipt).to eq(order_summary)
      end

      it 'shows the shop header details' do
        shop_details = "2016-03-09 23:04:53\n" \
                       "The Coffee Connection\n\n" \
                       "123 Lakeside Way\n" \
                       "Phone 16503600708\n\n" \
                       "Voucher 10% off all muffins\n" \
                       "Valid 01/04/16 01/04/16\n" \
                       "Table: 1 / [4]\n" \
                       "Sam\n"
        expect(order.shop_summary).to eq(shop_details)
      end

      it 'prints a pre-payment receipt' do
        order.add_item('Tea', 1)
        order.add_item('Choc Mudcake', 1)
        pre_payment_receipt = "2016-03-09 23:04:53\n" \
                              "The Coffee Connection\n\n" \
                              "123 Lakeside Way\n" \
                              "Phone 16503600708\n\n" \
                              "Voucher 10% off all muffins\n" \
                              "Valid 01/04/16 01/04/16\n" \
                              "Table: 1 / [4]\n" \
                              "Sam\n" \
                              "Tea 1 x 3.65\n" \
                              "Choc Mudcake 1 x 6.4\n\n" \
                              "Disc 5% from 10.05\n" \
                              "Tax 0.87\n" \
                              "Total: 10.92"
        expect(order.pre_payment_print_receipt).to eq(pre_payment_receipt)
      end

      it 'prints the whole receipt' do
        order.add_item('Tea', 1)
        order.add_item('Choc Mudcake', 1)
        order.payment(11)
        order.change
        full_receipt = "2016-03-09 23:04:53\n" \
                       "The Coffee Connection\n\n" \
                       "123 Lakeside Way\n" \
                       "Phone 16503600708\n\n" \
                       "Voucher 10% off all muffins\n" \
                       "Valid 01/04/16 01/04/16\n" \
                       "Table: 1 / [4]\n" \
                       "Sam\n" \
                       "Tea 1 x 3.65\n" \
                       "Choc Mudcake 1 x 6.4\n\n" \
                       "Disc 5% from 10.05\n" \
                       "Tax 0.87\n" \
                       "Total: 10.92\n" \
                       "Cash: 11\n" \
                       "Change: 0.08\n\n" \
                       "Thankyou"
        expect(order.print_receipt).to eq(full_receipt)
      end
    end

    context '#payment' do
      it 'accepts payment' do
        order.add_item('Tea', 1)
        order.add_item('Muffin Of The Day', 1)
        order.payment(10)
        expect(order.cash).to eq(10)
      end

      it 'calculates change' do
        order.add_item('Tea', 1)
        order.add_item('Muffin Of The Day', 1)
        order.payment(10)
        expect(order.change).to eq(1.09)
      end
    end

    context '#time' do
      before do
        Timecop.freeze(Time.local(2016,3,9,23,04,53))
      end
      it 'displays current time' do
        order.time
        expect(order.time).to eq(Time.now.strftime('%F %T'))
      end
    end

    context '#message' do
      it 'displays thankyou' do
        receipt_message = 'Thankyou'
        expect(order.message).to eq(receipt_message)
      end
    end

    context '#receipt offers' do
      it 'displays the discount date range' do
        date = 'Valid 01/04/16 01/04/16'
        order.discount_date
        expect(order.discount_date).to eq(date)
      end

      it 'displays the offer on the receipt' do
        offer = 'Voucher 10% off all muffins'
        order.voucher
        expect(order.voucher).to eq(offer)
      end
    end
  end

  describe 'discounts' do
    context '#5% off 50+ orders' do
      it 'dedcuts 5% off orders over 50' do
        order.add_item('Choc Mudcake', 8)
        expect(order.subtotal).to be  > 50
        order.fifty_plus_discount?
        expect(order.fifty_plus_discount?).to be true
        order.fifty_plus_total
        expect(order.fifty_plus_total).to eq(2.56)
        expect(order.discounts).to eq (52.84)
      end

      it 'does not deduct 5% if order is less then 50' do
        order.add_item('Choc Mudcake', 7)
        expect(order.fifty_plus_discount?).to be false
        expect(order.discounts).to eq(48.67)
      end
    end

    context '#10% off all muffins' do
      xit 'deducts 10% when any muffin us purchased' do
        order.add_item("Muffin Of The Day", 1)
        order.add_item("Blueberry Muffin", 4)
        order.muffin_discount?
        expect(order.muffin_discount?).to be true
        order.muffin_discount_total
        expect(order.muffin_discount_total).to eq(2.07)
        expect(order.discounts).to eq(18.68)
      end

      it 'does not deduct 10% when no muffins are ordered' do
        order.add_item('Choc Mudcake', 1)
        order.muffin_discount?
        expect(order.muffin_discount?).to be false
        expect(order.discounts).to eq(6.95)
      end

      xit 'deducts 10% muffin offer and 5% 50+ spend from total' do
        order.add_item('Cafe Latte', 6)
        order.add_item('Blueberry Muffin', 6)
        order.muffin_discount?
        order.fifty_plus_discount?
        expect(order.subtotal).to eq(52.80)
        expect(order.fifty_plus_total).to eq(2.64)
        expect(order.muffin_discount_total).to eq(2.43)
        expect(order.muffin_discount? && order.fifty_plus_discount?).to be true
        expect(order.discounts).to eq(47.73)
      end
    end
  end
end
