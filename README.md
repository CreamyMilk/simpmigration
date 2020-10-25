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
  "message": 0,
  "info": {
    "username": "JohnDoe",
    "uid": "24",
    "mobile": "+9999999",
    "transaction": {
      "title": "Transactions",
      "data": [
        {
          "month": "August",
          "time": "11/08/2020",
          "year": "2020",
          "rs": 1,
          "rent_status": true,
          "rec": {
            "username": "JohnDoe",
            "branch": "Kahawa Sukari",
            "house": "GF4A",
            "receiptNumber": "WC2340923409",
            "description": "Mpesa Directpaymets",
            "amount": 10100
          }
        },
        {
          "month": "September",
          "time": "06/09/2020",
          "year": "2020",
          "rs": 1,
          "rent_status": true,
          "rec": {
            "username": "JohnDoe",
            "branch": "Kahawa Sukari",
            "house": "GF4A",
            "receiptNumber": "WC2340923409",
            "description": "Mpesa Directpaymets",
            "amount": 10000
          }
        }
      ]
    },
    "complains": [
      ""
    ],
    "services": [
      ""
    ],
    "rent": {
      "account": "johnk#GF4A",
      "month": "October",
      "rentDue": 10000,
      "rent_status": false
    },
    "lastIssue": "0",
    "lastService": "0"
  }
}
transaction
[
  {
  "month":"Jan",
  "time":"12/20/2020",
  "year":"2020",
  "rent_status":"90",
  "rec":{
    "username":"boom",
    "branch":"Kahawa Sukari,Kenya",
    "house":"A12",
    "receiptNumber":"WC2340923409",
    "description":"Mpesa Express 9.30am by 254797678353","amount":9000}
  }
]

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
  
}

OTP RESPONSES
```json
{
  "message_code":0,
  "message_descritipon":"sds",
}
```