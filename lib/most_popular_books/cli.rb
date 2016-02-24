#CLI controller

class MostPopularBooks::CLI

  def call
    list_books
    menu
    goodbye
  end

  def list_books
    puts "Today's most popular books:"
    @books = MostPopularBooks::Book.get_books
    @books.each.with_index(1) do |book, index|
      puts "#{index}. #{book.source}: #{book.title} - #{book.author}"
    end
  end

  def menu
    input = nil
    while input != "exit"
    puts "Enter the number of the book you'd like more info on, type list to see the books again, or type exit: "
    input = gets.strip.downcase
      if input.to_i > 0
        the_book = @books[input.to_i-1]
        puts "#{the_book.title} - #{the_book.author}"
        elsif input == "list"
        list_books
        else
        puts "Not a recognized command, type list or exit: "
      end
    end
  end

    def goodbye
      puts "See you tomorrow!"
    end

end