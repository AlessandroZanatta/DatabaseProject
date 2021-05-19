#!/usr/bin/env python

from faker import Faker
import os
import random
from helpers import format_as_sql
from gen_cards_customers import customers_fiscal
from gen_driver_telephone_autobus import drivers_fiscal, plates 

random.seed(0)

fake = Faker(['it-IT'])
sql_file = '../sql/07_popolamento_restante.sql'

number_of_rides = 450 * 365

executed = []
for i in range(number_of_rides):
    date = fake.date_time()
    autobus = random.choice(plates)
    driver = random.choice(drivers_fiscal)
    executed.append(f"{i}, '{date}', '{autobus}', '{driver}'")

lines = []
lines_stops = {}
lines_number = 15
for i in range(lines_number):
    number = str(i)
    number_of_stops = random.randint(10, 30) # mean = 20
    lines_stops[number] = number_of_stops
    lines.append(f"'{number}', {number_of_stops}")

rides = []
rides_list = []
for i in range(number_of_rides):
    line = random.randint(1, lines_number)
    execd = i
    rides.append(f"'{line}', {execd}")
    rides_list.append((execd, line))

serviced_by = []
check = {i:[] for i in range(lines_number)}
print(plates)
for i in range(90):
    line = i % lines_number
    while True:
        autobus = random.choice(plates)
        if autobus not in check[line]:
            break
    
    print(autobus, autobus in plates)
    check[line].append(autobus)
    serviced_by.append(f"'{autobus}', '{line}'")

busstops = []
busstops_names = []
for i in range(225):
    name = fake.unique.md5()
    address = fake.address().replace('\n', ' - ').replace("'", "''")

    busstops.append(f"'{name}', '{address}'")
    busstops_names.append(name)


composto = []
check = {}
for line, nstops in lines_stops.items():
    check[line] = []
    for i in range(nstops):
        while True:
            stopname = random.choice(busstops_names)
            if stopname not in check[line]:
                break
        
        check[line].append(stopname)
        composto.append(f"'{stopname}', '{line}', {i+1}") # from 1 to nstops


used = []
for i in range(12000):
    execd, line = random.choice(rides_list)
    user = random.choice(customers_fiscal)
    used.append(f"'{user}', '{execd}', '{line}'")


final_sql = f'''-- Set search path. Need to set it at the very start of every file.
SET search_path TO SistemaTrasportoUrbano;

START TRANSACTION;
SET CONSTRAINTS ALL DEFERRED;

SELECT Targa FROM Autobus;
INSERT INTO ServitaDa VALUES {format_as_sql(serviced_by)};
INSERT INTO Composto VALUES {format_as_sql(composto)};
INSERT INTO LineaTrasportoUrbano VALUES {format_as_sql(lines)};
INSERT INTO Fermata VALUES {format_as_sql(busstops)};

INSERT INTO HaEseguito VALUES {format_as_sql(executed)};
INSERT INTO Corsa VALUES {format_as_sql(rides)};
INSERT INTO HaUsufruito VALUES {format_as_sql(used)};

COMMIT;
'''

with open(sql_file, 'w+') as f:
    f.write(final_sql)
  
# TODO
# - Merge everything in a single file, less hassle to make it work
# - Code is horrible, refactor plz