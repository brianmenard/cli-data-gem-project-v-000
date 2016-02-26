require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'open-uri'

class Scraper

  attr_accessor :scraped_books

  def initialize
    self.scraped_books = []
  end

  def scrape_all
    barnesandnoble_doc = Nokogiri::HTML(open("http://www.barnesandnoble.com/b/the-new-york-times-bestsellers/_/N-1p3n"))
    sections_array = barnesandnoble_doc.css("section#hotBooksWithDesc").to_a
    sections_array.each do |section|
      book = BestsellingBooks::Book.new
      book.url = "http://www.barnesandnoble.com#{section.css("li h2 a").attribute("href").value}"
      details_page = Nokogiri::HTML(open(book.url))
      #Gets title from details page, since titles on main page are sometimes truncated
      book.title = details_page.css("section#prodSummary h1").first.text.strip
      book.category = section.css("h2").first.text.strip
      book.author = section.css("li a")[3].text.strip
      details_page.css("div.overview-desc p").each do |paragraph|
        book.synopsis << paragraph.text.strip
      end
      add_scraped_book(book)
    end
    self.scraped_books
  end




  def add_scraped_book(book)
    self.scraped_books << book
  end

  #-------UNUSED SITE SCRAPERS-------------------------

    #def scrape_nytimes
      #nytimes_fiction_doc = Nokogiri::HTML(open("http://www.nytimes.com/best-sellers-books/combined-print-and-e-book-fiction/list.html"))
      #nytimes_fiction = MostPopularBooks::Book.new
      #nytimes_fiction.source = "New York Times Best Seller (Fiction)"
      #nytimes_fiction.overview = nytimes_fiction_doc.css("td.summary").first.text.strip
      #add_scraped_book(nytimes_fiction)
    #end

  #def scrape_bn
  #  bn_doc = Nokogiri::HTML(open("http://www.barnesandnoble.com/b/books/_/N-1fZ29Z8q8"))
  #  bn_book = MostPopularBooks::Book.new
  #  bn_book.source = "Barnes and Noble Best Seller"
  #  bn_book.title = bn_doc.css("div.product-info h2 a").first.text.strip
  #  bn_book.author = bn_doc.css("span.contributor a").first.text.strip
  #  bn_book.url = bn_doc.css(".product-info a").attribute("href").value
#
  #  details_page = Nokogiri::HTML(open(URI.parse("http://www.barnesandnoble.com#{bn_book.url}")))
  #  bn_book.synopsis = details_page.css("div.overview-desc p").text.strip
  #  add_scraped_book(bn_book)
  #end

  #def scrape_goodreads
  #  goodreads_doc = Nokogiri::HTML(open("https://www.goodreads.com/book/popular_by_date/2016/2"))
  #  goodreads_book = MostPopularBooks::Book.new
  #  goodreads_book.source = "Goodreads Most Popular"
  #  goodreads_book.title = goodreads_doc.css("a.bookTitle").first.text.strip
  #  goodreads_book.author = goodreads_doc.css("a.authorName").first.text.strip
  #  goodreads_book.url = goodreads_doc.css("a.bookTitle").first.attribute("href").value
#
  #  details_page = Nokogiri::HTML(open(URI.parse("http://www.goodreads.com#{goodreads_book.url}")))
  #  goodreads_book.synopsis = details_page.css("div#description").text.strip
  #  add_scraped_book(goodreads_book)
  #end

    #--------AMAZON-- NOT WORKING -- EMBEDDED IN iFRAME, CANT SCRAPE
  #def scrape_amazon
  #  amazon_doc = Nokogiri::HTML(open("http://www.amazon.com/gp/bestsellers/books/ref=sv_b_2"))
  #  amazon_book = MostPopularBooks::Book.new
  #  amazon_book.source = "Amazon Best Seller"
  #  amazon_book.title = amazon_doc.css("div.zg_title").first.text.strip
  #  amazon_book.author = amazon_doc.css("div.zg_byline").first.text.strip
  #  amazon_book.url = amazon_doc.css("div.zg_title a").attribute("href").value
  #
  #  details_page = Nokogiri::HTML(open(URI.parse(amazon_book.url)))
    #NOT WORKING
  #  amazon_book.synopsis = details_page.css("div#iframeContent").text
  #  #
  #  puts amazon_book.synopsis
  #  add_scraped_book(amazon_book)
  #end

end