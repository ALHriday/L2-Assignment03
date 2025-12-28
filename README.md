# 🚗 Vehicle Rental System – Database Design

This repository contains the complete PostgreSQL database design and SQL queries for a Vehicle Rental System.
It defines the tables, relationships, constraints, and example queries used to manage users, vehicles, and bookings.


## 📌 Project Purpose

The purpose of this project is to provide a well-structured relational database schema for a vehicle rental application including:

- **User management**
- **Vehicle inventory**
- **Booking and rental tracking**

## 🛠 Technology

- **Database: PostgreSQL**
- **Language: SQL**
- **Design Tool: Lucidchart (ERD)**

## Users

### Sample Data (Input)

```
insert into
  users
values
  (
    1,
    'Alice',
    'alice@example.com',
    '123456',
    '1234567890',
    'Customer'
  ),
  (
    2,
    'Bob',
    'bob@example.com',
    '222333',
    '0987654321',
    'Admin'
  ),
  (
    3,
    'Charlie',
    'charlie@example.com',
    '555666',
    '1122334455',
    'Customer'
  )
```

### Output
#### Users Table
| user_id | name    | email               | phone      | role     |
| :------ | :------ | :------------------ | :--------- | :------- |
| 1       | Alice   | alice@example.com   | 1234567890 | Customer |
| 2       | Bob     | bob@example.com     | 0987654321 | Admin    |
| 3       | Charlie | charlie@example.com | 1122334455 | Customer |

## Vehicles

### Sample Data (Input)

```
insert into
  vehicles
values
  (
    1,
    'Toyota Corolla',
    'car',
    '2022',
    'ABC-123',
    50,
    'available'
  ),
  (
    2,
    'Honda Civic',
    'car',
    '2021',
    'DEF-456',
    60,
    'rented'
  ),
  (
    3,
    'Yamaha R15',
    'bike',
    '2023',
    'GHI-789',
    50,
    'available'
  ),
  (
    4,
    'Ford F-150',
    'truck',
    '2020',
    'JKL-012',
    100,
    'maintenance'
  )
```

### Output
#### Vehicles Table
| vehicle_id | name           | type  | model | registration_number | rental_price | status      |
| :--------- | :------------- | :---- | :---- | :------------------ | :----------- | :---------- |
| 1          | Toyota Corolla | car   | 2022  | ABC-123             | 50           | available   |
| 2          | Honda Civic    | car   | 2021  | DEF-456             | 60           | rented      |
| 3          | Yamaha R15     | bike  | 2023  | GHI-789             | 30           | available   |
| 4          | Ford F-150     | truck | 2020  | JKL-012             | 100          | maintenance |

## Bookings

### Sample Data (Input)
```
insert into
  bookings
values
  (
    1,
    1,
    2,
    '2023-10-01',
    '2023-10-05',
    'completed',
    240
  ),
  (
    2,
    1,
    2,
    '2023-11-01',
    '2023-11-03',
    'completed',
    120
  ),
  (
    3,
    3,
    2,
    '2023-12-01',
    '2023-12-02',
    'confirmed',
    60
  ),
  (
    4,
    1,
    1,
    '2023-12-10',
    '2023-12-12',
    'pending',
    100
  )
```

### Output
#### Bookings Table
| booking_id | user_id | vehicle_id | start_date | end_date   | status    | total_cost |
| :--------- | :------ | :--------- | :--------- | :--------- | :-------- | :--------- |
| 1          | 1       | 2          | 2023-10-01 | 2023-10-05 | completed | 240        |
| 2          | 1       | 2          | 2023-11-01 | 2023-11-03 | completed | 120        |
| 3          | 3       | 2          | 2023-12-01 | 2023-12-02 | confirmed | 60         |
| 4          | 1       | 1          | 2023-12-10 | 2023-12-12 | pending   | 100        |

---

## Query Results

### Query 1: JOIN

```
select
  b.booking_id,
  u.name as customer_name,
  v.name as vehicle_name,
  b.start_date,
  b.end_date,
  b.status
from
  bookings b
  inner join users u on b.user_id = u.user_id
  inner join vehicles v on b.vehicle_id = v.vehicle_id;
```

**Output**:
| booking_id | customer_name | vehicle_name   | start_date | end_date   | status    |
| :--------- | :------------ | :------------- | :--------- | :--------- | :-------- |
| 1          | Alice         | Honda Civic    | 2023-10-01 | 2023-10-05 | completed |
| 2          | Alice         | Honda Civic    | 2023-11-01 | 2023-11-03 | completed |
| 3          | Charlie       | Honda Civic    | 2023-12-01 | 2023-12-02 | confirmed |
| 4          | Alice         | Toyota Corolla | 2023-12-10 | 2023-12-12 | pending   |

---

### Query 2: EXISTS

```
select
  *
from
  vehicles
where
  not exists (
    select
      *
    from
      bookings
    where
      bookings.vehicle_id = vehicles.vehicle_id
  );
```

**Output**:
| vehicle_id | name       | type  | model | registration_number | rental_price | status      |
| :--------- | :--------- | :---- | :---- | :------------------ | :----------- | :---------- |
| 3          | Yamaha R15 | bike  | 2023  | GHI-789             | 30           | available   |
| 4          | Ford F-150 | truck | 2020  | JKL-012             | 100          | maintenance |

---

### Query 3: WHERE

```
select
  *
from
  vehicles
where
type
  = 'car'
  and status = 'available';
```

**Output**:
| vehicle_id | name           | type | model | registration_number | rental_price | status    |
| :--------- | :------------- | :--- | :---- | :------------------ | :----------- | :-------- |
| 1          | Toyota Corolla | car  | 2022  | ABC-123             | 50           | available |

---

### Query 4: GROUP BY and HAVING

```
select
  v.name as vehicle_name,
  count(b.booking_id) as total_bookings
from
  vehicles v
  join bookings b on b.vehicle_id = v.vehicle_id
group by
  v.name
having
  count(b.booking_id) > 2;
```

**Output**:
| vehicle_name | total_bookings |
| :----------- | :------------- |
| Honda Civic  | 3              |

---

## 👨‍💻 Author
#### Alauddin Hriday
Database & Web Developer
Specialized in PostgreSQL, SQL, and System Design