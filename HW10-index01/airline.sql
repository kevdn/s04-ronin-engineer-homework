drop schema if exists flight_booking cascade;
create schema if not exists flight_booking;
set search_path to flight_booking;
-- Table: Aircraft
create table Aircraft
(
    aircraft_id SERIAL primary key,
    status      VARCHAR(20),
    name        VARCHAR(100)
);

-- Table: Airport
create table Airport
(
    airport_code VARCHAR(10) primary key,
    name         VARCHAR(100)
);

-- Table: Flight
create table Flight
(
    flight_id           SERIAL primary key,
    aircraft_id         INT,
    departure_airport   VARCHAR(10),
    destination_airport VARCHAR(10),
    departure_time      TIMESTAMP,
    destination_time    TIMESTAMP,
    status              VARCHAR(20)
);

-- Indexes for Flight
create index idx_flight_aircraft_id on Flight(aircraft_id);
create index idx_flight_departure_airport on Flight(departure_airport collate "C");
create index idx_flight_destination_airport on Flight(destination_airport collate "C");
create index idx_flight_departure_time on Flight using BRIN (departure_time);-- BRIN for range on large timestamped data

-- Table: Seat
create table Seat
(
    seat_code   VARCHAR(10) primary key,
    aircraft_id INT,
    position    VARCHAR(10),
    class       VARCHAR(20)
);

-- Indexes for Seat
create index idx_seat_aircraft_id on Seat(aircraft_id);

-- Table: Seat_Availability
create table Seat_Availability
(
    flight_id INT,
    seat_code VARCHAR(10),
    status    VARCHAR(20),
    price     DECIMAL(10, 2),
    primary key (flight_id, seat_code)
);

-- Table: Ticket
create table Ticket
(
    ticket_id    SERIAL primary key,
    passenger_id INT,
    flight_id    INT,
    seat_code    VARCHAR(10),
    status       VARCHAR(20),
    amount       DECIMAL(10, 2),
    booking_id   INT,
    issued_at    TIMESTAMP
);

-- Indexes for Ticket
create index idx_ticket_passenger_id on Ticket(passenger_id);
create index idx_ticket_flight_id on Ticket(flight_id);
create index idx_ticket_issued_at on Ticket using BRIN (issued_at);

-- Table: Passenger
create table Passenger
(
    passenger_id SERIAL primary key,
    name         VARCHAR(100),
    phone_number VARCHAR(15),
    email        VARCHAR(100)
);

-- Indexes for Passenger
CREATE INDEX idx_passenger_email ON passenger(email COLLATE "C");
CREATE INDEX idx_passenger_phone ON passenger(name COLLATE "C");

-- Table: Transaction
create table Transaction
(
    txn_id         SERIAL primary key,
    status         VARCHAR(20),
    type           VARCHAR(20) check (type in ('PAYMENT', 'REFUND')),
    debit_acc      VARCHAR(100),
    credit_acc     VARCHAR(100),
    payment_method VARCHAR(50),
    fee_or_charge  DECIMAL(10, 2),
    amount         DECIMAL(10, 2),
    booking_id     INT
);

-- Indexes for Transaction
create index idx_transaction_type on Transaction(type);
create index idx_transaction_booking_id on Transaction(booking_id);


-- Table: Entry
create table Entry
(
    entry_id       SERIAL primary key,
    sign           CHAR(1) check (sign in ('+', '-')),
    acc            VARCHAR(100),
    amount         DECIMAL(10, 2),
    status         VARCHAR(20),
    transaction_id INT not null
);

-- Indexes for Entry
create index idx_entry_transaction_id on Entry(transaction_id);

-- Table: Pricing_Config
create table Pricing_Config
(
    key   VARCHAR(50) primary key,
    value DECIMAL(10, 2)
);

-- Table: Booking
create table Booking
(
    booking_id      SERIAL primary key,
    status          VARCHAR(20) default 'init', -- init, paid, ticketed, done
    ticket_amount   DECIMAL(10, 2),
    fee_amount      DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2),
    total_amount    DECIMAL(10, 2),
    checkout_at     TIMESTAMP
);

-- Indexes for Booking
create index idx_booking_checkout_at on Booking using BRIN (checkout_at);

-- Table: Booking_Direction
create table Booking_Direction
(
    bd_id      SERIAL primary key,
    booking_id INT not null,
    direction  VARCHAR(20) check (direction in ('AWAY', 'HOME')),
    flight_id  INT not null,
    amount     DECIMAL(10, 2)
);

-- Table: Booking_Line
create table Booking_Line
(
    bl_id           SERIAL primary key,
    booking_id      INT not null,
    type            VARCHAR(20) check (type in ('TICKET', 'VAT', 'FEE')),
    unit_amount     DECIMAL(10, 2),
    quantity        INT,
    subtotal_amount DECIMAL(10, 2)
);

-- Table: Booking_Passenger
create table Booking_Passenger
(
    booking_id   INT,
    passenger_id INT,
    primary key (booking_id, passenger_id)
);

-- Table: BD_Ticket
create table BD_Ticket
(
    bd_id     INT not null,
    ticket_id INT not null,
    primary key (bd_id, ticket_id)
);
