require 'json'
require 'bundler'
Bundler.require
require_relative 'item'
require_relative 'cart'

items = [
	Item.new(1, 'H4205J43', 'Galletitas 9 de oro', 25.4, 45 ),
	Item.new(2, 'SJ48S93P', 'Galletitas Don Satur', 28.1, 125 ),
	Item.new(3, 'K3LW8H45', 'Galletitas Chocolinas', 39.4, 77 ),
	Item.new(4, '87Y7T5R4', 'Galletitas Oreo', 32, 99 )
]

carritos = [

]

before do
	content_type :json
end

get '/items.json' do
	status 200
	items.map{ |item| item.basic_to_hash }.to_json
end

get '/items/:id.json' do
  	result = items.detect{ |item| item.id.to_i == params[:id].to_i }
	if result then
		status 200
		result.to_json
	else
		status 404
	end
end

post '/items.json' do
	if data = parse(request.body.read) then
		if (data['sku'] && data['description'] && data['price'] && data['stock']) then
			item = Item.new(rand(1..999999), data['sku'], data['description'], data['price'], data['stock'] )
			items << item
			status 201
			item.to_json
		else
			status 422
		end
	end
end

put '/items/:id.json' do
	item = items.detect{ |item| item.id.to_i == params[:id].to_i }
	if item then
		if data = parse(request.body.read) then
			if (data['sku'] || data['description'] || data['price'] || data['stock']) then
				item.sku = data['sku'] if data['sku']
				item.descripcion = data['description'] if data['description']
				item.precio = data['price'] if data['price']
				item.stock = data['stock'] if data['stock']
				status 200
			else
				status 422
			end
		end
		
	else
		status 404
	end
	
end

get '/cart/:username.json' do
	result = carritos.detect{ |carrito| carrito.usuario == params[:username] }
	if result then
		status 200
		result.to_json
	else
		carrito = Cart.new(params[:username])
		carritos << carrito
		status 201
		carrito.to_json
		
	end
end

def parse(json) 
begin	
	return JSON.parse(json)
	rescue JSON::ParserError => e    
	status 422
	return false
end
end


