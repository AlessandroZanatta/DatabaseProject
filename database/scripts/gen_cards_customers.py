#!/usr/bin/env python

from faker import Faker
import os
import random
from helpers import format_as_sql
import datetime


fake = Faker(['it-IT'])
sql_file = '../sql/05_tessere_clienti.sql'

cards = [fake.unique.credit_card_number() for _ in range(7500)]

random.seed(0)
customers = []
customers_fiscal = []
for i in range(7500):
    fiscal = fake.unique.ssn()
    name = fake.first_name()
    surname = fake.last_name()
    address = fake.address().replace('\n', ' - ').replace("'", "''")
    birth   = fake.date_of_birth()
    telephone_number = random.randint(1000000000, 9999999999) # 10 digits phone number
    card = cards[i]

    customers_fiscal.append(customers_fiscal)
    customers.append(f"'{fiscal}', '{name}', '{surname}', '{address}', '{birth}', '{telephone_number}', {card}")

if __name__ == '__main__':
    subs = []
    valids = []
    expireds = []
    subs_check = {}
    sub_types = ['mensile', 'trimestrale', 'annuale']
    for i in range(100000):
        cidx = i % len(cards)
        card = cards[cidx]
        sub_type = random.choice(sub_types)
        
        if i < 7500: # Valid
            if sub_type == 'mensile':
                start_date = fake.date_between(start_date='-28d', end_date='today')
            elif sub_type == 'trimestrale':
                start_date = fake.date_between(start_date='-84d', end_date='today')
            else: 
                start_date = fake.date_between(start_date='-365d', end_date='today')
            valids.append(f"{card}, '{start_date}'")
        else: # Expired
            while True:
                if sub_type == 'mensile':
                    start_date = fake.date_between(start_date='-100y', end_date='-30d')
                elif sub_type == 'trimestrale':
                    start_date = fake.date_between(start_date='-100y', end_date='-85d')
                else: 
                    start_date = fake.date_between(start_date='-100y', end_date='-366d')
                
                if start_date not in subs_check[card]:
                    break

            expireds.append(f"{card}, '{start_date}'")

        if card not in subs_check.keys():
            subs_check[card] = []

        subs_check[card].append(start_date)
        subs.append(f"{card}, '{start_date}', '{sub_type}'")


    final_sql = F'''-- Set search path. Need to set it at the very start of every file.
    SET search_path TO SistemaTrasportoUrbano;

    INSERT INTO Tessera VALUES {format_as_sql(cards)};
    INSERT INTO Cliente VALUES {format_as_sql(customers)};
    INSERT INTO Abbonamento VALUES {format_as_sql(subs)};
    INSERT INTO Valido VALUES {format_as_sql(valids)};
    INSERT INTO Scaduto VALUES {format_as_sql(expireds)};'''

    if os.path.exists(sql_file):
        os.unlink(sql_file)

    with open(sql_file, 'w+') as f:
        f.write(final_sql)
