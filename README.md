# NovaBlendSalon App Case Study

[![CI-macOS](https://github.com/mushthak/nova-blend-salon-case-study/actions/workflows/CI-macOS.yml/badge.svg)](https://github.com/mushthak/nova-blend-salon-case-study/actions/workflows/CI-macOS.yml)
[![CI-iOS](https://github.com/mushthak/nova-blend-salon-case-study/actions/workflows/CI-iOS.yml/badge.svg)](https://github.com/mushthak/nova-blend-salon-case-study/actions/workflows/CI-iOS.yml)
# Salon list Feature Specs

## 1. Story: Customer requests to see available salons

### Narrative #1

```
As customer
I want the app to show the latest remote salons
So I can always get the latest salon details 
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
  And customer requests to see salons
 Then the app should display the available salon list from remote
  And replace the cache with the new salon

```

### Narrative #2

```
As an offline customer
I want the app to show the latest saved salons
So I can always see the salon details 
```

#### Scenarios (Acceptance criteria)

```
Given the customer doesn't have connectivity
  And there’s a cached version of the salons
  And the cache is less than seven days old
 When the customer requests to see the salons
 Then the app should display the latest salons saved
 ```

 ```
Given the customer doesn't have connectivity
  And there’s a cached version of the salons
  And the cache is older than seven days old
 When the customer requests to see the salons
 Then the app should show empty list and delete cache
 ```

  ```
Given the customer doesn't have connectivity
  And the cache is empty
 When the customer requests to see the salons
 Then the app should show empty list
 ```
---

## Use Cases

### Load Salons Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Salons" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers salon data.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

---

### Load Salons From Cache Use Case

#### Primary course:
1. Execute "Load salons" command.
2. System retrieves salon data from cache.
3. System validates cache is less than seven days old.
4. System creates salon list from cached data.
5. System delivers salon list.

#### Retrieval error course (sad path):
1. System delivers error.

#### Expired cache course (sad path): 
1. System delivers no salons.

#### Empty cache course (sad path): 
1. System delivers no salons.

---

### Validate Salon Cache Use Case

#### Primary course:
1. Execute "Validate Cache" command with above data.
2. System retrieves salon data from cache.
3. System validates cache is less than seven days old.

#### Retrieval error course (sad path):
1. System deletes cache.

#### Expired cache course (sad path): 
1. System deletes cache.

---

### Cache Salons Use Case

#### Data:
- Salons

#### Primary course (happy path):
1. Execute "Save salons" command with above data.
2. System deletes old cache data.
3. System encodes salons.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting error course (sad path):
1. System delivers error.

#### Saving error course (sad path):
1. System delivers error.

---

## Flowchart

![NovaBlendSalon-Flowchart drawio](https://github.com/mushthak/nova-blend-salon-case-study/assets/11793859/279814bb-1bb3-49d1-afd2-f903f1e5b353)




## Model Specs

### Salon

| Property      | Type                |
|---------------|---------------------|
| `id`          | `UUID`              |
| `name`        | `String`            |
| `location`    | `String`            |
| `phone`       | `String` (optional) |
| `openTime`    | `Float`             |
| `closeTime`   | `Float`             |

### Payload contract

```
GET *url* (TBD)

200 RESPONSE

{
    "items": [
        {
            "id": "a UUID",
            "name": "a name",
            "location": "a location",
            "phone": "a phone number",
            "open_time": 9.30
            "close_time": 22.30,
        },
        {
            "id": "another UUID",
            "name": "another name",
            "location": "another location",
            "open_time": 10.30
            "close_time": 20.30,
        },
        {
            "id": "even another UUID",
            "name": "even another name",
            "location": "even another location",
            "open_time": 8.00
            "close_time": 14.00,
        },
        {
            "id": "yet another UUID",
            "name": "yet another name",
            "location": "yet another location",
            "open_time": 11.00
            "close_time": 16.00,
        }
        ...
    ]
}
```


## 2. Story: Customer requests an appointment with a salon

### Narrative #1

```
As customer
I want the book an appointment with a salon on my preferred date and time slot
so that I can secure a convenient time for my service.
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
  And customer selects a preferred date and time slot
When the customer requests to book an appointment with a salon  
Then the app should confirm the availability of the selected salon and time slot from the remote
 And book the appointment for the customer
 And update the cache with the new appointment details
 ```

 ```
 Given the customer does not have connectivity
	And the customer selects a preferred date and time slot
 When the customer attempts to book an appointment with a salon
	Then the app should display an error message indicating that booking requires an internet connection
 ```
## Model Specs 
### SalonAppointment

| Property      | Type                |
|---------------|---------------------|
| `id`          | `UUID`              |
| `time`        | `Date`              |
| `phone`       | `String`            |
| `email`       | `String` (optional) |
| `note`        | `String` (optional) |

### Payload contract

```
POST *url* (TBD)

REQUEST

{
  "salonId": "a UUID",
  "phone": "a phone number",
  "email": "an email id",
  "note": "a note",
}

201 RESPONSE
```
---

## App Architecture
![image description](architecture.svg)