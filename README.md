# DnD-Character-Tracker
A simple iOS application where users can create Dungeons and Dragons characters and chat with other players. This app was created in XCode using Swift and Firebase.

## User Authentication

Users can create an account using an e-mail and password. The functionalities related to authentication were implemented using Firebase Authentication. <p>
<img src="https://user-images.githubusercontent.com/61358172/130201541-18ebc0da-11c4-406d-a20e-a8e13e030633.png" width="220" height="400" /> <img src="https://user-images.githubusercontent.com/61358172/130201548-b27ed06d-2843-4d4d-b615-d2df1575b249.png" width="220" height="400" /> <img src="https://user-images.githubusercontent.com/61358172/130201552-8703de5f-91bf-453f-bffd-aea76a71f45f.png" width="220" height="400" />

After succesfully logging in, the user will be brought to the main page, where they can access several functionalities.

<img src="https://user-images.githubusercontent.com/61358172/130201557-ea70370c-b8a6-4554-967b-46edadf060e6.png" width="220" height="400"/>

Users can also view their profile, from which they have the possibility to delete their account if they so wish. 
<p> <img src="https://user-images.githubusercontent.com/61358172/130201550-b0b0dfc6-5954-48a7-9278-de882f99ccf4.png" width="220" height="400" />

## Character list
Users can view a list of their characters by pressing on "View characters". Once shown this screen, a user can choose to either create a new character (by pressing
on the plus button in the upper right corner of the screen) or view the profile of an existing character (by clicking on the cell displaying that characters data.)
<p><img src="https://user-images.githubusercontent.com/61358172/130201555-b5eddbde-6638-4131-a2fa-55cc112c98c7.png" width ="220" height="400" />

### Creating a character

Users will select different characteristics for their new character, such as class, background and stats. After the character creation process is complete, the new character will be stored in a database (using Firebase Realtime Database). 
<p> <img src="https://user-images.githubusercontent.com/61358172/130208603-2108e825-bd35-464c-b7c3-36e691b8b2d7.png" width="220" height="400" /> <img src="https://user-images.githubusercontent.com/61358172/130208627-27f34ed0-5b26-4272-bf42-722175f968d9.png" width="220" height="400" /> <img src="https://user-images.githubusercontent.com/61358172/130208616-2a76af26-b75a-40b3-bf3d-fb74ff505388.png" width="220" height="400" /> <img src="https://user-images.githubusercontent.com/61358172/130208624-589c6cd1-d545-4704-9c8a-9430adda4fa9.png" width="220" height="400" />

### Character profile

A character's profile has two pages. The first page is dedicated to basic information about the character, as well as inventory (which can be modified), experience and level. 
Users can add experience to their character. Once this variable has the required value, the character can gain a level. The second page displays the stats associated with the character.


<img src="https://user-images.githubusercontent.com/61358172/130201556-e83bc024-a369-4e95-b8f2-a1708773e5e6.png" width="220" height="400"/> <img src="https://user-images.githubusercontent.com/61358172/130201546-5f343392-22f9-4e8b-a1f0-dc68942664eb.png" width="220" height="400"/>

## Interacting with other users
### Viewing characters belonging to other users

By pressing on "View all characters", users can view every character created by other users of the app, along with a few pieces of relevant information. 
The list of characters can be filtered using the search bar above it. Upon finding a character they like, the user can begin talking with the owner of the 
character by pressing on the "Chat" button placed to the right of the character's cell.

<img src="https://user-images.githubusercontent.com/61358172/130201551-c5c81b75-7398-4c69-abd9-9ebb20b3fcc9.png" width="220" height="400"/>

### Chatting with other users

Users can view a list of all their on-going conversations by clicking on the "mail" button displayed on the main page. 
<img src="https://user-images.githubusercontent.com/61358172/130201559-86b0291d-b099-4349-90d3-b654f6dad7ff.png" width="220" height="400" />

The functionalities related to chatting with other users were implemented with the help of the [MessageKit](https://github.com/MessageKit/MessageKit) library.

<img src="https://user-images.githubusercontent.com/61358172/130201562-ad2aa0f8-cc2c-49e1-ae4e-36c79cbc27d9.png" width="220" height="400" />

## Ability Database

Users can view a list of abilities available for DnD characters. These abilities can be filtered by certain key-words, by class or by level.

<img src="https://user-images.githubusercontent.com/61358172/130201558-6ae5c1f4-9a38-4c64-b4c2-14a42ffb315b.png" width="220" height="400"/>

## Virtual Dice Creator

Users can generate virtual dice by selecting their type and inserting the number of dice in the required text field. Dice values are generated randomly.

<img src="https://user-images.githubusercontent.com/61358172/130201561-4d20bdd1-5bdb-4218-8f3a-8a8f9f658604.png" width="220" height="400"/>

## Statistics

Users can view a page displaying several statistics related to the number of users and the types of characters that have been created. This section of the
app was implemented with the help of the [Charts](https://github.com/danielgindi/Charts) library.

<img src="https://user-images.githubusercontent.com/61358172/130201566-f72fe608-f8e5-48e3-829f-7ac7503dac7d.png" width="220" height="400"/>
