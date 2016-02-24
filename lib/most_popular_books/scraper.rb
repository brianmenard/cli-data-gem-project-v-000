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
    scrape_amazon
    scrape_nyt
    scrape_bn
    scrape_goodreads
    self.scraped_books
  end

  def scrape_amazon
    amazon_doc = Nokogiri::HTML(open("http://www.amazon.com/gp/bestsellers/books/ref=sv_b_2"))
    amazon_book = MostPopularBooks::Book.new
    amazon_book.source = "Amazon Best Seller"
    amazon_book.title = amazon_doc.css("div.zg_title").first.text.strip
    amazon_book.author = amazon_doc.css("div.zg_byline").first.text.strip
    amazon_book.url = amazon_doc.css("div.zg_title a").attribute("href").value

    details_page = Nokogiri::HTML(open(URI.parse(amazon_book.url)))
    amazon_book.synopsis = details_page.css("div.productDescriptionWrapper").first.text
    add_scraped_book(amazon_book)
  end

  def scrape_nyt
    nytimes_doc = Nokogiri::HTML(open("http://www.amazon.com/Books/b/ref=sv_b_3?ie=UTF8&node=549028"))
    nytimes_book = MostPopularBooks::Book.new
    nytimes_book.source = "New York Times Best Seller"
    nytimes_book.title = nytimes_doc.css("span.s9TitleText").first.text.strip
    nytimes_book.author = nytimes_doc.css("div.a-row.a-size-small").first.text.strip
    #nytimes_book.url = nytimes_doc.css("zg_title a").attribute("href")
    add_scraped_book(nytimes_book)
  end

  def scrape_bn
    bn_doc = Nokogiri::HTML(open("http://www.barnesandnoble.com/b/books/_/N-1fZ29Z8q8"))
    bn_book = MostPopularBooks::Book.new
    bn_book.source = "Barnes and Noble Best Seller"
    bn_book.title = bn_doc.css("div.product-info h2 a").first.text.strip
    bn_book.author = bn_doc.css("span.contributor a").first.text.strip
    #bn_book.url = bn_doc.css("zg_title a").attribute("href")
    add_scraped_book(bn_book)
  end

  def scrape_goodreads
    goodreads_doc = Nokogiri::HTML(open("https://www.goodreads.com/book/popular_by_date/2016/2"))
    goodreads_book = MostPopularBooks::Book.new
    goodreads_book.source = "Goodreads Most Popular"
    goodreads_book.title = goodreads_doc.css("a.bookTitle").first.text.strip
    goodreads_book.author = goodreads_doc.css("a.authorName").first.text.strip
    #bn_book.url = bn_doc.css("zg_title a").attribute("href")
    add_scraped_book(goodreads_book)
  end

  def add_scraped_book(book)
    self.scraped_books << book
  end

end