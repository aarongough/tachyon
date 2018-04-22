require "tachyon/version"

class Tachyon
  class << self

    @@connection_cache = {}

    def insert(klass, *data)
      connection_for(klass).execute(sql_for(klass, data))
    rescue ActiveRecord::RecordNotUnique
      # NO OP
    end

    def connection_for(klass)
      return @@connection_cache[klass] if @@connection_cache.has_key?(klass)
      @@connection_cache[klass] = klass.connection
    end

    def sql_for(klass, data)
      keys = data.map { |d| d.keys }.flatten.uniq
      columns = "`" + keys.join("`, `") + "`"

      values = data.map do |row|
        keys.map do |key|
          quote_value(row[key])
        end.join(",").prepend("(") << ")"
      end.join(",")

      "INSERT INTO `#{klass.table_name}` (#{columns}) VALUES #{values}"
    end

    def quote_data(data)
      data.map {|value| quote_value(value) }
    end

    def quote_value(value)
      case value
      when String then "'#{value.gsub("'", "''")}'"
      when NilClass then "NULL"
      else value
      end
    end

    def dump(record)
      record.attributes_before_type_cast.map do |key, value|
        [key.to_sym, dump_attribute(value)]
      end.to_h
    end

    def dump_attribute(attribute)
      case attribute
      when Time then attribute.to_s(:db)
      when Date then attribute.to_s(:db)
      when TrueClass then 1
      when FalseClass then 0
      else attribute
      end
    end

  end
end
