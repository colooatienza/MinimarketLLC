class Item
attr_accessor :id, :sku, :descripcion, :precio, :stock
  def initialize(id, sku, descripcion, precio, stock)
    @id=id
    @sku=sku
    @descripcion=descripcion
	@precio = precio
	@stock = stock
  end

  def to_hash()
        {
			id: @id,
			sku: @sku,
			description: @descripcion,
			precio: @precio,
			stock: @stock
		}
  end

  def basic_to_hash()
        {
			id: @id,
			sku: @sku,
			description: @descripcion
		}
  end

  def to_json
	to_hash.to_json
  end

  def basic_to_json
	basic_to_hash.to_json
  end
end
