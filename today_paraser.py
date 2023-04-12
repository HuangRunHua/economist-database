import json
from bs4 import BeautifulSoup
from page_source_downloader import PageDownloader

class TodayParaser(object):
    def __init__(self, 
                 today_html = "economist_weekly.html", 
                 page_url = "https://www.economist.com/weeklyedition/2023-04-08") -> None:
        self.today_html = today_html
        self.page_url = page_url

    def parase_data(self):

        self.save_source_page()

        HTMLFile = open(self.today_html, "r")
        index = HTMLFile.read()
        S = BeautifulSoup(index, 'lxml')
        Tag = S.find("script", {"id": "__NEXT_DATA__"})
        if len(Tag.contents) == 1:
            all_json_data = json.loads(Tag.next)
            self.fetch_new_home_page(all_json_data)
        elif len(Tag.contents) == 0:
            print("No data found in ", self.today_html)
        else:
            print("Find more than one data in ", self.today_html)

    def save_source_page(self):
        page_url = "https://www.economist.com"
        pd = PageDownloader(page_url=page_url, save_file_name=self.today_html)
        pd.fetch_page()
    
    def fetch_new_home_page(self, json_data: dict):
        new_home_page_parts = json_data
        # new_home_page = {
        #     "today": new_home_page_parts
        # }
        with open("new_home_page.json", "w+") as f:
            json.dump(new_home_page_parts, f)
        
        


if __name__ == "__main__":
    tp = TodayParaser()
    tp.parase_data()
      
