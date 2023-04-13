from urllib import request as ulreq
from PIL import ImageFile
import requests
import shutil

class ImageAnalyzer(object):
    """
    The operation for remote images.
    """
    @staticmethod
    def get_image_size(url: str) -> tuple[float, float]:
        """
        Get the size of remote image.
        - Parameters:
            - url: the url string to the remote image.
        - Returns: 
            If the image is successfully fetched, return a tuple represents 
            the width and height of this image. If not return (0, 0).
        """
        remote_image = ulreq.urlopen(url)
        p = ImageFile.Parser()
        while True:
            data = remote_image.read(1024)
            if not data:
                break
            p.feed(data)
            if p.image:
                return p.image.size
        remote_image.close()
        return (0, 0)
  
# get image
# filepath = "https://media.newyorker.com/photos/63658ae20043641f2be3b555/master/w_760,c_limit/2022_11_14.jpg"

# result = ImageAnalyzer.get_image_size(url=filepath)
# print(result)