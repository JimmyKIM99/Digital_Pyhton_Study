import scrapy


class Jimmyfun1Spider(scrapy.Spider):
    name = "Jimmyfun1"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io/"]

    def parse(self, response):
        pass
