import os
import glob
import json
from image_downloader import ImageDownloader


"""
当使用常规的方法无法解析文章时使用该方法手动解析文章，具体要求如下：
1. 创建一个目标杂志日期的文件夹，如2023-01-14
2. 在该文件夹内手动添加无法解析文章的`.md`文件，可以添加多篇，但要求必须得在当前日期的杂志内
3. 运行本程序，将可以看到在`articles/date/`文件夹内出现解析后的json文件
4. 记得检查weekly-json/date.json文件内是否有对应的链接
"""

class MagazineGenerator(object):
    """
    用于将单期杂志内文章转为JSON格式的工具。
    """
    def __init__(self, folder: str) -> None:
        """
        初始化MagazineGenerator。
        - Parameters:
            - folder: 单期杂志所在的文件夹名称
        """
        self.__location__ = os.path.realpath(os.path.join(os.getcwd(), os.path.dirname(__file__)))
        self.__folder = folder
        self.words_dict: dict[str, int] = {}

    def generat_jsons(self):
        """
        Read each word in the article and store those words as a dict.
        The format of dict is shown in the following way the key is the word the value is the count
        in which the word is appeared:
        word_dict = {"Twitter": 20, ...}
        """
        article_names = self.__get_article_names()
        for article_name in article_names:
            print("Read content from article: ", article_name)
            f = open(os.path.join(self.__location__, self.__folder + "/" + article_name), 'rb')
            lines = f.readlines()
            parsed_lines: list[str] = []
            for line in lines:
                """Split the line in to a list"""
                each_line_data = line.decode().strip('\n' '\r')
                if len(each_line_data) > 0:
                    parsed_lines.append(each_line_data)
            self.__parse_article(parsed_lines=parsed_lines, filename=article_name)
            f.close()

        self.words_dict = {k: v for k, v in sorted(self.words_dict.items(), key=lambda item: item[1], reverse=True)}

    def __parse_article(self, parsed_lines: list[str], filename: str):
        """
        Parse the article.
        - Parameters: 
            - parsed_lines: the parsed data read by python in a single .md file.
        """
        article = {}
        info_mark_indices  = [index for (index, item) in enumerate(parsed_lines) if item == "---"]
        """Get the basic information of this article"""
        for basic_info in parsed_lines[info_mark_indices[0]+1: info_mark_indices[1]]:
            info = [data.strip(' ') for data in basic_info.split(": ")]
            article[info[0]] = info[1]
            """Fetch the cover image size"""
            if "coverImageURL" in article:
                # cover_image_size = ImageAnalyzer.get_image_size(url=article["coverImageURL"])
                imagedownloader = ImageDownloader(image_url=article["coverImageURL"])
                cover_image_size = imagedownloader.fetch_image() 
                article["coverImageWidth"] = cover_image_size[0]
                article["coverImageHeight"] = cover_image_size[1]
        """Fetch the content of the article"""
        article["contents"] = []

        for content in parsed_lines[info_mark_indices[1]+1:]:
            parsed_content = {}
            if content[0:2] == "![":
                image_description, image_url = self.__parse_image(content=content)
                parsed_content["role"] = "image"
                parsed_content["imageURL"] = image_url
                print(image_url)
                # image_size = ImageAnalyzer.get_image_size(url=image_url)
                imagedownloader = ImageDownloader(image_url=image_url)
                image_size = imagedownloader.fetch_image() 
                parsed_content["imageWidth"] = image_size[0]
                parsed_content["imageHeight"] = image_size[1]
                if len(image_description) > 0:
                    parsed_content["imageDescription"] = image_description
            elif content[0:2] == "> ":
                parsed_content["role"] = "quote"
                parsed_content["text"] = content[2:]
            elif content[0:2] == "# ":
                parsed_content["role"] = "head"
                parsed_content["text"] = content[2:]
            elif content[0:3] == "## ":
                parsed_content["role"] = "second"
                parsed_content["text"] = content[3:]
            elif content[0:2] == "->":
                parsed_content["role"] = "link"
                parsed_content["link"] = content[2:]
            else:
                parsed_content["role"] = "body"
                parsed_content["text"] = content

            article["contents"].append(parsed_content)

        with open("articles" + '/' + self.__folder + "/" + filename[:-3] + ".json", "w") as outfile:
            json.dump(article, outfile)

    def __parse_image(self, content: str) -> tuple[str, str]:
        """
        Parse the image section.
        - Parameters:
            - content: the image string which must begin with "![" and the format is shown below:
            ![IMAGE DESCRIPTION](IMAGE URL)
        - Returns: return the image description and image url
        """
        image_desc_start_index = content.find("[")
        image_desc_end_index = content.find("]")
        image_description = content[image_desc_start_index+1: image_desc_end_index]
        image_url_start_index = content.find("(")
        image_url_end_index = content.find(")")
        image_url = content[image_url_start_index+1: image_url_end_index]
        return image_description, image_url


    def __get_article_names(self) -> list[str]:
        """
        Get all the names of data files (.NHO format) stored in a folder.
        - Returns: the list format of file's name, i.e. `001.NHO`
        """
        """Read files' name and stored in a str list"""
        absolute_folder_path = os.path.join(self.__location__, self.__folder + "/*.md")
        article_names = [absolute_path.split("/")[-1] for absolute_path in glob.glob(absolute_folder_path)]
        return article_names


if __name__ == "__main__":
    article_analyzer = MagazineGenerator(folder="2023-08-19")
    article_analyzer.generat_jsons()