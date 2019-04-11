require 'json'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req
    if @req.cookies != {}
      @hash = JSON.parse(@req.cookies["_rails_lite_app"])
    else
      @hash = {}
    end
  end

  def [](key)
    @hash[key]
  end

  def []=(key, val)
    @hash[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie('_rails_lite_app', JSON.generate(@hash))
  end
end
