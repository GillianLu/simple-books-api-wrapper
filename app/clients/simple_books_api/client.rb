module SimpleBooksApi
  class Client
    class Error < StandardError; end
    class NotFound < Error; end

    BASE_URL = 'https://simple-books-api.glitch.me'.freeze

    def list_books
      request(:get, "books")
    end

    def book_details(id)
      request(:get, "books/#{id}")
    end

    private

    def request(method, endpoint, params: {}, headers: {}, body: {})
      response = connection.public_send(method, endpoint) do |req|
        req.params = params
        req.headers = headers.merge('Content-Type' => 'application/json')
        req.body = body.to_json if body.present?
      end

      handle_response(response)
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL)
    end

    def handle_response(response)
      raise NotFound, "Resource not found" if response.status == 404
      raise Error, "HTTP Error: #{response.status}" unless response.success?
      JSON.parse(response.body)
    end
  end
end
