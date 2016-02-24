require_relative './scraper.rb'

class MostPopularBooks::Book
  attr_accessor :title, :author, :url, :source, :synopsis
  @@book_list = []

  def self.book_list
    @@book_list
  end

  def self.get_books
    scraper = Scraper.new
    @@book_list = scraper.scrape_all
    self.book_list
  end

end