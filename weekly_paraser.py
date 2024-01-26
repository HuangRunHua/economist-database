import json
from bs4 import BeautifulSoup
from page_source_downloader import PageDownloader
from article_paraser import ArticleParaser

class WeeklyParaser(object):
    def __init__(self, page_url: str, id: str) -> None:
        self.weekly_html = page_url.split("/")[-1] + ".html"
        self.weekly_json = page_url.split("/")[-1] + ".json"
        self.page_url = page_url
        self.weekly_issue_metadata = {}
        self.id = id
        self.link_prefix = "https://github.com/HuangRunHua/economist-database/raw/main/articles/"
        self.date = page_url.split("/")[-1]
 
    def parase_data(self):

        self.save_source_page()

        HTMLFile = open("weekly/" + self.weekly_html, "r")
        index = HTMLFile.read()
        S = BeautifulSoup(index, 'lxml')
        Tag = S.find("script", {"id": "__NEXT_DATA__"})
        if len(Tag.contents) == 1: # type: ignore
            all_json_data = json.loads(Tag.next) # type: ignore
            self.fetch_issue(all_json_data)
        elif len(Tag.contents) == 0: # type: ignore
            print("No data found in ", self.weekly_html)
        else:
            print("Find more than one data in ", self.weekly_html)

    def save_source_page(self):
        pd = PageDownloader(page_url=self.page_url, save_file_name= "weekly/" + self.weekly_html)
        pd.fetch_page()
    
    def fetch_issue(self, json_data: dict):
        new_home_page_parts = json_data["props"]
        self.weekly_issue_metadata["id"] = self.id
        self.weekly_issue_metadata["date"] = new_home_page_parts["pageProps"]["content"]["datePublishedString"]
        self.weekly_issue_metadata["coverStory"] = new_home_page_parts["pageProps"]["content"]["image"]["main"]["headline"]
        self.weekly_issue_metadata["coverImageWidth"] = new_home_page_parts["pageProps"]["content"]["image"]["main"]["width"]
        self.weekly_issue_metadata["coverImageHeight"] = new_home_page_parts["pageProps"]["content"]["image"]["main"]["height"]
        self.weekly_issue_metadata["coverImageURL"] = new_home_page_parts["pageProps"]["content"]["image"]["main"]["url"]["canonical"]

        self.fetch_ori_link_of_articles(json_data=new_home_page_parts)


        with open("weekly-json/" + self.weekly_json, "w+") as f:
            json.dump(self.weekly_issue_metadata, f)

    def fetch_ori_link_of_articles(self, json_data: dict):
        articles_parts = json_data["pageProps"]["content"]["hasPart"]["parts"]
        articles_links: list[str] = []
        for article, article_id in zip(articles_parts, range(len(articles_parts))):
            if "Article" in article["type"]:
                article_link = article["url"]["canonical"]
                # article_tag = article["print"]["section"]["headline"]
                ap = ArticleParaser(page_url=article_link, date=self.date, id=article_id)
                ap.parase_data()

                articles_links.append(self.link_prefix + self.date + "/" + ap.article_json)

        self.weekly_issue_metadata["articles"] = [
            {
                "id": id,
                "articleURL": link
            } for id, link in zip(range(len(articles_links)), articles_links)
        ]

        
        


if __name__ == "__main__":

    page_urls = [
        {
            "link": "https://www.economist.com/printedition/2023-01-07",
            "id": "00000000-0000-0000-0000-000000000000"
        },
        {
            "link": "https://www.economist.com/printedition/2023-01-14",
            "id": "00000000-0000-0000-0000-000000000001"
        },
        {
            "link": "https://www.economist.com/printedition/2023-01-21",
            "id": "00000000-0000-0000-0000-000000000002"
        },
        {
            "link": "https://www.economist.com/printedition/2023-01-28",
            "id": "00000000-0000-0000-0000-000000000003"
        },
        {
            "link": "https://www.economist.com/printedition/2023-02-04",
            "id": "00000000-0000-0000-0000-000000000004"
        },
        {
            "link": "https://www.economist.com/printedition/2023-02-11",
            "id": "00000000-0000-0000-0000-000000000005"
        },
        {
            "link": "https://www.economist.com/printedition/2023-02-18",
            "id": "00000000-0000-0000-0000-000000000006"
        },
        {
            "link": "https://www.economist.com/printedition/2023-02-25",
            "id": "00000000-0000-0000-0000-000000000007"
        },
        {
            "link": "https://www.economist.com/printedition/2023-03-04",
            "id": "00000000-0000-0000-0000-000000000008"
        },
        {
            "link": "https://www.economist.com/printedition/2023-03-11",
            "id": "00000000-0000-0000-0000-000000000009"
        },
        {
            "link": "https://www.economist.com/printedition/2023-03-18",
            "id": "00000000-0000-0000-0000-000000000010"
        },
        {
            "link": "https://www.economist.com/printedition/2023-03-25",
            "id": "00000000-0000-0000-0000-000000000011"
        },
        {
            "link": "https://www.economist.com/printedition/2023-04-01",
            "id": "00000000-0000-0000-0000-000000000012"
        },
        {
            "link": "https://www.economist.com/printedition/2023-04-08",
            "id": "00000000-0000-0000-0000-000000000013"
        },
        {
            "link": "https://www.economist.com/printedition/2023-04-15",
            "id": "00000000-0000-0000-0000-000000000014"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-04-22",
            "id": "00000000-0000-0000-0000-000000000015"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-04-29",
            "id": "00000000-0000-0000-0000-000000000016"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-05-06",
            "id": "00000000-0000-0000-0000-000000000017"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-05-13",
            "id": "00000000-0000-0000-0000-000000000018"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-05-20",
            "id": "00000000-0000-0000-0000-000000000019"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-05-27",
            "id": "00000000-0000-0000-0000-000000000020"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-06-03",
            "id": "00000000-0000-0000-0000-000000000021"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-06-10",
            "id": "00000000-0000-0000-0000-000000000022"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-06-17",
            "id": "00000000-0000-0000-0000-000000000023"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-06-24",
            "id": "00000000-0000-0000-0000-000000000024"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-01",
            "id": "00000000-0000-0000-0000-000000000025"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-08",
            "id": "00000000-0000-0000-0000-000000000026"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-15",
            "id": "00000000-0000-0000-0000-000000000027"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-22",
            "id": "00000000-0000-0000-0000-000000000028"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-29",
            "id": "00000000-0000-0000-0000-000000000029"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-08-12",
            "id": "00000000-0000-0000-0000-000000000030"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-08-19",
            "id": "00000000-0000-0000-0000-000000000031"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-08-26",
            "id": "00000000-0000-0000-0000-000000000032"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-02",
            "id": "00000000-0000-0000-0000-000000000033"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-09",
            "id": "00000000-0000-0000-0000-000000000034"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-16",
            "id": "00000000-0000-0000-0000-000000000035"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-23",
            "id": "00000000-0000-0000-0000-000000000036"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-30",
            "id": "00000000-0000-0000-0000-000000000037"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-10-07",
            "id": "00000000-0000-0000-0000-000000000038"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-10-14",
            "id": "00000000-0000-0000-0000-000000000039"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-10-21",
            "id": "00000000-0000-0000-0000-000000000040"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-10-28",
            "id": "00000000-0000-0000-0000-000000000041"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-11-04",
            "id": "00000000-0000-0000-0000-000000000042"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-11-11",
            "id": "00000000-0000-0000-0000-000000000043"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-11-18",
            "id": "00000000-0000-0000-0000-000000000044"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-11-25",
            "id": "00000000-0000-0000-0000-000000000045"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-12-02",
            "id": "00000000-0000-0000-0000-000000000046"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-12-09",
            "id": "00000000-0000-0000-0000-000000000047"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-12-16",
            "id": "00000000-0000-0000-0000-000000000048"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-12-23",
            "id": "00000000-0000-0000-0000-000000000049"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-01-06",
            "id": "00000000-0000-0000-0000-000000000050"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-01-13",
            "id": "00000000-0000-0000-0000-000000000051"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-01-20",
            "id": "00000000-0000-0000-0000-000000000052"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-01-27",
            "id": "00000000-0000-0000-0000-000000000053"
        }
    ]

    # page_url = "https://www.economist.com/printedition/2023-01-14"
    tp = WeeklyParaser(page_url=page_urls[-1]["link"], id=page_urls[-1]["id"])
    tp.parase_data()

    # for page_url in page_urls:
    #     print(page_url["link"])
    #     print("Current Issue: ", page_url["link"])
    #     print("****************************************")
    #     tp = WeeklyParaser(page_url=page_url["link"], id=page_url["id"])
    #     tp.parase_data()
      
