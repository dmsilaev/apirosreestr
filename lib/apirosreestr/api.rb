module Apirosreestr
  class Api
     ENDPOINTS = %w(
        cadaster/search cadaster/objectInfoFull cadaster/save_order
        transaction/info transaction/pay cadaster/orders cadaster/download
      ).freeze

    attr_reader :token

    def initialize(token)
      @token = token
    end
    def method_missing(method_name, *args, &block)
      endpoint = method_name.to_s
      endpoint = camelize(endpoint) if endpoint.include?('_')

      ENDPOINTS.include?(endpoint) ? call(endpoint, *args) : super
    end

    def call(endpoint, raw_params = {})
      params = build_params(raw_params)
      response = conn.post("/api/#{endpoint}", params)
      if response.status == 200
        json = JSON.parse(response.body)
        if json['error'] != []
          raise Exceptions::ResponseError.new(response),
                  "apirosreestr API has returned the error. #{ json['error']['mess'] }"
        end
        json
      else
        raise Exceptions::ResponseError.new(response),
              'apirosreestr API has returned the error.'
      end
    end

    private

    def build_params(h)
      h.each_with_object({}) do |(key, value), params|
        params[key] = value
      end
    end

    def camelize(method_name)
      words = method_name.split('_')
      words.drop(1).map(&:capitalize!)
      words.join
    end

    def conn
      @conn ||= Faraday.new(url: 'https://apirosreestr.ru/api') do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.headers['Token'] = token
        # faraday.headers['Content-Type'] = 'application/json'
        faraday.adapter Apirosreestr.configuration.adapter
      end
    end
  end
end
