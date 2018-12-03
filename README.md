# MinimarketLLC

Ej agregar item a carrito:
curl -sSL -D - -X PUT http://localhost:4567/cart/pepe123.json -H 'Content-Type: application/json' -d '{"item_id": 1, "cantidad": 2}'

Eliminar item carrito:
curl -sSL -D - -X DELETE http://localhost:4567/cart/pepe123/1.json


