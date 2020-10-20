# Clone 😊

Flutter version 1.20.4

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
inital jsonpayload required fomr login 
```dart
    Map<String, dynamic> transactions = {
    "title": "Transactions",
    "data": ["TestStore", "Sept", "August", "July", "June", "May", "Feb", "Oct"],
  };
    Map<String, dynamic> complains = {
    "title": "Expenses",
    "data": ["Water", "Painting", "Gas"]
  };
```
```json
 {
    "username":"LOGGEDIN",
    "uid": "34",
    "mobile":"0797678252",
    "transaction":transactions,
    "complains":complains,
    "services":services,
    "rent": {
        "month":"January",
        "rentDue":77,
        "rentStatus":false
        },
    "lastIssue":"number AND ARRAY",
    "lastService":"number and"
};
transaction
{
    "type":"Mpesa",//Help
    "transAmount":3000,
    "transactionBy":"Jotham Kabasa Kinyua",
    "time":"12/20/2020",
    "transID":"323",
    "mpeasaTransID":"23",
    "notificationID":"wcf20202020",
    "houseNo":"A001"
}
complains
{
  "
}


```