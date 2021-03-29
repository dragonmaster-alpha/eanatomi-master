class ImportedProduct < Product

  def sku=(val)
    super(clean_number(val))
  end

  def barcode=(val)
    super(clean_number(val))
  end

  def supplier_id=(val)
    super(clean_number(val))
  end


  private

  def clean_number(val)
    val.to_s.gsub(/\.0$/, '')
  end

end
