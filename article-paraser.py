import json
from bs4 import BeautifulSoup
from page_source_downloader import PageDownloader

class ArticleParaser(object):
    def __init__(self, 
                 article_html = "article_html.html", 
                 page_url = "https://www.economist.com/leaders/2023/04/05/the-case-for-an-environmentalism-that-builds") -> None:
        self.article_html = page_url.split("/")[-1] + ".html"
        self.article_json = page_url.split("/")[-1] + ".json"
        self.page_url = page_url
        self.article_metadata = {}

    def parase_data(self):

        self.save_source_page()

        HTMLFile = open("articles/" + self.article_html, "r")
        index = HTMLFile.read()
        S = BeautifulSoup(index, 'lxml')
        # Tag = S.find("script", {"type": "application/ld+json"})
        Tag = S.find("script", {"id": "__NEXT_DATA__"})
        if len(Tag.contents) == 1:
            all_json_data = json.loads(Tag.next)
            self.parase_article_metadata(all_json_data)
        elif len(Tag.contents) == 0:
            print("No data found in ", self.article_html)
        else:
            print("Find more than one data in ", self.article_html)

    def save_source_page(self):
        pd = PageDownloader(page_url=self.page_url, save_file_name="articles/" + self.article_html)
        pd.fetch_page()
    
    def parase_article_metadata(self, json_data: dict):
        article_content_parts = json_data["props"]["pageProps"]["content"]
        self.parase_article_cover_image(json_data=article_content_parts)
        self.article_metadata["title"] = article_content_parts["headline"]
        self.article_metadata["subtitle"] = article_content_parts["description"]
        self.article_metadata["hashTag"] = article_content_parts["_metadata"]["section"]
        self.article_metadata["authorName"] = article_content_parts["_metadata"]["author"][0] if len(article_content_parts["_metadata"]["author"]) == 1 else article_content_parts["_metadata"]["author"][0]+" et al"
        self.article_metadata["publishDate"] = article_content_parts["_metadata"]["datePublished"]

        self.parase_article_text(json_data=article_content_parts)

        # new_home_page = {
        #     "today": article_content_parts
        # }
        # with open("articles/" + self.article_json, "w+") as f:
        #     json.dump(article_content_parts, f)
        
        
    def parase_article_cover_image(self, json_data: dict):
        cover_image_url = json_data["image"]["main"]["url"]["canonical"]
        cover_image_height = json_data["image"]["main"]["height"]
        cover_image_width = json_data["image"]["main"]["width"]
        cover_image_description = json_data["image"]["main"]["description"]

        self.article_metadata["coverImageURL"] = cover_image_url
        self.article_metadata["coverImageWidth"] = cover_image_width
        self.article_metadata["coverImageHeight"] = cover_image_height
        self.article_metadata["coverImageDescription"] = cover_image_description

    def parase_article_text(self, json_data: dict):
        contents = json_data["text"]
        article_contents: list[dict] = []
        for content in contents:
            current_para: list[str] = []
            current_para_json: dict = {}
            for child in content["children"]:
                if child["type"] != "text":
                    if len(child["children"]) > 1:
                        subchild_str = ""
                        for subchild in child["children"]:
                            if subchild["type"] == "text":
                                subchild_str += subchild["data"]
                            else:
                                subchild_str += subchild["children"][0]["data"]
                        current_para.append(subchild_str)
                    elif len(child["children"]) == 1:
                        current_para.append(child["children"][0]["data"])
                else:
                    current_para.append(child["data"])
            current_para_str = ""
            for para in current_para:
                current_para_str += para
            
            if content["name"] == "p":
                current_para_json["role"] = "body"
                current_para_json["text"] = current_para_str
                
            elif content["name"] == "h2":
                current_para_json["role"] = "second"
                current_para_json["text"] = current_para_str
            
            article_contents.append(current_para_json)

        for i in article_contents:
            print(i)
            print("\n")


if __name__ == "__main__":
    tp = ArticleParaser()
    tp.parase_data()
      
