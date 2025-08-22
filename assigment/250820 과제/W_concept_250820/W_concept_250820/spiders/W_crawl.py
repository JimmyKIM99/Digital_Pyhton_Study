
import scrapy
from scrapy.http import Request
from W_concept_250820.items import WConcept250820Item

class WCrawlSpider(scrapy.Spider):
    name = "W_crawl"
    allowed_domains = ["display.wconcept.co.kr"]
    start_urls = ["https://display.wconcept.co.kr/category/women/002002"]


    def parse(self, response):
        products = response.css("button[aria-label][type='button']")
        self.logger.info(f"FOUND products: {len(products)}")
        for product in products :
            item = WConcept250820Item()
            item["name"] = product.css("span.sc-tdjdw3-0.frpBAf.text.detail::text").get()
            item["price"] = product.css("span.sc-tdjdw3-0.frpBAf.text.final-price strong::text").get()
            item["review_rate"] = product.css("em.score::text").get()
            item["review_num"] = product.css("span.sc-tdjdw3-0.frpBAf.text.cnt::text").get()
            yield item



