import json
from bs4 import BeautifulSoup
from page_source_downloader import PageDownloader

class ArticleParaser(object):
    def __init__(self, 
                 page_url = "https://www.economist.com/briefing/2023/04/05/the-evidence-to-support-medicalised-gender-transitions-in-adolescents-is-worryingly-weak") -> None:
        self.article_html = page_url.split("/")[-1] + ".html"
        self.article_json = page_url.split("/")[-1] + ".json"
        self.page_url = page_url
        self.article_metadata = {}

    def parase_data(self):

        self.save_source_page()

        HTMLFile = open("articles/" + self.article_html, "r")
        index = HTMLFile.read()
        S = BeautifulSoup(index, 'lxml')
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

        with open("articles/" + self.article_json, "w+") as f:
            json.dump(article_content_parts, f)

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
                if child["type"] == "tag":
                    if len(child["children"]) > 1:
                        subchild_str = ""
                        for subchild in child["children"]:
                            if subchild["type"] == "text":
                                subchild_str += subchild["data"]
                            else:
                                subchild_str += subchild["children"][0]["data"]
                        current_para.append(subchild_str)
                    elif len(child["children"]) == 1:
                        if child["children"][0]["type"] == "tag":
                            current_para.append(child["children"][0]["children"][0]["data"])
                        elif child["children"][0]["type"] == "text":
                            current_para.append(child["children"][0]["data"])
                        else:
                            print("Type not handled in this version: ", child["children"][0]["type"])
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
            
            elif content["name"] == "figure":
                current_para_json["role"] = "image"
                current_para_json["imageURL"] = content["children"][0]["attribs"]["src"]
                current_para_json["imageWidth"] = content["children"][0]["attribs"]["width"]
                current_para_json["imageHeight"] = content["children"][0]["attribs"]["height"]
                current_para_json["imageDescription"] = ""
            
            article_contents.append(current_para_json)

        for i in article_contents:
            print(i)
            print("\n")

        self.article_metadata["contents"] = article_contents


if __name__ == "__main__":
    tp = ArticleParaser()
    tp.parase_data()
      
