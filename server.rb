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
	if result = getItem(params[:id]) then
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
	if item = getItem(params[:id]) then
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
	getCarrito( params[:username] ).to_json
end

put '/cart/:username.json' do
	if data = parse(request.body.read) then
		if (data['item_id'] && data['cantidad'] ) then
			if item = getItem(data['item_id']) then
				carrito = getCarrito( params[:username] )
				carrito.addItem(item, data['cantidad'])
				status 200
			else	
				status 404
				'No existe item con tal id'
			end
		else
			status 422
		end
	end
end

delete '/cart/:username/:item_id.json' do
	if item = getItem(params[:item_id]) then
		carrito = getCarrito( params[:username] )
		carrito.deleteItem(item)
		status 200
	else	
		status 404
		'No existe item con tal id'
	end
end

define_method :getCarrito  do |usuario|
	result = carritos.detect{ |carrito| carrito.usuario == usuario }
	if result then
		result
	else
		carrito = Cart.new(usuario)
		carritos << carrito
		carrito
		
	end
end

define_method :getItem  do |id|
	result = items.detect{ |item| item.id.to_i == id.to_i }
	if result then
		result
	else
		nil		
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


