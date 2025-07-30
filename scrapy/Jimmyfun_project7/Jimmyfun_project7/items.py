# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class JimmyfunProject7Item(scrapy.Item):

    title = scrapy.Field()
    link = scrapy.Field()
    category = scrapy.Field()
    name = scrapy.Field()
    date = scrapy.Field()
    
