-- Users Table
create table if not exists users (
    user_id serial primary key,
    name varchar(150) not null,
    email varchar(150) unique not null,
    password varchar(100) not null,
    phone_number varchar(20) not null,
    role varchar(30) check (role in ('Admin', 'Customer')) not null
);
-- Vehicles Table
create table if not exists vehicles (
    vehicle_id serial primary key,
    name varchar(150) not null,
    type varchar(30) check (type in ('car', 'bike', 'truck')) not null,
    model varchar(50) not null,
    registration_number varchar(50) unique not null,
    rental_price int not null,
    status varchar(30) check (status in ('available', 'rented', 'maintenance')) not null
);
-- Bookings Table
create table if not exists bookings (
    booking_id serial primary key,
    user_id int references users (user_id) on delete cascade,
    vehicle_id int references vehicles (vehicle_id) on delete cascade,
    start_date date not null,
    end_date date not null,
    status varchar(30) check (
        status in ('pending', 'confirmed', 'completed', 'cancelled')
    ) not null,
    total_cost int not null
);
-- Query 1: JOIN
select b.booking_id,
    u.name as customer_name,
    v.name as vehicle_name,
    b.start_date,
    b.end_date,
    b.status
from bookings b
    inner join users u on b.user_id = u.user_id
    inner join vehicles v on b.vehicle_id = v.vehicle_id;
-- Query 2: EXISTS
select *
from vehicles
where not exists (
        select *
        from bookings
        where bookings.vehicle_id = vehicles.vehicle_id
    );
-- Query 3: WHERE
select *
from vehicles
where type = 'car'
    and status = 'available';
-- Query 4: GROUP BY and HAVING
select v.name as vehicle_name,
    count(b.booking_id) as total_bookings
from vehicles v
    join bookings b on b.vehicle_id = v.vehicle_id
group by v.name
having count(b.booking_id) > 2;