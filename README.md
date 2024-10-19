# Table of Contents
1. [Overview](#overview)
2. [Features and Technologies](#features-and-technologies)
3. [Getting started](#getting-started)
4. [Usage](#usage)
5. [Requirements](#requirements)
6. [Workflow](#workflow)
7. [Demonstration](#demonstration)

# Cupcake Corner
The easy way to make your cupcake request in any Apple Platforms.
 
 # Overview
The Cupcake Corner is a Cross Platform app that enhance the user experience when those are getting out cupcakes in our store and also our employes want to manager the sales in the Admin version.<br>

When the user opens, for the first time the app, the fist thing that they will see is the Buy View, displaying in a grid style, a list of all cupcakes' flavors avaiable to buy. In client side, is also displayed, at the top of cupcakes' list a highlight of the newest cupcake created in our database.<br>

Clicking on any cupcake available in the list, the user will be taken to a new screen. In client's side, the screen is the Order View, the place where users can be making their orders request. The page brings together all informations necessary for user, like ingredients used and pricing of the current cupcake, also in this page, has two buttons, that is used for user says if it has frosting and sprinkles. Those buttons, also enhance the user experience in this view, because when the price is increased or decreased, activating or deactivating the request, there is new SwiftUI's `.contentTransition()` modifier being used with `numericText(value:)` for creates cool transitions when the value changes. On admin side, the screen that the admin will be taken is the Cupcake Detail, and in this view it is possible to control all of the chosen cupcake like, edit, checking something or even delete it.<br>

Moving to the second tab, we have the bag view, and this view is responsible for displaying all orders. In client side, the user can only observe the status of your order, which is updated by an Admin on Admin Side. Those updates occur in real-time with no delay, thanks by WebSocket, that enables a bidirectional channel between Client-Side(App) and Server. Because this when the user makes a new order, a request is sent to the server, that process and save on database, the user receives a response when the process is finished with success, and the admin receives on your channel an database's update, informing that a new order made. When its ready to be sent, the admin sending an update for the server can be updating an order saved in database, and finally, with this changes, the user will be get an update informing changes. Same process when the order will be delivered.<br>

Finaly, we have the Account View, and in this View your focus into managing user's account, offering a possibility to update the account, making logout or even delete the account. Also, in this view is possible to visualizy a panel with a panorama of the purchases(Client Side) and ballance of all cupcake's sales(Admin Side) with the avarge of sales or purchases, enabling user to visualizy how is your numbers. The Chart is buit using Swift Chat.<br>

Even there, to access all functionality of the app, is required an user account. The client account is created by user itself, but the admin, only other admin can create a new account. After the account creation, the user needs to authenticate on the system to get a token value that is stored in the System's Keychain, also this tokens is requested to realize all things that depends a communication with the server.

# Features and Technologies
* List of all cupcakes;<br>
* Create, update and delete Cupcake, User and Order(Some features, is only avaiabel for user with admin role);<br>
* Authentication and Authorization with JWT;<br>
* Real-time order status update;<br>
* Cache result from API call by SwiftData;<br>
* Built with SwiftUI

 # Getting started
1. Make sure you have the Xcode version 16 or above installed on your computer.<br>
2. Downloads the Cupcake Corner project file from this repositorys. <br>
3. Opens the [Cupcake Corner API](https://github.com/isaqueDaSilva/CupcakeCornerAPI.git) repository and flow your instruction as well.<br>
4. Open the project files in Xcode.<br>
6. Review the code and make sure you understand what it does.<br>
7. Run the CupcakeCorner and CupcakeCornerForAdmin schemes.<br>

# Usage
- In Cupcake Corner For Admin, first log with the default admin account, that you defined on the UserSeed migration for the Database in the API;
- Create some cupcakes;
- Opens the Cupcake Corner, and create an user account;
- Make some cupcake order;

# Requirements
- Xcode 16+
- iOS 18+
- iPadOS 18+

# Workflow
* Reporting bugs:<br> 
If you come across any issues while using the Cupcake Corner, please report them by creating a new issue on the GitHub repository.

* Reporting bugs form: <br> 
```
App version: 1.0
iOS version: 18.0.1
Description: When I click on the "Mark as Ready For Delivery" button, the client and admin are't updated.
Steps to reproduce: Open "Order" tab, make a long press in some order, click in the "Mark as Ready For Delivery" button and nothing happens.
```

* Submitting pull requests: <br> 
If you have a bug fix or a new feature you'd like to add, please submit a pull request. Before submitting a pull request, 
please make sure that your changes are well-tested and that your code adheres to the Swift style guide.

* Improving documentation: <br> 
If you notice any errors or areas of improvement in the documentation, feel free to submit a pull request with your changes.

* Providing feedback:<br> 
If you have any feedback or suggestions for the Cupcake Corner project, please let us know by creating a new issue.


# Demonstration
[Click here](https://youtu.be/I1W6n__rPZo) to go to my YouTube channel, and see a brief demonstration of how the updated project is working <br>
[Click here](https://youtu.be/JXeca_3qchQ) to go to my YouTube channel, and see a a brief demonstration of how the original project is working.
