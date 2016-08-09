# SimpleWeatherApp

This a simple iOS App which determines your current location and fetches the weather JSON information from 
the OpenWeatherMap API, the Json is Parsed and displayed on a Tableviewcontroller.
The header of the Tableviewcontroller is used to display a full page of current information with scroll paging
enabled, scrolling down reveals hourly and daily forecasts in two pages.
A blur effect is enabled as the user scrolls down.

The project uses NSURlSession for comunication and the following libraries installed via cocoa Pods

pod 'Mantle'
pod 'LBBlurredImage'

The image blurring is handled by LBBlurredImage and parsing of JSON in Core Data objects is handled by Mantle Pods.

There is one viewController called WXController which sets up a tableView with a screen sized header and various
elements for the ui, it is all done here in code rather than in a storyboard for simplicity.

The line [[WXManager sharedManager] findCurrentLocation]; kicks off the location which when it gets a fix in 
the delegate calls the openWetherMap APi with NSUrlSession in the WXClient Code.
On return from the network call the data is deserialised with the Mantle library and Key Value Observer in the
Manager and subsequently in the WXController gets the updated data and reloads the tableView with the latest
weather information

The has a deloyment target of ios 9.0 and will work on the simulator but the location and weather will be for
california, 

Please run pod install at the root of the project to install the required pods and open the workspace
