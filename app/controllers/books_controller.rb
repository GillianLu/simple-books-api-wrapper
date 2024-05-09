class BooksController < ApplicationController
  def index
    client = SimpleBooksApi::Client.new
    @books = client.list_books
  rescue SimpleBooksApi::Client::Error => e
    flash[:alert] = e.message
    @books = []
  end


  def show
    client = SimpleBooksApi::Client.new
    @book = client.book_details(params[:id])
  rescue SimpleBooksApi::Client::NotFound
    render plain: "Book not found", status: :not_found
  end
end
