#CLI controller

class BestsellingBooks::CLI

  def call
    list_books
    menu
    goodbye
  end

  def list_books
    puts "Today's NYTimes best selling books:"
    @books = BestsellingBooks::Book.get_books
    @books.each.with_index(1) do |book, index|
      puts "#{index}. #{book.category}: #{book.title} by #{book.author}"
    end
    puts "\n"
  end

  def menu
    input = nil
    while input != "exit"
    puts "Enter the number of the book you'd like more info on, type list to see the books again, or type exit: "
    input = gets.strip.downcase
      if input.to_i > 0
        the_book = @books[input.to_i-1]
        puts "-----------------------------"
        puts "#{the_book.title} \nby #{the_book.author}"
        puts "Buy URL: #{the_book.url}"
        puts "-----------------------------"
        puts "Synopsis: \n\n"
        the_book.synopsis.each do |paragraph| #prints well-formatted synopsis
          if paragraph != "" && paragraph != "Read More"
            puts "    #{paragraph.to_s}"
            puts "\n"
          end
        end
        puts "-----------------------------"
        elsif input == "list"
        list_books
        else
        puts "Not a recognized command, type list or exit: " unless input == "exit"
      end
    end
  end

    def goodbye
      puts "See you tomorrow!"
    end

end