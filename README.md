
# Foodzie

* App is implemented with simple MVVM architecture 
* Implemented POIs loading and rendering on a Map
* Application tries to check user location on the start to show relevant POIs
* Caching latest response in CoreData to prevent additional requests on start

# TODO

* Implement ViewModel updates as Combine signals
* More precise CoreLocation service usage
* Fix checks for POIs in current view - currently imlemented by naive distance measurement (<2km)
* POIs fetching & saving should be moved to separate service e.g. PlaceProvider
* UI/UX design

# How to build

1. Run ```pod install``` in project directory
2. Open Foodzie.xcworkspace with xCode
3. Build and run on Simulator or Real Device

# Requirements
- xCode 12
- iOS 13



