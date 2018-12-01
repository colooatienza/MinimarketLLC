require 'json'
require 'bundler'
Bundler.require
require_relative 'item'

items = [
Item.new(1, 'H4205J43', 'Galletitas 9 de oro', 25.4, 45 ),
Item.new(2, 'SJ48S93P', 'Galletitas Don Satur', 28.1, 125 ),
Item.new(3, 'K3LW8H45', 'Galletitas Chocolinas', 39.4, 77 ),
Item.new(4, '87Y7T5R4', 'Galletitas Oreo', 32, 99 )
]

get '/' do
      'hello world'
end

get '/items.json' do
	content_type :json
	items.map{ |item| item.basic_to_hash }.to_json
end

get '/items/:id.:ext' do	 
	if (params[:ext] == 'json') then
  		result = items.detect{ |item| item.id.to_i == params[:id].to_i }
		if result then
			result.to_json
		else
			status 404
		end
	else
		'El formato requerido para la respuesta debe ser json. Ej: localhost:4567/items/1.json'
	end
end

post '/items.json' do
	content_type :json
	data = JSON.parse(request.body.read)
	if (data['sku'] && data['description'] && data['price'] && data['stock']) then
		item = Item.new(rand(1..999999), data['sku'], data['description'], data['price'], data['stock'] )
		items << item
		status 201
		item.to_json
	else
		status 422
	end
end
