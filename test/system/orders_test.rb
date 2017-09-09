require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
	include ActiveJob::TestHelper
	test "check routing number" do 
		LineItem.delete_all
		Order.delete_all

		visit store_index_url

		first('.entry').click_on 'Add to Cart'

		click_on 'Checkout'

		fill_in 'order_name', with: 'Dave Thomas'
		fill_in 'order_address', with: '123 Main Street'
		fill_in 'order_email', with: 'dave@example.com'

		assert_no_selector "#order_routing_number"

		select 'Credit card', from: 'pay_type'
		assert_selector "#order_credit_card_number"
		assert_selector "#order_expiration_date"

		select 'Purchase order', from: 'pay_type'
		assert_selector "#order_po_number"

		select 'Check', from: 'pay_type'
		assert_selector "#order_routing_number"
		fill_in "Routing #", with: "123456"
		fill_in "Account #", with: "987654"
		assert_selector "#order_account_number"

		perform_enqueued_jobs do 
			click_button "Place Order" 
		end

		orders = Order.all
		assert_equal 1, orders.size
		order = orders.first
		assert_equal "Dave Thomas", order.name
		assert_equal "123 Main Street", order.address
		assert_equal "dave@example.com", order.email
		assert_equal "Check", order.pay_type
		assert_equal 1, order.line_items.size

	end

	test "Add to Cart should invoke Your Cart" do
		visit store_index_url
		first('.entry').click_on 'Add to Cart'
		assert_selector "#cart", text:'Your Cart'
	end

	test "CLick Empty Cart should remove Your Cart" do
		visit store_index_url
		first('.entry').click_on 'Add to Cart'
		accept_confirm do
			click_on 'Empty cart'
		end
		assert_selector '#cart', text: ''
	end

	test "Add to Cart should invoke Highlighting Changes" do
		visit store_index_url
		first('.entry').click_on 'Add to Cart'
		assert_selector ".line-item-highlight"
	end

end