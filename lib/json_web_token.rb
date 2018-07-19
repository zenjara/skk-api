class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload.to_s, "test")
    end

    def decode(token)
      body = JWT.decode(token, nil, false)[0]
      eval(body)
    rescue
      nil
    end
  end
end
