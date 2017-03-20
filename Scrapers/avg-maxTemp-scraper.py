# -*- coding: UTF-8 -*-
#reference: http://www.crummy.com/software/BeautifulSoup/bs4/doc/

from bs4 import BeautifulSoup
import requests
import csv

def write_to_csv(data,file_name): #reference: http://pymotw.com/2/csv/
  with open(file_name,'w') as f: #existing file with the same name will be overwritten
    writer = csv.writer(f, lineterminator='\n')
    writer.writerow( ('Rank', 'AVG Max Temp', 'City', 'State', 'Population') )
    for i in range(len(data)):
      if data[i]:
        item = data[i]
        writer.writerow((item[0], item[1], item[2], item[3], item[4]))


def get_max_temp_info():
    captured_data = []
    #the base url to start scraping
    base_url = "http://www.usa.com/rank/us--average-max-temperature--city-rank.htm?yr=9000&dis=50&wist=&plow=&phigh="

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
                max_temp = city_data[1].string
                max_temp = max_temp.replace(u'°',' ')
                city_state = city_data[2].a.string
                city_state = city_state.split(',')
                city = city_state[0]
                state = city_state[1]
                if len(city_data[2].contents) > 1:
                    prep_pop = city_data[2].contents
                    pop = prep_pop[1].replace('/','').replace(' ','')
                    captured_data.append([rank,max_temp,city,state,pop])
                else:
                    pop = '0'
                    captured_data.append([rank,max_temp,city,state,pop])

        write_to_csv(captured_data,"avg-max-temp.csv")

get_max_temp_info()
