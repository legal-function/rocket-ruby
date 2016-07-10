require_relative 'replay.rb'

# Define a .replay file.
file_path = File.dirname(__FILE__) + '/sampleReplays/five.replay'
replay_file = File.expand_path(file_path)

# Optional, define a .json file.
data_file = File.dirname(__FILE__) + '/sample.json'
json_file = File.expand_path(data_file)

# Create a replay object.
my_replay = Replay.new(replay_file, json_file)
my_replay.parse_data

# Write a json file
my_replay.write_to_json

# writes the hash to console
puts my_replay.get_hash

# This creates either writes to and existing .json
# file, or creates a new one if none is given.
