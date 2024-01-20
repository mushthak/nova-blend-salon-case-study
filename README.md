# NovaBlendSalon App Case Study

## Salon list Feature Specs

### Story: Customer requests to see available salons

### Narrative #1

```
As customer
I want the app to show the latest saved salons
So I can always see the salon details 
```

#### Scenarios (Acceptance criteria)

```
Given the customer
  And there’s a cached version of the salons
  And the cache is less than seven days old
 When the customer requests to see the salons
 Then the app should display the latest salons saved
 ```

 ```
Given the customer
  And there’s a cached version of the salons
  And the cache is older than seven days old
 When the customer requests to see the salons
 Then the app should show empty list and delete cache
 ```

  ```
Given the customer
  And the cache is empty
 When the customer requests to see the salons
 Then the app should show empty list
 ```

 ### Narrative #2

```
As customer
I want the app to show the latest remote salons
So I can always get the latest salon details 
```

#### Scenarios (Acceptance criteria)

```
Given the customer has connectivity
  And customer viewed the latest salons saved
 Then the app should display the available salon list from remote
  And replace the cache with the new salon

Given the customer doesn't have connectivity
  And customer viewed the latest salons saved
 Then the app should display an error message

```

## Use Cases

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

### Load Salons Data From Remote Use Case

#### Data:
- URL

#### Primary course (happy path):
1. Execute "Load Salons" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System delivers salon data.

#### Cancel course:
1. System does not deliver image data nor error.

#### Invalid data – error course (sad path):
1. System delivers invalid data error.

#### No connectivity – error course (sad path):
1. System delivers connectivity error.

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

![Salon Loading Feature](salon_flowchart.drawio.png)

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
            "openTime": 9.30
            "closeTime": 22.30,
        },
        {
            "id": "another UUID",
            "name": "another name",
            "location": "another location",
            "openTime": 10.30
            "closeTime": 20.30,
        },
        {
            "id": "even another UUID",
            "name": "even another name",
            "location": "even another location",
            "openTime": 8.00
            "closeTime": 14.00,
        },
        {
            "id": "yet another UUID",
            "name": "yet another name",
            "location": "yet another location",
            "openTime": 11.00
            "closeTime": 16.00,
        }
        ...
    ]
}
```
