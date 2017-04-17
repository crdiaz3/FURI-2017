import json
import csv

# open json file
def openJsonFile(filename):
    with open(filename) as data_file:
        return json.load(data_file)

# method to store updated data
def storeJsonData(filename, updated_data):
    with open(filename, 'w') as outfile:
        json.dump(updated_data, outfile, indent=4)

def search(name):
    i = 0
    for p in json_data["@graph"]:
        if p["name"] == name:
            return i
        i = i+1
    return None

def get_additional_property(file_index):
    if file_index == "avg-max-temp.csv":
        return "avg-max-temp"
    elif file_index == "avg-min-temp.csv":
        return "avg-min-temp"
    elif file_index == "crime-index-data.csv":
        return "crime-index"
    elif file_index == "land-area-data.csv":
        return "land-area"
    elif file_index == "pop-growth-rate-data.csv":
        return "pop-growth-rate"
    elif file_index == "water-area-data.csv":
        return "water-area"
    else:
        return None

def get_property_index(prop_list, prop):
    i=0
    for item in prop_list:
        if item["name"] == prop:
            return i
        i=i+1
    return None

def combine_files(json_data):
    # adds remaining sustainability data for each city
    csv_files = [
        'avg-max-temp.csv',
        'avg-min-temp.csv',
        'crime-index-data.csv',
        'land-area-data.csv',
        'pop-growth-rate-data.csv',
        'water-area-data.csv'
    ]

    for aFile in csv_files:
        cur_file = '../csv-data/2014/'+aFile
        with open(cur_file, 'r') as f:
            data = csv.reader(f)
            i = 0
            for row in data:
                if i > 0:
                    cur_name = row[2]+ ',' + row[3]
                    matching_index = search(cur_name)

                    if matching_index is not None:

                        add_prop = get_additional_property(aFile)
                        prop_index = get_property_index(json_data['@graph'][matching_index]['additionalProperty'],add_prop)

                        json_data['@graph'][matching_index]['additionalProperty'][prop_index]['value'] = row[1]
                        json_data['@graph'][matching_index]['additionalProperty'][prop_index]['ratingValue'] = row[0]
                        print(aFile + ": Updated " + row[2]+ ',' + row[3])
                        with open('city-data.json', 'w') as outfile:
                            json.dump(json_data, outfile, indent=4)
                    else:
                        #r = requests.get(base_addr+row[2]+ ',' + row[3])
                        #geocoder_result = r.json()
                        #if len(geocoder_result['results']) > 0:
                        json_data['@graph'].append( {
                            '@type': 'https://schema.org/City',
                            '@id': row[2]+ ',' + row[3],
                            'name': row[2]+ ',' + row[3],
                            'ratingValue': 0,
                            'geo': {
                                #'latitude': geocoder_result['results'][0]['geometry']['location']['lat'],
                                #'longitude': geocoder_result['results'][0]['geometry']['location']['lng']
                                '@id': 'geo',
                                'latitude': 0,
                                'longitude': 0
                            },
                            'address': {
                                '@id': 'address',
                                'addressLocality': row[2],
                                'addressRegion': row[3]
                            },
                            'additionalProperty': [
                              {
                                '@id': 'aqi',
                                'name': 'aqi',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                '@id': 'avg-max-temp',
                                'name': 'avg-max-temp',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                '@id': 'avg-min-temp',
                                'name': 'avg-min-temp',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                '@id': 'population',
                                'name': 'population',
                                'value': row[4],
                              },
                              {
                                '@id': 'pop-growth-rate',
                                'name': 'pop-growth-rate',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                '@id': 'crime-index',
                                'name': 'crime-index',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                '@id': 'land-area',
                                'name': 'land-area',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                '@id': 'water-area',
                                'name': 'water-area',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                '@id': 'year',
                                'name': 'year',
                                'value': 2014,
                              }
                            ]
                        })
                        matching_index = search(cur_name)
                        add_prop = get_additional_property(aFile)
                        prop_index = get_property_index(json_data['@graph'][matching_index]['additionalProperty'],add_prop)

                        json_data['@graph'][matching_index]['additionalProperty'][prop_index]["value"] = row[1]
                        json_data['@graph'][matching_index]['additionalProperty'][prop_index]["ratingValue"] = row[0]

                        i = i+1

                else:
                    i = i+1

filename = '../JSON-LD/2014/city-data.jsonld'

json_data = openJsonFile(filename)

combine_files(json_data)

storeJsonData(filename+"-updated", json_data)
