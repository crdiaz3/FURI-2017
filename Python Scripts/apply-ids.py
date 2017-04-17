import json

# open json file
def openFile(filename):
    with open(filename) as data_file:
        return json.load(data_file)

# method to store updated data
def storeData(filename, updated_data):
    with open(filename, 'w') as outfile:
        json.dump(updated_data, outfile, indent=4)

# method to apply ids
def update(cur_data):
    # variables
    ID = '@id'

    # naming data to project name
    data[ID] = 'SustainLD'

    # get number of cities to prep loop
    num_of_cities = len(data['@graph'])

    # write ids for every city
    for city in range(0,num_of_cities):
        cur_city = data['@graph'][city]
        cur_city[ID] = cur_city['name']

        cur_city['geo'][ID] = 'geo'
        cur_city['address'][ID] = 'address'

        num_of_props = len(cur_city['additionalProperty'])

        for prop in range(0,num_of_props):
            cur_prop = cur_city['additionalProperty'][prop]
            cur_prop[ID] = cur_prop['name']

# main program
file_name = 'city-data.jsonld'

data = openFile(file_name)
update(data)
storeData(file_name,data)
