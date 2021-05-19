#!/usr/bin/env python

from faker import Faker
import os
import random
from helpers import format_as_sql

fake = Faker(['it-IT'])
sql_file = '../sql/06_autista_telefono_autobus.sql'

random.seed(0)
drivers = []
telephone_numbers = []
drivers_fiscal = []
for i in range(75):
    fiscal = fake.unique.ssn()
    name = fake.first_name()
    surname = fake.last_name()
    address = fake.address().replace('\n', ' - ').replace("'", "''")
    birth   = fake.date_of_birth()
    driver_license = random.randint(1000000000, 9999999999)

    # Driver may have 0 to 3 phone numbers registered
    number_of_telephone_numbers = random.randint(0, 3)
    for i in range(number_of_telephone_numbers):
        telephone_number = random.randint(1000000000, 9999999999) # 10 digits phone number
        telephone_numbers.append(f"'{telephone_number}', '{fiscal}'")

    drivers.append(f"'{fiscal}', '{name}', '{surname}', '{address}', '{birth}', '{driver_license}'")
    drivers_fiscal.append(fiscal)

random.seed(0)
plates = []
autobuses = []
for i in range(100):
    plate = fake.unique.license_plate()
    autobuses.append(f"'{plate}', {random.randint(10, 30)}, {random.randint(10, 30)}")
    plates.append(plate)

if __name__ == '__main__':
    final_sql = f'''-- Set search path. Need to set it at the very start of every file.
    SET search_path TO SistemaTrasportoUrbano;

    INSERT INTO Autista VALUES {format_as_sql(drivers)};

    INSERT INTO Telefono VALUES {format_as_sql(telephone_numbers)};

    INSERT INTO Autobus VALUES {format_as_sql(autobuses)};
    '''

    with open(sql_file, 'w+') as f:
        f.write(final_sql)
    