import requests
import shutil
from PIL import Image

class ImageDownloader(object):
    def __init__(self, image_url: str) -> None:
        self.image_url = image_url
        self.filename = image_url.split("/")[-1]

    def fetch_image(self):
        r = requests.get(self.image_url, stream = True)
        if r.status_code == 200:
            r.raw.decode_content = True
            with open(self.filename,'wb') as f:
                shutil.copyfileobj(r.raw, f)
        
            print('Image sucessfully Downloaded: ', self.filename)
            im = Image.open(self.filename)
            width, height = im.size
            return (width, height)
        else:
            print('Image Couldn\'t be retreived')
            return (0,0)

# if __name__ == "__main__":
#     image_url: str = "https://www.economist.com/cdn-cgi/image/width=1424,quality=80,format=auto/media-assets/image/20230401_WBD001.jpg"
#     imagedownloader = ImageDownloader(image_url=image_url)
#     imagedownloader.fetch_image()