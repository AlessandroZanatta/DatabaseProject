#!/usr/bin/env python

from faker import Faker
import os
from random import randint

fake = Faker(['it-IT'])
sql_file = 'sql/05_tessere_clienti.sql'

cards = [fake.unique.credit_card_number() for _ in range(7500)]

formatted_cards = [f'({c}),' for c in cards]

cards_sql = '''-- Set search path. Need to set it at the very start of every file.
SET search_path TO SistemaTrasportoUrbano;

INSERT INTO Tessera VALUES ''' + ''.join(formatted_cards)[:-1] + ';'

customers = []
for i in range(7500):
    fiscal = fake.unique.ssn()
    name = fake.first_name()
    surname = fake.last_name()
    address = fake.address().replace('\n', ' - ').replace("'", "''")
    birth   = fake.date_of_birth()
    telephone_number = randint(1000000000, 9999999999) # 10 digits phone number
    card = cards[i]

    customers.append(f"'{fiscal}', '{name}', '{surname}', '{address}', '{birth}', '{telephone_number}', {card}")

formatted_customers = [f'({c}),' for c in customers]
customers_sql = 'INSERT INTO Cliente VALUES ' + ''.join(formatted_customers)[:-1] + ';'

final_sql = cards_sql + '\n' + customers_sql

if os.path.exists(sql_file):
    os.unlink(sql_file)

with open(sql_file, 'w+') as f:
    f.write(final_sql)
