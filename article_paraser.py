import json
import os
from bs4 import BeautifulSoup
from page_source_downloader import PageDownloader

class ArticleParaser(object):
    def __init__(self, page_url: str, date: str) -> None:
        self.article_html = page_url.split("/")[-1] + ".html"
        self.article_json = page_url.split("/")[-1] + ".json"
        self.__article_source_json = page_url.split("/")[-1] + ".json"
        self.page_url = page_url
        self.article_metadata = {}
        self.date = date

    def parase_data(self):

        self.save_source_page()

        HTMLFile = open("source-html/" + self.article_html, "r")
        index = HTMLFile.read()
        S = BeautifulSoup(index, 'lxml')
        Tag = S.find("script", {"id": "__NEXT_DATA__"})
        if len(Tag.contents) == 1: # type: ignore
            all_json_data = json.loads(Tag.next) # type: ignore
            self.parase_article_metadata(all_json_data)
        elif len(Tag.contents) == 0: # type: ignore
            print("No data found in ", self.article_html)
        else:
            print("Find more than one data in ", self.article_html)

    def save_source_page(self):
        pd = PageDownloader(page_url=self.page_url, save_file_name="source-html/" + self.article_html)
        pd.fetch_page()
    
    def parase_article_metadata(self, json_data: dict):
        if "content" in json_data["props"]["pageProps"]:
            article_content_parts = json_data["props"]["pageProps"]["content"]

            """
            Save original JSON file for future usage
            """
            if not os.path.exists("DEBUG/" + self.date):
                os.mkdir("DEBUG/" + self.date)

            with open("DEBUG/" + self.date + "/" + self.__article_source_json, "w+") as f:
                json.dump(article_content_parts, f)

            self.parase_article_cover_image(json_data=article_content_parts)
            self.article_metadata["title"] = article_content_parts["headline"]
            self.article_metadata["subtitle"] = article_content_parts["description"]
            self.article_metadata["hashTag"] = article_content_parts["_metadata"]["section"]
            self.article_metadata["authorName"] = article_content_parts["_metadata"]["author"][0] if len(article_content_parts["_metadata"]["author"]) == 1 else article_content_parts["_metadata"]["author"][0]+" et al"
            self.article_metadata["publishDate"] = article_content_parts["_metadata"]["datePublished"]

            self.parase_article_text(json_data=article_content_parts)

            if not os.path.exists("articles/" + self.date):
                os.mkdir("articles/" + self.date)

            with open("articles/" + self.date + "/" + self.article_json, "w+") as f:
                json.dump(self.article_metadata, f)
        else:
            print("Article not parased: ", self.article_html)

        
        
    def parase_article_cover_image(self, json_data: dict):
        if (("imageUrl" in json_data["_metadata"]) and 
            ("imageHeight" in json_data["_metadata"]) and
            ("imageWidth" in json_data["_metadata"])):
            cover_image_url = json_data["_metadata"]["imageUrl"]
            cover_image_height = json_data["_metadata"]["imageHeight"]
            cover_image_width = json_data["_metadata"]["imageWidth"]
            cover_image_description = ""

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
                    if child["name"] == "figure":
                        current_para_json["role"] = "image"
                        current_para_json["imageURL"] = content["children"][0]["children"][0]["attribs"]["src"]
                        current_para_json["imageWidth"] = content["children"][0]["children"][0]["attribs"]["width"]
                        current_para_json["imageHeight"] = content["children"][0]["children"][0]["attribs"]["height"]
                        current_para_json["imageDescription"] = ""
                    else:
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
                                if not "data" in child["children"][0]["children"][0]:
                                    current_para.append(child["children"][0]["children"][0]["children"][0]["data"])
                                else:
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
                if content["children"][0]["name"] == "figure":
                    current_para_json["role"] = "image"
                    current_para_json["imageURL"] = content["children"][0]["children"][0]["attribs"]["src"]
                    current_para_json["imageWidth"] = content["children"][0]["children"][0]["attribs"]["width"]
                    current_para_json["imageHeight"] = content["children"][0]["children"][0]["attribs"]["height"]
                elif content["children"][0]["name"] == "img":
                    current_para_json["role"] = "image"
                    current_para_json["imageURL"] = content["children"][0]["attribs"]["src"]
                    current_para_json["imageWidth"] = content["children"][0]["attribs"]["width"]
                    current_para_json["imageHeight"] = content["children"][0]["attribs"]["height"]
                    current_para_json["imageDescription"] = ""
                else:
                    print("Name not handled in this version: ", content["children"][0]["name"])
            
            if current_para_json != {}:
                article_contents.append(current_para_json)

        self.article_metadata["contents"] = article_contents


# if __name__ == "__main__":
#     page_url = "https://www.economist.com/by-invitation/2023/04/04/the-fed-may-not-get-inflation-down-to-2-says-richard-clarida"
#     tp = ArticleParaser(page_url=page_url)
#     tp.parase_data()
      
