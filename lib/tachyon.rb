require "tachyon/version"

class Tachyon
  class << self

    @@sql_cache = {}
    @@connection_cache = {}

    def insert(klass, data)
      connection_for(klass).execute(sql_for(klass, data))
    rescue ActiveRecord::RecordNotUnique
      # NO OP
    end

    def connection_for(klass)
      return @@connection_cache[klass] if @@connection_cache.has_key?(klass)
      @@connection_cache[klass] = klass.connection
    end

    def sql_for(klass, data)
      sql_template_for(klass) % quote_data(data)
    rescue KeyError => e
      raise "Data was not supplied for all columns - " + e.to_s
    end

    def sql_template_for(klass)
      return @@sql_cache[klass] if @@sql_cache.has_key?(klass)

      columns = klass.columns.map(&:name)
      table_name = klass.table_name
      columns_string = columns.map {|x| "`#{x}`" }.join(", ")
      values_string = columns.map {|x| "%{#{x}}" }.join(", ")

      sql = "INSERT INTO `#{table_name}` (#{columns_string}) VALUES (#{values_string})"

      @@sql_cache[klass] = sql
    end

    def quote_data(data)
      data.map do |key, value|
        [key, quote_value(value)]
      end.to_h
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
