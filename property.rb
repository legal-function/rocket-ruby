# @name is the name of the property.
# @data is the data from the property.

# This class orgainizes and decodes the data for properties found in the header section.

require_relative 'records.rb'

class Property
  attr_reader :name, :data

  GOALS_DATA_SIZE = 4 # (frame, PlayerName, PlayerTeam, None)
  STATS_DATA_SIZE = 11 # (Name, Platform, OnlineID, Team, Score, Goals, Assists, Saves, Shots, bBot)

  def initialize(file)
    @name = PropertyName.new.read(file).name.val[0...-1]

    @data = if @name != 'None'
              strip_data(PropertyData.new.read(file), file)
            else
              'None'
            end
  end

  # Strips the data from a property record.
  def strip_data(property, file)
    property_type = property.type_var.val[0...-1]

    return property.data if number_property(property_type)
    return property.data.val[0...-1] if str_property(property_type)
    return property.data.byte_val.val[0...-1] if byte_property(property_type)
    return property.data == 1 if bool_property(property_type)

    # Must be an array at this point.
    data_list = {}
    loop_times = (@name == 'Goals' ? GOALS_DATA_SIZE : STATS_DATA_SIZE)
    property.data.times{|prop_number|
      sub_data = {}
      loop_times.times do
        arr_property = Property.new(file)
        next if arr_property.name == 'None'
        sub_data[arr_property.name] = arr_property.data
      end
      data_list[prop_number.to_s] = sub_data
    }
    data_list
  end

  private

  def number_property(property_type)
    %w(IntProperty FloatProperty QWordProperty).include?(property_type)
  end

  def str_property(property_type)
    %w(StrProperty NameProperty).include?(property_type)
  end

  def byte_property(property_type)
    property_type == 'ByteProperty'
  end

  def bool_property(property_type)
    property_type == 'BoolProperty'
  end
end
