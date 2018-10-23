#  FlickPics

#### Author: Gaurav gupta

## Basic Understanding

FlickPics is a lightweight photo searching application that shows the user the photos of their choice. The photo data is retrieved from the Flickr API.

## Features
- User can search photos by entering text in search bar such as "kittens".
- Photos are shown in a collection of 3 columns in Portrait mode. In Landscape mode number of columns adjust according to device.
- The app supports endless scrolling, automatically requesting and displaying more images when the user scrolls to the bottom of the view.
- Image Caching using NSCache
- Error handling
- Test cases

## Architecture

### App source code is based upon MVVM Architecture. Basic functionality of some working classes are as follows:-

- PhotoSearchViewController: It displays search bar and collection view. It handles user input and provide it to PhotoSearchViewModel. It displays photos provided by the view model. It notifies user of any error.

- PhotoSearchViewModel: It is responsible for fetching photos through Flickr API and parsing the response. It notifies PhotoSearchViewController of any updats like addition and removal of photos, various view states(enum PhotoSearchViewState) and error (enum PhotoSearchError).

- PhotoCollectionCell: It displays photo provided by PhotoViewModel. It shows placeholder image in case of loading from internet.  It also indicates with broken image icon if image fails to load.

- PhotoViewModel: It is initialized through objects of FlickrPhotoResponse and NSCache provided by the PhotoSearchViewModel. It downloads the photo based upon the url composed from various parameters. After downloading image it is cached using NSCache. In the same session already downloaded images are loaded from cache next time.

- Configuration: It has constants like api key, base url, request methods, etc.

- Models: FlickrPhotoSearchRequest structure makes working with API simpler. It is responsible for making url based upon the intializing parameters. FlickrSearchResponse conforms to Codable protocol. It is used to store the API respone using JSONDecoder.  
