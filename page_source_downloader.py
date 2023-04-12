import requests
import shutil

class PageDownloader(object):
    def __init__(self, page_url: str, save_file_name: str = "economist_today.html") -> None:
        self.page_url = page_url
        self.save_file_name = save_file_name

    def fetch_page(self):
        r = requests.get(self.page_url, stream = True)
        if r.status_code == 200:
            r.raw.decode_content = True
            with open(self.save_file_name,'wb') as f:
                shutil.copyfileobj(r.raw, f)
        
            print('Web page sucessfully Downloaded: ', self.save_file_name)
        else:
            print('Web page Couldn\'t be retreived')
