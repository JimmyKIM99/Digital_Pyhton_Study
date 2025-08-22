import scrapy


class MusinsaSpiderSpider(scrapy.Spider):
    name = "musinsa_spider"
    allowed_domains = ["www.musinsa.com"]
    start_urls = ["https://www.musinsa.com/main/musinsa/ranking?gf=A"]

    def parse(self, response):
        pass
