require 'csv'
require 'bigdecimal'

@stock_file = CSV.open('Lagerliste per 010918 eAnatomi.csv', headers: :first_row, col_sep: ';')
@value_file = CSV.open('Lagerværdi 31.12.2017 - 2018.csv', headers: :first_row)

headers = ['sku', 'description', 'price', 'rate', 'stock', 'ean', 'lagerværdi DKK', 'status']

def stock_item(sku)
  @stock_file.rewind
  @stock_file.entries.select do |item|
    item['SKUNumber'] == sku
  end.first
end

def parse_amount(amount)
  BigDecimal(amount.gsub(',', '.')) if amount
end

def amount_to_s(amount)
  amount ||= BigDecimal(0)
  amount.to_s('f').gsub('.', ',')
end

result_file = File.open('result.csv', 'w')
result_file.write headers.to_csv

@value_file.entries.each do |item|
  puts "processing #{item}"
  stock_item = stock_item(item['sku'])
  price = parse_amount(item['price'])
  rate = parse_amount(item['rate'])

  if stock_item.nil?
    item['status'] = 'not found'
    item['lagerværdi DKK'] = nil
    item['stock'] = nil

    result_file.write(item.to_csv)
  elsif price.nil? || rate.nil?
    item['status'] = 'invalid'
    item['lagerværdi DKK'] = nil
    item['stock'] = stock_item['Physical Stock'].to_i

    result_file.write(item.to_csv)
  else
    item['status'] = 'ok'
    item['stock'] = stock_item['Physical Stock'].to_i
    item['lagerværdi DKK'] = amount_to_s(item['stock'] * price * rate)

    puts "processed #{item}"
    result_file.write(item.to_csv)
  end
end

result_file.close
