import json
import csv
import requests

def search(name):
    i = 0
    for p in to_json["@graph"]:
        if p["name"] == name:
            return i
        i = i+1
    return None

def get_additional_property(file_index):
    if file_index == "aqi-data.csv":
        return "aqi"
    elif file_index == "avg-max-temp.csv":
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

# Structures initial jsonld file
to_json = json.loads(open('city-data.json').read())
base_addr = 'https://maps.googleapis.com/maps/api/geocode/json?address='

missing = []

# print(data_found["@graph"][0]["name"])
csv_files = [
    'aqi-data.csv',
    'avg-max-temp.csv',
    'avg-min-temp.csv',
    'crime-index-data.csv',
    'land-area-data.csv',
    'pop-growth-rate-data.csv',
    'water-area-data.csv'
]

def combine_remaining_files():
    # adds remaining sustainability index data for each city
    for aFile in csv_files:
        print(aFile)
        with open(aFile, 'r') as f:
            data = csv.reader(f)
            i = 0
            for row in data:
                if i > 0:
                    cur_name = row[2]+ ',' + row[3]
                    matching_key = search(cur_name)

                    if matching_key is not None:

                        add_prop = get_additional_property(aFile)
                        prop_index = get_property_index(to_json['@graph'][matching_key]['additionalProperty'],add_prop)

                        to_json['@graph'][matching_key]['additionalProperty'][prop_index]["value"] = row[1]
                        to_json['@graph'][matching_key]['additionalProperty'][prop_index]["ratingValue"] = row[0]
                        print(aFile + ": Updated " + row[2]+ ',' + row[3])
                        with open('city-data.json', 'w') as outfile:
                            json.dump(to_json, outfile, indent=4)
                    else:
                        #r = requests.get(base_addr+row[2]+ ',' + row[3])
                        #geocoder_result = r.json()
                        #if len(geocoder_result['results']) > 0:
                        to_json['@graph'].append( {
                            '@type': 'https://schema.org/City',
                            'name': row[2]+ ',' + row[3],
                            'ratingValue': 0,
                            'geo': {
                                #'latitude': geocoder_result['results'][0]['geometry']['location']['lat'],
                                #'longitude': geocoder_result['results'][0]['geometry']['location']['lng']
                                'latitude': 0,
                                'longitude': 0
                            },
                            'address': {
                              'addressLocality': row[2],
                              'addressRegion': row[3]
                            },
                            'additionalProperty': [
                              {
                                'name': 'aqi',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                'name': 'avg-max-temp',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                'name': 'avg-min-temp',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                'name': 'population',
                                'value': row[4],
                              },
                              {
                                'name': 'pop-growth-rate',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                'name': 'crime-index',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                'name': 'land-area',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                'name': 'water-area',
                                'value': 0,
                                'ratingValue': 0
                              },
                              {
                                'name': 'year',
                                'value': 2014,
                              }
                            ]
                        })
                        matching_key = search(cur_name)
                        add_prop = get_additional_property(aFile)
                        prop_index = get_property_index(to_json['@graph'][matching_key]['additionalProperty'],add_prop)

                        to_json['@graph'][matching_key]['additionalProperty'][prop_index]["value"] = row[1]
                        to_json['@graph'][matching_key]['additionalProperty'][prop_index]["ratingValue"] = row[0]

                        print(aFile + ": Added " + row[2]+ ',' + row[3])
                        with open('city-data.json', 'w') as outfile:
                            json.dump(to_json, outfile, indent=4)
                        i = i+1
                        #else:
                        #with open('city-data.json', 'w') as outfile:
                        #    json.dump(to_json, outfile, indent=4)
                        #with open('missing.csv', 'w') as f:
                        #    writer = csv.writer(f)
                        #    writer.writerows(missing)

                else:
                    i = i+1

combine_remaining_files()
