module Transifex
  class Proxy
    attr_reader :client

    def initialize(client, *args)
      @client = client
      after_initialize(*args)
    end

    def reload
      reset
      fetch
    end

    def fetch
      raise NotImplementedError
    end

    private

    def reset
      raise NotImplementedError
    end

    def after_initialize
    end
  end
end
