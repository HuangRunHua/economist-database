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
        self.link_prefix = "https://github.com/HuangRunHua/economist-database/raw/main/weekly-json/"
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
        for article in articles_parts:
            if "Article" in article["type"]:
                article_link = article["url"]["canonical"]
                # article_tag = article["print"]["section"]["headline"]
                ap = ArticleParaser(page_url=article_link, date=self.date)
                ap.parase_data()

                articles_links.append(self.link_prefix + self.date + "/" + ap.article_json)

        self.weekly_issue_metadata["articles"] = [{"articleURL": link} for link in articles_links]

        
        


if __name__ == "__main__":
    page_url = "https://www.economist.com/weeklyedition/2023-04-08"
    tp = WeeklyParaser(page_url=page_url, id="00000000-0000-0000-0000-000000000000")
    tp.parase_data()
      
