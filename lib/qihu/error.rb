module Qihu
  class Error < StandardError
  end

  class InvailAPIError < Qihu::Error
    attr_reader :url, :error

    def initialize(url, error)
      @url = url
      @error = error
      
      super "Invaild API: [#{@url}]"
    end
  end

  class FailuresError < Qihu::Error
    attr_reader :code, :error
    def initialize(code, error)
      @code = code
      @error = error

      super "[#{@code}] #{@error}"
    end
  end
end