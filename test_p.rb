
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'

def oriflame_parser

  codes = File.foreach('codes.txt').map {|line| line.split(' ')}
  begin
    codes.each do |p_code|
      p_code.each_with_index do |pp_c, i|
      url_page = "http://ru.oriflame.com/products/product?code=#{pp_c}"
      puts "Fetching #{url_page}..."
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


      @image = page.css('li.ui-color-box')
      @image.xpath(".//img/@src").each do |src|
        uri = URI.join( url_page, src ).to_s # make absolute uri
        File.open("#{@data_dir}/#{title}/#{File.basename(uri)}",'wb'){ |f| f.write(open(uri).read) }
      end
      Nokogiri::HTML(open(url_page)).xpath("//img[@class='image figure']/@src").each do |src|
        uri = URI.join( url_page, src ).to_s # make absolute uri
        File.open("#{@data_dir}/#{title}/#{File.basename(uri)}",'wb'){ |f| f.write(open(uri).read) }
      end
      @ul_images = page.css('ul.variants')
      begin
        @ul_images.xpath(".//li/@data-srcset").each do |src|
          puts "Fetching images..."
          uri = URI.join( url_page, src ).to_s # make absolute uri
          File.open("#{@data_dir}/#{title}/#{File.basename(uri)}",'wb'){ |f| f.write(open(uri).read) }
          puts "File saved to #{@data_dir}/#{title}"
        end
      end
      end
    end
  end
end

oriflame_parser

