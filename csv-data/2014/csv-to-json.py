import csv
import json
import requests

first_csv_file = "aqi-data.csv"

csv_files = [
    "avg-max-temp.csv",
    "avg-min-temp.csv",
    "crime-index-data.csv",
    "land-area-data.csv",
    "pop-growth-rate-data.csv",
    "water-area-data.csv"
]

base_addr = "https://maps.googleapis.com/maps/api/geocode/json?address="
to_json = []
missing = []

# Structures initial jsonld file
with open(first_csv_file, "r") as f:
    data = csv.reader(f)

    for row in data:
        r = requests.get(base_addr+row[2]+ "," + row[3])
        geocoder_result = r.json()
        if len(geocoder_result["results"]) > 0:
            to_json.append( {
                "@context": "https://raw.githubusercontent.com/crdiaz3/FURI-2017/master/JSON-LD/city-context.jsonld",
                "@type": "https://schema.org/City",
                "name": row[2]+ "," + row[3],
                "ratingValue": 0,
                "geo": {
                    "latitude": geocoder_result["results"][0]["geometry"]["location"]["lat"],
                    "longitude": geocoder_result["results"][0]["geometry"]["location"]["lng"]
                },
                "address": {
                  "addressLocality": row[2],
                  "addressRegion": row[3]
                },
                "additionalProperty": [
                  "aqi": {
                    "name": "aqi",
                    "value": row[1],
                    "ratingValue": row[0]
                  },
                  "avg-max-temp": {
                    "name": "avg-max-temp",
                    "value": 0,
                    "ratingValue": 0
                  },
                  "avg-min-temp":{
                    "name": "avg-min-temp",
                    "value": 0,
                    "ratingValue": 0
                  },
                  "population": {
                    "name": "population",
                    "value": row[4],
                  },
                  "pop-growth-rate": {
                    "name": "pop-growth-rate",
                    "value": 0,
                    "ratingValue": 0
                  },
                  "crime-index": {
                    "name": "crime-index",
                    "value": 0,
                    "ratingValue": 0
                  },
                  "land-area": {
                    "name": "land-area",
                    "value": 0,
                    "ratingValue": 0
                  },
                  "water-area": {
                    "name": "water-area",
                    "value": 0,
                    "ratingValue": 0
                  },
                  "year": {
                    "name": "year",
                    "value": 2014,
                  }
                ]
            })
        else:
            missing.append(row)
        with open("city-data.json", "w") as outfile:
            json.dump(to_json, outfile, indent=4)
        with open("missing.csv", "w") as f:
            writer = csv.writer(f)
            writer.writerows(missing)

# adds remaining sustainability index data for each city
#for csv_file in csv_files:
    #do nothing for now
