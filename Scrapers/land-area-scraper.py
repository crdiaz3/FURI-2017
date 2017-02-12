#reference: http://www.crummy.com/software/BeautifulSoup/bs4/doc/
from bs4 import BeautifulSoup
import requests
import csv

def write_to_csv(data,file_name): #reference: http://pymotw.com/2/csv/
  with open(file_name,'w') as f: #existing file with the same name will be overwritten
    writer = csv.writer(f, lineterminator='\n')
    writer.writerow( ('Rank', 'Crime Index', 'City', 'State', 'Population') )
    for i in range(len(data)):
      if data[i]:
        item = data[i]
        writer.writerow((item[0], item[1], item[2], item[3], item[4]))


def get_land_info():
    captured_data = []
    #the base url to start scraping
    base_url = "http://www.usa.com/rank/us--land-area--city-rank.htm?hl=&hlst=&wist=&yr=9000&dis=50&sb=DESC&plow=&phigh=&ps="

    for page_num in range(1,148):
        cur_url = base_url + str(page_num)
        print(cur_url)

        r = requests.get(cur_url)
        data = r.text
        soup = BeautifulSoup(data, "html.parser")

        table = soup.find_all('table')[1]
        row_data = table.find_all('tr')
        for city in row_data:
            city_data = city.find_all('td')
            rank = city_data[0].string.replace(".","")
            if rank == "Rank":
                print("Skipping Header Row")
            else:
                land_area = city_data[1].string.replace(' sq mi','')
                city_state = city_data[2].a.string
                city_state = city_state.split(',')
                city = city_state[0]
                state = city_state[1]
                if len(city_data[2].contents) > 1:
                    prep_pop = city_data[2].contents
                    pop = prep_pop[1].replace('/','').replace(' ','')
                    captured_data.append([rank,land_area,city,state,pop])
                else:
                    pop = '0'
                    captured_data.append([rank,land_area,city,state,pop])

        write_to_csv(captured_data,"land-area-data.csv")

get_land_info()
