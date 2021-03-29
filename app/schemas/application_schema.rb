class ApplicationSchema
  def json_ld
    structure.to_json
  end

  def to_partial_path
    'application/schema'
  end
end
