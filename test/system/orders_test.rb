require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
	test "check routing number" do 
		visit store_index_url

		first('.entry').click_on 'Add to Cart'

		click_on 'Checkout'

		fill_in 'order_name', with: 'Dave Thomas'
		fill_in 'order_address', with: '123 Main Street'
		fill_in 'order_email', with: 'dave@example.com'

		assert_no_selector "#order_routing_number"

		select 'Check', from: 'pay_type'
		assert_selector "#order_routing_number"
		assert_selector "#order_account_number"

		select 'Credit card', from: 'pay_type'
		assert_selector "#order_credit_card_number"
		assert_selector "#order_expiration_date"

		select 'Purchase order', from: 'pay_type'
		assert_selector "#order_po_number"
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
end