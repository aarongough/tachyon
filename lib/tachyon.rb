require "tachyon/version"

class Tachyon
  def self.insert(klass, data)
    raise ArgumentError, "data must be a hash or array" unless data.is_a?(Array) || data.is_a?(Hash)
    raise ArgumentError, "klass must inherit from ActiveRecord::Base" unless klass < ActiveRecord::Base

    if data.is_a?(Array)
      self.insert_records(klass, data)
    elsif data.is_a?(Hash)
      self.insert_record(klass, data)
    end
  end
end
