##DokoDesuKa (どこですか)

iPhone app to share and discover snapshots of locations.

###How to use:

- Create a user
- Login using the credentials just created
	- Activate "Remember me" to store your login data and login automatically
- Navigate using the tab bar to
	- Map view
		- See all locations of all users on the map
		- Tap markers to see details
	- Add / edit location
		- Enter title and description of the location
		- Take a picture using the device camera
		- If location data cannot be resolved, location cannot be saved
		- On an emulator, instead of the camera, the picture can be read from the picture library
	- Your locations
		- Tap a location entry to edit it
		- Only title and description of location can be edited to keep an authentic picture for the location
		- swipe left on a location and tap "Delete" to delete the location
- Swipe right on "Add / edit location" and "Your locations" view and tap the "Logout" button to logout

###Installation and build notes

- To setup your own webservice on a Python Django-server, checkout the django-directory, edit __```django/dokodesuka/dokodesuka/settings.py```__ according to your preferences and start the Django project. Please refer to the [Django documentation](https://docs.djangoproject.com)
- The Xcode project makes use of the [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) Cocoapod library so make sure you navigate to your Xcode project folder and run __```pod install ```__ before opening the solution in Xcode
- Build the project
