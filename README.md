# Table of Contents
1. [Description](#description)
2. [Getting started](#getting-started)
3. [Usage](#usage)
4. [Arhitecture](#arhitecture)
5. [Structure](#structure)
6. [Dependencies](#dependencies)
7. [Workflow](#workflow)
8. [Minimum versions](#minimum-versions)
9. [Demonstration](#demonstration)

# Cupcake Corner
 The better way to make your cupcakes order.
 
 # Description
<p>TThe Cupcake Corner project is a project focused on improving the experience of customers and store admins when selling their cupcakes.<br>
 
The project is design with the simplicity and power in mind.</p>

When you open the application for the first time you realize that its design is very easy to understand anything that is happening there, because it's designed to be understood by anyone. But its simple design does not mean simple, since under the hood, it was designed with cutting-edge technologies, which made the user experience fluid, fast, and consistent in all its actions.</p>
 
 # Getting started
<p>
1. Make sure you have the Xcode version 15.3 or above installed on your computer.<br>
2. Downloads the Cupcake Corner and Cupcake Corner API projects files from their repositorys.<br>
3. Follow the instructions from the Cupcake Corner API before to run the project.
4. Open the project files in Xcode.<br>
6. Review the code and make sure you understand what it does.<br>
7. Run the CupcakeCorner and CupcakeCornerForAdmin schemes.<br>

# Usage
- In Cupcake Corner For Admin, first log with the default admin account, that you defined on the UserSeed migration for the Database in the API;
- Create some cupcakes;
- Opens the Cupcake Corner, and create an user account;
- Make some cupcake order;

# Architecture
* Cupcake Corner project is implemented using the <strong>Model-View-ViewModel (MVVM)</strong> architecture pattern.
* Model has any necessary data or business logic needed to generate the "Orders", "Cupcake" and "User" manipulatios.
* View is responsible for displaying the some kind of data to the user, depending what type of action and screen that he is executing.
* ViewModel handles with the comunication with the backend, user interactions and update the Model and View as needed.
* Project utilize the <strong>SwiftData</strong> to store the all data that comes from in any API call.<br><br>

# Structure 
* "Common": Files or resources that are shared across multiple targets of the project. Such as networking handler, persistence store, models, errors, extensions, Views, ViewModels, entrypoint and splash screen.
* "CupcakeCorner": The source code files for a specific CupcakeCorner target. Such as create an Order DTO file, and the OrderView.
* "CupcakeCornerForAdmin": The source code files for a specific CupcakeCornerForAdmin target. Such as CRUD operation on the Cupcake Model, and specific views and ViewModels for handles with this actions.

# Dependencies
[SwiftPM](https://www.swift.org/documentation/package-manager/) is used as a dependency manager.
List of dependencies: 
* WebSocketHandler -> WebSocket library that ensures the real-time communication between the client and the admins of the store for updating the order status.

# Workflow
* Reporting bugs:<br> 
If you come across any issues while using the Cupcake Corner, please report them by creating a new issue on the GitHub repository.

* Reporting bugs form: <br> 
```
App version: 1.0
iOS version: 17.5
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

# Minimum versions
- Xcode 15.3+
- iOS 17.0+

# Demonstration
[Click here](https://youtu.be/iQyQrasddYA) to go to my YouTube channel, and see a a brief demonstration of how the project is working.
