# SimpleWeatherApp

This a simple iOS App which determines your current location and fetches the weather JSON information from 
the OpenWeatherMap API, the Json is Parsed and displayed on a Tableviewcontroller.
The header of the Tableviewcontroller is used to display a full page of current information with scroll paging
enabled, scrolling down reveals hourly and daily forecasts in two pages.
A blur effect is enabled as the user scrolls down.

The project uses NSURlSession for comunication and the following libraries installed via cocoa Pods

pod 'Mantle'
pod 'LBBlurredImage'
pod 'MTLManagedObjectAdapter'

The image blurring is handled by LBBlurredImage and parsing of JSON in Core Data objects is handled by Mantle Pods.

