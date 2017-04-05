# -*- coding: UTF-8 -*-
#reference: http://www.crummy.com/software/BeautifulSoup/bs4/doc/

from bs4 import BeautifulSoup
import requests
import csv

def write_to_csv(data,file_name): #reference: http://pymotw.com/2/csv/
  with open(file_name,'w') as f: #existing file with the same name will be overwritten
    writer = csv.writer(f, lineterminator='\n')
    writer.writerow( ('Rank', 'AVG Min Temp', 'City', 'State', 'Population') )
    for i in range(len(data)):
      if data[i]:
        item = data[i]
        writer.writerow((item[0], item[1], item[2], item[3], item[4]))


def get_min_temp_info():
    captured_data = []
    #the base url to start scraping
    base_url = "http://www.usa.com/rank/us--average-min-temperature--city-rank.htm?hl=&hlst=&wist=&yr=&dis=&sb=DESC&plow=&phigh=&ps="

    for page_num in range(1,192):
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
                min_temp = city_data[1].string
                min_temp = min_temp.replace(u'°',' ')
                city_state = city_data[2].a.string
                city_state = city_state.split(',')
                city = city_state[0]
                state = city_state[1]
                if len(city_data[2].contents) > 1:
                    prep_pop = city_data[2].contents
                    pop = prep_pop[1].replace('/','').replace(' ','')
                    captured_data.append([rank,min_temp,city,state,pop])
                else:
                    pop = '0'
                    captured_data.append([rank,min_temp,city,state,pop])

        write_to_csv(captured_data,"avg-min-temp.csv")

get_min_temp_info()
