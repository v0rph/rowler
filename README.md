# ROWLER
A bowling game api

## API Description

### CREATE 
Path | Method | Description
--- | --- | ---
/v1/games | POST | Creates a new game

#### Usage
```shell
curl -X POST http://localhost:3000/v1/games
```

#### Response
```
{
  "game":{"id":1,"finished":false,"current_frame":1,"score":0,
  "frames":[
    {"number":1,"first_throw":-1,"second_throw":-1,"points":0},{"number":2,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":3,"first_throw":-1,"second_throw":-1,"points":0},{"number":4,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":5,"first_throw":-1,"second_throw":-1,"points":0},{"number":6,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":7,"first_throw":-1,"second_throw":-1,"points":0},{"number":8,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":9,"first_throw":-1,"second_throw":-1,"points":0},{"number":10,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":11,"first_throw":-1,"second_throw":-1,"points":0},{"number":12,"first_throw":-1,"second_throw":-1,"points":0}
  ]}
}
```

### UPDATE

Path | Method | Parameters | Description
--- | --- | --- | ---
/v1/games/{id}  | PUT | throw | Registers a single throw, calculates score based on how many pins are dropped and updates bonus score for frames that were a Strike or Spare


#### Usage
```shell
curl -X PUT -d throw=5 http://localhost:3000/v1/games/1
```

#### Response
```
{
  "game":{"id":1,"finished":false,"current_frame":1,"score":0,
  "frames":[
    {"number":1,"first_throw":5,"second_throw":-1,"points":0},{"number":2,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":3,"first_throw":-1,"second_throw":-1,"points":0},{"number":4,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":5,"first_throw":-1,"second_throw":-1,"points":0},{"number":6,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":7,"first_throw":-1,"second_throw":-1,"points":0},{"number":8,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":9,"first_throw":-1,"second_throw":-1,"points":0},{"number":10,"first_throw":-1,"second_throw":-1,"points":0},
    {"number":11,"first_throw":-1,"second_throw":-1,"points":0},{"number":12,"first_throw":-1,"second_throw":-1,"points":0}
  ]}
}
```
#### Errors

Validates if game already ended  
Status 422: ```{"base":[{"message":"This game has ended."}]}```

Validates throw (first or second) over 10 pins for single frame  
Status 422: ```{"base":[{"message":"Invalid Play."}]}```

### Show

Path | Method | Description
--- | --- | --- |
/v1/games/{id}  | GET | Returns requested game info

Show action features HTTP Caching with etag support

#### Usage
```shell
curl http://localhost:3000/v1/games/1

# take advantage of HTTP caching
curl -H 'if-None-Match: "686897696a7c876b7e"' http://localhost:3000/v1/games/1
```

#### Response
```
{
  "game":{"id":1,"finished":true,"current_frame":13,"score":300,
  "frames":[
    {"number":1,"first_throw":10,"second_throw":-1,"points":30},{"number":2,"first_throw":10,"second_throw":-1,"points":60},
    {"number":3,"first_throw":10,"second_throw":-1,"points":90},{"number":4,"first_throw":10,"second_throw":-1,"points":120},
    {"number":5,"first_throw":10,"second_throw":-1,"points":150},{"number":6,"first_throw":10,"second_throw":-1,"points":180},
    {"number":7,"first_throw":10,"second_throw":-1,"points":210},{"number":8,"first_throw":10,"second_throw":-1,"points":240},
    {"number":9,"first_throw":10,"second_throw":-1,"points":270},{"number":10,"first_throw":10,"second_throw":-1,"points":300},
    {"number":11,"first_throw":10,"second_throw":-1,"points":320},{"number":12,"first_throw":10,"second_throw":-1,"points":330}
  ]}
}
```
