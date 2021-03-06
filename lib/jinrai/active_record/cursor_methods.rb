require 'jinrai/config'

module Jinrai::ActiveRecord
  module CursorMethods
    include Jinrai::ConfigurationMethods

    def since_cursor
      encode_cursor(first)
    end

    def till_cursor
      encode_cursor(last)
    end

    def per(num = nil)
      num ||= default_cursor_per
      if (n = num.to_i).negative? || !(/^\d/ =~ num.to_s)
        self
      else
        self.is_cursored = true
        limit(n)
      end
    end

    private

    def encode_cursor(record)
      attributes = default_cursor_format.map do |attr|
        record.send(attr)
      end
      Base64.urlsafe_encode64(attributes.join("_"))
    end
  end
end
