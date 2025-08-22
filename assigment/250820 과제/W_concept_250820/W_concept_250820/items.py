# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class WConcept250820Item(scrapy.Item):
    name = scrapy.Field()
    price = scrapy.Field()
    review_rate = scrapy.Field()
    review_num = scrapy.Field()