import json

with open('city-data.jsonld') as data_file:
    data = json.load(data_file)

object_id = '@id'
data[object_id] = 'SustainLD'

with open('city-data.jsonld', 'w') as outfile:
    json.dump(data, outfile, indent=4)

print(data['@id'])
