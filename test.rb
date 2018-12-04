require_relative 'server'
require 'minitest/autorun'

class MiniMarketTest < MiniTest::Test
    include Rack::Test::Methods

    def app
        Sinatra::Application
    end

    def test_get_items
        get '/items.json'
        assert_equal 200, last_response.status
        assert last_response.ok?
        assert_equal '[{"id":1,"sku":"H4205J43","description":"Galletitas 9 de oro"},{"id":2,"sku":"SJ48S93P","description":"Galletitas Don Satur"},{"id":3,"sku":"K3LW8H45","description":"Galletitas Chocolinas"},{"id":4,"sku":"87Y7T5R4","description":"Galletitas Oreo"}]', last_response.body
    end

    def test_get_item_by_id
        get '/items/1.json'
        assert_equal 200, last_response.status
        assert last_response.ok?
        assert_equal '{"id":1,"sku":"H4205J43","description":"Galletitas 9 de oro","precio":25.4,"stock":45}', last_response.body
    end

    def test_get_item_by_id_not_found
        get '/items/1000.json'
        assert_equal 404, last_response.status
    end

	def test_add_proper_item
		data = '{"sku": "12345-WH-XS", "description": "Women hoodie - White - XS", "price": 23.48, "stock": 8}'
		post '/items.json', data
		assert_equal 201, last_response.status
	end

	def test_add_wrong_item
		data = '{"sku": "12345-WH-XS", "description": "Women hoodie - White - XS", "price": 23.48}'
		post '/items.json', data
		assert_equal 422, last_response.status
	end

    def test_get_cart
        get '/cart/pepe123.json'
        assert_equal 200, last_response.status
        assert last_response.ok?
        assert_equal '{"usuario":"pepe123","fecha":"'+Date.today.to_s+'","monto":0}', last_response.body
    end

    def test_add_item_to_cart
        put '/cart/pepe123.json', '{"item_id":1,"cantidad":2}'
        assert_equal 200, last_response.status
        assert last_response.ok?
        get '/cart/pepe123.json'
        assert_equal '{"usuario":"pepe123","fecha":"'+Date.today.to_s+'","monto":50.8}', last_response.body
    end
end
