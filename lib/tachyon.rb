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

  def self.insert_record(klass, data)
    begin
        klass.new(data).save(validate: false)
    rescue ActiveRecord::RecordNotUnique
    end
  end

  def self.insert_records(klass, data)
    klass.connection.transaction do
      data.each do |record|
        self.insert_record(klass, record)
      end
    end
  end
end
