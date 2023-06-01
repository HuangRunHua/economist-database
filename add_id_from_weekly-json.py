import json


"""
经济学人官网的文章排版可能会随时间变化
因此在后期添加id的时候使用add-id.py可能导致id重复的问题.
为解决这个问题,通过保存在weekly-json内的文件来添加id
"""

class AddID(object):
    def __init__(self, page_url: str, id: str) -> None:
        self.weekly_json = page_url.split("/")[-1] + ".json"
        self.link_prefix = "https://github.com/HuangRunHua/economist-database/raw/main/articles/"
        self.date = page_url.split("/")[-1]

    def fetch_ori_link_of_articles(self):
        with open("weekly-json/" + self.weekly_json) as f:
            magazine = json.load(f)
            for article in magazine["articles"]:
                article_link = article["articleURL"]
                aidtj = AddIDToJSON(page_url=article_link, date=self.date, article_id=article["id"])
                aidtj.read_json_file()


class AddIDToJSON(object):
    def __init__(self, page_url: str, date: str, article_id: int) -> None:
        self.article_json = page_url.split("/")[-1]
        self.date = date
        self.article_id = article_id
        self.article_metadata = {}

    def read_json_file(self):
        print("articles/" + self.date  + "/" + self.article_json)
        with open("articles/" + self.date  + "/" + self.article_json, "r+") as f:
            article_data = json.load(f)
            article_data["id"] = self.article_id
            self.article_metadata = article_data
            
        with open("articles/" + self.date + "/" + self.article_json, "w+") as f:
            json.dump(self.article_metadata, f)
        


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
            "id": "00000000-0000-0000-0000-000000000016"
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
            "link": "https://www.economist.com/weeklyedition/2023-06-03",
            "id": "00000000-0000-0000-0000-000000000020"
        }
    ]

    aid = AddID(page_url=page_urls[-1]["link"], id=page_urls[-1]["id"])
    aid.fetch_ori_link_of_articles()
    
    # for page_url in page_urls:
    #     aid = AddID(page_url=page_url["link"], id=page_url["id"])
    #     aid.parase_data()
