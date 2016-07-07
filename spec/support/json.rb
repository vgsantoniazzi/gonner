module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def response_date(date)
      JSON.parse(date.to_json)
    end
  end
end
