# The Economist Database

This database collects all the articles data of The Economist starting from January 2023. The database is used for my own use and I use this data to develop an app called `The Ecnomist` and the app is shown below.

![](https://github.com/HuangRunHua/economist-database/raw/main/cover.png)

## Why Develop

The reason why this software was developed is that the official Economist App has been removed from the App Store in China, and I cannot subscribe directly on the website (VISA is required). At the same time, with an interesting mentality, I planned to make an app similar to Apple New+, so I developed this app. 

The data acquisition of The Economist magazine is realized by `Python`, and the software is written by `Swift` language + `SwiftUI` framework.

## How to Use

If you want to use the app, you must have **an iPhone with system iOS 16.0+**, **contact me and I will give you TestFlight link**. 

**I will update the database every Friday or Saturday**. If you find that the magazine in the app is not updated, please exit the app in the background and reopen it.

If you would like to read the PDF version of the magazine without using the app, please download the magazine [here](https://github.com/HuangRunHua/the-economist-time-etc).

## Data Structure

The data structure and app are originally designed and developed in my `archive` [project](https://github.com/HuangRunHua/the-new-yorker-database).

### Article Structure

An `Article` is structed with the following `JSON` format.

```json
{
  "id": 0,
  "coverImageURL": "THE URL OF ARTICLE COVER IMAGE",
  "coverImageWidth": 442.5,
  "coverImageHeight": 688,
  "coverImageDescription": "THE DESCRIPTION OF COVER IMAGE",
  "title": "THE TITLE OF THE ARTICLE",
  "subtitle": "THE SUBTITLE OF THE ARTICLE",
  "hashTag": "THE TAG OF THIS ARTICLE",
  "authorName":"THE AUTHOR'S NAME",
  "publishDate": "THE DATE OF ARTICLE IS PUBLISHED",
  "contents": [
    {
      "role": "body",
      "text": "THE TEXT OF BODY SECTION"
    },
    {
      "role": "image",
      "imageURL": "THE URL OF CONTENT'S IMAGE THAT WILL BE INSERTED INSIDE AN ARTICLE",
      "imageWidth": 295.88,
      "imageHeight": 251.67,
      "imageDescription": "THE DESCRIPTION OF IMAGE",
    },
    {
      "role": "quote",
      "text": "THE TEXT OF QUOTE PART INSIDE THE ARTICLE"
    }
    ...
  ]
}
```

### Magazine Structure

A `Magazine` contains multiple `Article` structures and some other data and is stored in `JOSN` format.

```json
{
  "id": "00000000-0000-0000-0000-000000000000",
  "date": "Oct 3rh 2022",
  "coverStory": "Mark Ulriksen’s “All Rise!”",
  "coverImageWidth": 555,
  "coverImageHeight": 688,
  "coverImageURL": "https://media.newyorker.com/photos/632de17e882c6ff52b2d3b1f/master/w_380,c_limit/2022_10_03.jpg",
  "articles": [
    {
      "id": 0,
      "articleURL": "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022_10_03/the-shock-and-aftershocks-of-the-waste-land/article.json"
    },
    {
      "id": 1,
      "articleURL": "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022_10_03/how-to-recover-from-a-happy-childhood.json"
    }
  ]
}
```

### Database Structure

The `Database` contains all the magazines that are stored in the server. The structure of `Database` is also `JSON`style format.

```json
[
  {
    "id": 1,
    "magazineURL": "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022_09_26/2022_09_26.json"
  },
  {
    "id": 2,
    "magazineURL": "https://github.com/HuangRunHua/the-new-yorker-database/raw/main/database/2022_10_03/2022_10_03.json"
  }
]
```

### Latest Magazine Structure

The `latest.json` saves for the URL of latest magazine. The structure of `latest.json` is also `JSON`style format.

```json
[
    {
        "magazineURL": "https://github.com/HuangRunHua/economist-database/raw/main/weekly-json/2023-04-22.json"
    }
]
```

## Last But Not Least

This software is currently well adapted to the iPhone device, and the iPad and Mac are not yet compatible (it can be used on the iPad or the Mac, because I use the SwiftUI framework, but the UI may not be well adapted). Whether it will be adapted to these devices is to be determined later, because I usually use iPhone to read The Economist.

