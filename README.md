##DokoDesuKa (どこですか)
by Hansjürg Jaggi & Emad Mansouri

iPhone app to share and discover snapshots of locations.

###How to use:

<table>
	<tr>
		<td>
			<img src="psd/scrs-login.png?raw=true" alt="Login view" />
		</td>
		<td>
			<ul>
				<li>
					Click "Add user" to add a user or use credentials of previously created user to login
				</li>
				<li>
					Activate "Remember me" to store your login data and login automatically
				</li>
			</ul>
		</td>
	</tr>
	<tr>
		<td>
			<img src="psd/scrs-add-user.png?raw=true" alt="Add user view" />
		</td>
		<td>
			<ul>
				<li>
					Create a new user
				</li>
			</ul>
		</td>
	</tr>
	<tr>
		<td>
			<img src="psd/scrs-map.png?raw=true" alt="Map view" />
		</td>
		<td>
			<ul>
				<li>
					See all locations of all users on the map
				</li>
				<li>
					Tap markers to see details
				</li>
			</ul>
		</td>
	</tr>
	<tr>
		<td>
			<img src="psd/scrs-add-location.png?raw=true" alt="Add location view" />
		</td>
		<td>
			<ul>
				<li>
					Enter title and description of the location
				</li>
				<li>
					Take a picture using the device camera
				</li>
				<li>
					If location data cannot be resolved, location cannot be saved
				</li>
				<li>
					On an emulator, instead of the camera, the picture can be read from the picture library
				</li>
			</ul>
		</td>
	</tr>
	<tr>
		<td>
			<img src="psd/scrs-list.png?raw=true" alt=" view" />
		</td>
		<td>
			<ul>
				<li>
					Tap a location entry to edit it
				</li>
				<li>
					Only title and description of location can be edited to keep an authentic picture for the location
				</li>
				<li>
					swipe left on a location and tap "Delete" to delete the location
				</li>
			</ul>
		</td>
	</tr>
	<tr>
		<td>
			<img src="psd/scrs-logout.png?raw=true" alt="Logout view" />
		</td>
		<td>
			<ul>
				<li>
					Swipe right on "Add / edit location" and "Your locations" view and tap the "Logout" button to logout
				</li>
			</ul>
		</td>
	</tr>
</table>

###Installation and build notes

- To setup your own webservice on a Python Django-server, checkout the django-directory, edit __```django/dokodesuka/dokodesuka/settings.py```__ according to your preferences and start the Django project. Please refer to the [Django documentation](https://docs.djangoproject.com)
- The Xcode project makes use of the [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager) Cocoapod library so make sure you navigate to your Xcode project folder and run __```pod install ```__ before opening the solution in Xcode
- Build the project
