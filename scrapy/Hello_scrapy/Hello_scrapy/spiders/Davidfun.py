import scrapy


class DavidfunSpider(scrapy.Spider):
    name = "Davidfun"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io/"]

    def parse(self, response):
        # CSS Selector
        title = response.css("h1.sitetitle::text").get()
        # XPATH
        description = response.xpath("//p[@class='lead']/text()").get()
        # 크롤링한 데이터 딕셔너리 형태로 저장
        yield{
            "title": title,
            "description" : description.strip()
        }

