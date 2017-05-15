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
    defaults = { created_at: Time.now, updated_at: Time.now }
    data = defaults.merge(data)

    table = klass.arel_table
    mapped_data = data.map do |key, value|
      [table[key], value]
    end

    insert = Arel::InsertManager.new
    insert.into(table)
    insert.insert(mapped_data)

    begin
      klass.connection.execute(insert.to_sql)
    rescue ArgumentError
      # If we can't generate the insert using Arel (likely because
      # of an issue with a serialized attribute) then fall back
      # to safe but slow behaviour.
      klass.new(data).save(validate: false)
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
