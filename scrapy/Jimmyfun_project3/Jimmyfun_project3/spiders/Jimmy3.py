import scrapy
from Jimmyfun_project3.items import JimmyfunProject3Item

class Jimmy3Spider(scrapy.Spider):
    name = "Jimmy3"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io/"]

    def parse(self, response):
        jimmy3_categories = response.css("a.text-dark::text").getall()
        for category in jimmy3_categories:
            item = JimmyfunProject3Item()
            item["category"] = category
            yield item
