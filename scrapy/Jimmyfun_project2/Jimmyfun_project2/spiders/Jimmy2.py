import scrapy
from Jimmyfun_project2.items import JimmyfunProject2Item

class Jimmy2Spider(scrapy.Spider):
    name = "Jimmy2"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io/"]

    def parse(self, response):
        item = JimmyfunProject2Item()
        item["title"] = response.css("h1.sitetitle::text").get()
        description = response.xpath("//p[@class='lead']/text()").get()
        item["description"] = description

#        if description:
#            item["description"] = description.strip()
#        else :
#            item["description"] 

        yield item
