require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'

def md_parser
  codes = File.foreach('codes.txt').map {|line| line.split(' ')}
  begin
    codes.each do |p_code|
      p_code.each_with_index do |pp_c, i|
        url_page = "http://ro.oriflame.com/products/product-detail.jhtml?prodCode=#{pp_c}"
        puts "Fetching #{url_page}..."
        page = Nokogiri::HTML(open(url_page))
        @data_dir= 'products_ro'
        title = page.css('h1.fn').text
        Dir.mkdir("#{@data_dir}/#{title}") unless File.exists?("#{@data_dir}/#{title}")
        @ofile = File.open("#{@data_dir}/#{title}/data_ro.txt", 'w')
        code = page.css('span.proddetCode').text
        description = page.css('p.description').text
        ingredients = page.css('div#prod-ingredients').text
        @ofile.puts(title, code , "\n", description, "\n", ingredients)
      end
    end
  end
end

md_parser