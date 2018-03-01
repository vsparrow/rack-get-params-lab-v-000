class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = [] #hold any item from cart
  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      resp.write "Your cart is empty" if @@cart.length == 0
      @@cart.each do |item|
        resp.write "#{item}\n"
      end
    # Create a new route called /add that takes in a GET param with the key item.
    # This should check to see if that item is in @@items and then add it to the cart if it is. Otherwise give an error
    elsif req.path.match(/add/)
      search_term = req.params["item"]
      # puts "**********#{search_term} from /add/"
      resp.write check_and_add_to_cart(search_term)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    # puts "******#{search_term} is our search_term"
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def check_and_add_to_cart(search_term)
    resp = handle_search(search_term)
    if resp.include?("items")
      @@cart << search_term
      resp = "added #{search_term}"
    else
      resp = "We don't have that item"
    end

    # puts "**************#{resp}"
    resp
  end
end
