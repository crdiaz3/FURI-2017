import csv
import json
import requests

def search(name):
    for p in to_json['@graph']:
        if p['name'] == name:
            return p
    return None

def get_additional_property(file_index):
    if file_index == 0:
        return "avg-max-temp"
    elif file_index == 1:
        return "avg-min-temp"
    elif file_index == 2:
        return "crime-index"
    elif file_index == 3:
        return "land-area"
    elif file_index == 4:
        return "pop-growth-rate"
    elif file_index == 5:
        return "water-area"
    else:
        return None

def get_property_index(prop_list, prop):
    for item in prop_list:
        if prop_list[item]["name"] == prop:
            return item
    return None

first_csv_file = 'aqi-data.csv'

csv_files = [
    'avg-max-temp.csv',
    'avg-min-temp.csv',
    'crime-index-data.csv',
    'land-area-data.csv',
    'pop-growth-rate-data.csv',
    'water-area-data.csv'
]

base_addr = 'https://maps.googleapis.com/maps/api/geocode/json?address='
to_json = {'@context': 'https://raw.githubusercontent.com/crdiaz3/FURI-2017/master/JSON-LD/city-context.jsonld',
            'generatedAt': '2014',
            '@graph': []
          }

missing = []

# Structures initial jsonld file
with open(first_csv_file, 'r') as f:
    data = csv.reader(f)

    for row in data:
        r = requests.get(base_addr+row[2]+ ',' + row[3])
        geocoder_result = r.json()
        if len(geocoder_result['results']) > 0:
            to_json['@graph'].append( {
                '@type': 'https://schema.org/City',
                'name': row[2]+ ',' + row[3],
                'ratingValue': 0,
                'geo': {
                    'latitude': geocoder_result['results'][0]['geometry']['location']['lat'],
                    'longitude': geocoder_result['results'][0]['geometry']['location']['lng']
                },
                'address': {
                  'addressLocality': row[2],
                  'addressRegion': row[3]
                },
                'additionalProperty': [
                  {
                    'name': 'aqi',
                    'value': row[1],
                    'ratingValue': row[0]
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
            print(row[2]+ ',' + row[3])
        else:
            missing.append(row)
        with open('missing.csv', 'w') as f:
            writer = csv.writer(f)
            writer.writerows(missing)
        with open('city-data.json', 'w') as outfile:
            json.dump(to_json, outfile, indent=4)

# adds remaining sustainability index data for each city
for aFile in csv_files:
    print(csv_files[aFile])
    with open(aFile, 'r') as f:
        data = csv.reader(f)

        for row in data:
            cur_name = row[2]+ ',' + row[3]
            matching_key = search(cur_name)

            add_prop = get_additional_property(aFile)
            prop_index = get_property_index(to_json['@graph'][matching_key]['additionalProperty'],add_prop)

            to_json['@graph'][matching_key]['additionalProperty'][prop_index]["value"] = row[1]
            to_json['@graph'][matching_key]['additionalProperty'][prop_index]["ratingValue"] = row[0]


with open('city-data.json', 'w') as outfile:
    json.dump(to_json, outfile, indent=4)
