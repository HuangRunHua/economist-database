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
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-06-10",
            "id": "00000000-0000-0000-0000-000000000021"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-06-17",
            "id": "00000000-0000-0000-0000-000000000022"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-06-24",
            "id": "00000000-0000-0000-0000-000000000023"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-01",
            "id": "00000000-0000-0000-0000-000000000024"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-08",
            "id": "00000000-0000-0000-0000-000000000025"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-15",
            "id": "00000000-0000-0000-0000-000000000026"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-22",
            "id": "00000000-0000-0000-0000-000000000027"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-07-29",
            "id": "00000000-0000-0000-0000-000000000028"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-08-12",
            "id": "00000000-0000-0000-0000-000000000029"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-08-19",
            "id": "00000000-0000-0000-0000-000000000030"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-08-26",
            "id": "00000000-0000-0000-0000-000000000031"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-02",
            "id": "00000000-0000-0000-0000-000000000032"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-09",
            "id": "00000000-0000-0000-0000-000000000033"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-16",
            "id": "00000000-0000-0000-0000-000000000034"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-23",
            "id": "00000000-0000-0000-0000-000000000035"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-09-30",
            "id": "00000000-0000-0000-0000-000000000036"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-10-07",
            "id": "00000000-0000-0000-0000-000000000037"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-10-14",
            "id": "00000000-0000-0000-0000-000000000038"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-10-21",
            "id": "00000000-0000-0000-0000-000000000039"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-10-28",
            "id": "00000000-0000-0000-0000-000000000040"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-11-04",
            "id": "00000000-0000-0000-0000-000000000041"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-11-11",
            "id": "00000000-0000-0000-0000-000000000042"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-11-18",
            "id": "00000000-0000-0000-0000-000000000043"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-11-25",
            "id": "00000000-0000-0000-0000-000000000044"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-12-02",
            "id": "00000000-0000-0000-0000-000000000045"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-12-09",
            "id": "00000000-0000-0000-0000-000000000046"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-12-16",
            "id": "00000000-0000-0000-0000-000000000047"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2023-12-23",
            "id": "00000000-0000-0000-0000-000000000048"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-01-06",
            "id": "00000000-0000-0000-0000-000000000049"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-01-13",
            "id": "00000000-0000-0000-0000-000000000050"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-01-20",
            "id": "00000000-0000-0000-0000-000000000051"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-01-27",
            "id": "00000000-0000-0000-0000-000000000052"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-02-03",
            "id": "00000000-0000-0000-0000-000000000053"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-02-10",
            "id": "00000000-0000-0000-0000-000000000054"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-02-17",
            "id": "00000000-0000-0000-0000-000000000055"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-02-24",
            "id": "00000000-0000-0000-0000-000000000056"
        },
        {
            "link": "https://www.economist.com/weeklyedition/2024-03-02",
            "id": "00000000-0000-0000-0000-000000000057"
        }
    ]

    aid = AddID(page_url=page_urls[-1]["link"], id=page_urls[-1]["id"])
    aid.fetch_ori_link_of_articles()
    
    # for page_url in page_urls:
    #     aid = AddID(page_url=page_url["link"], id=page_url["id"])
    #     aid.parase_data()
