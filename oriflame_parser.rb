
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'

def oriflame_parser product_code

  url_page = "http://ru.oriflame.com/products/product?code=#{product_code}"
  page = Nokogiri::HTML(open(url_page))

  @data_dir= 'products'
  title = page.css('h1.name').text
  Dir.mkdir("#{@data_dir}/#{title}") unless File.exists?("#{@data_dir}/#{title}")
  @ofile = File.open("#{@data_dir}/#{title}/data.txt", 'w')
  volume = page.css('dl.size').text
  bb = page.css('dl.points').text
  code = page.css('dl.code').text
  description = page.css('div.description').text
  ingredients = page.css('div.ingredients').text
  htu = page.css('div.how-to-use').text
  price = page.css('span.mainCurrency').text
  @ofile.puts(title, volume, bb, code , "\n", description, "\n", ingredients, "\n", htu ,"\n",price)

  Nokogiri::HTML(open(url_page)).xpath("//img[@class='image figure']/@src").each do |src|
    uri = URI.join( url_page, src ).to_s # make absolute uri
    File.open("#{@data_dir}/#{title}/#{title}",'wb'){ |f| f.write(open(uri).read) }
  end
end


inp = $stdin.gets.chomp
oriflame_parser(inp)