class Cart
attr_accessor :fecha, :usuario, :items
  def initialize( usuario)
    @fecha = Date.today
    @usuario = usuario
	@items = Hash.new(0)
  end

  def addItem (item)
	items[item] += 1

  end

  def to_hash()
        {
			usuario: @usuario,
			fecha: @fecha,
			monto: @items.keys.sum { |key| key.precio * items[key] } 
		}
  end


  def to_json
	to_hash.to_json
  end

end
