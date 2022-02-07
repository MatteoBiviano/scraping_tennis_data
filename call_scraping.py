import rpy2.robjects as robjects

example_name_player = "Daniil Medvedev"

r['source']('player_scraper.R')
scraped_data_r = robjects.r['scrapy'](example_name_player)
scraped_data = []

for i in scraped_data_r:
    scraped_data.append(i[0])
print(scraped_data)