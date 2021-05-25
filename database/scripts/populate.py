#!/usr/bin/env python

# Imports
import os
import random

from helpers import InsertQuery
from faker import Faker

# Quantity
N_DRIVERS = 75
N_AUTOBUS = 100
N_CUSTOMERS = 7500
N_SUBSCRIPTIONS = 100000
N_RIDES = 450 * 365
N_LINES = 15
N_SERVED = 90
N_STOPS = 225
N_USED = 12000

# Fixed seed
random.seed(0)
Faker.seed(0)

# Generator and output file
fake = Faker(['it-IT'])
sql_file = '../sql/05_populate.sql'

# Remove file if exists and re-create it
if os.path.exists(sql_file):
    os.unlink(sql_file)


# -------------------------------------------------------------------------------------------------- #

autobuses = InsertQuery('Autobus', 'Targa', 'InPiedi', 'Seduti')
drivers = InsertQuery('Autista', 'CodiceFiscale', 'Nome', 'Cognome', 'LuogoResidenza', 'DataNascita', 'NumeroPatente')
telephone_numbers = InsertQuery('Telefono', 'Numero', 'Autista')

#-------------#
# - Autobus - #
#-------------#

for _ in range(N_AUTOBUS):
    plate = fake.unique.license_plate()
    autobuses.append(plate, random.randint(10, 30), random.randint(10, 30))


#--------------------------------------#
# ------------- Autisti -------------- #
# - Numeri di telefono degli autisti - #
#--------------------------------------#
for _ in range(N_DRIVERS):
    fiscal = fake.unique.ssn()
    name = fake.first_name()
    surname = fake.last_name()
    address = fake.address().replace('\n', ' - ').replace("'", "''")
    birth   = fake.date_of_birth()
    driver_license = random.randint(1000000000, 9999999999)

    # Driver may have 0 to 3 phone numbers registered
    number_of_telephone_numbers = random.randint(0, 3)
    for _ in range(number_of_telephone_numbers):
        telephone_number = random.randint(1000000000, 9999999999) # 10 digits phone number
        telephone_numbers.append(telephone_number, fiscal)

    drivers.append(fiscal, name, surname, address, birth, driver_license)

with open(sql_file, 'a') as f:
    f.write('SET search_path TO SistemaTrasportoUrbano;\n')
    f.write(str(drivers))
    f.write(str(telephone_numbers))
    f.write(str(autobuses))

# -------------------------------------------------------------------------------------------------- #

#-------------#
# - Tessere - #
#-------------#
cards = InsertQuery('Tessera', 'NumeroTessera')
for _ in range(N_CUSTOMERS):
    cards.append(fake.unique.credit_card_number())

#-------------#
# - Clienti - #
#-------------#
customers = InsertQuery('Cliente', 'CodiceFiscale', 'Nome', 'Cognome', 'LuogoResidenza', 'DataNascita', 'NumeroTelefono', 'Tessera')
for i in range(N_CUSTOMERS):
    fiscal = fake.unique.ssn()
    name = fake.first_name()
    surname = fake.last_name()
    address = fake.address().replace('\n', ' - ').replace("'", "''")
    birth   = fake.date_of_birth()
    telephone_number = random.randint(1000000000, 9999999999) # 10 digits phone number
    card = cards.get('NumeroTessera', i)

    customers.append(fiscal, name, surname, address, birth, telephone_number, card)

#-----------------#
# - Abbonamenti - #
# --- Validi ---- #
# --- Scaduti --- #
#-----------------#
subs = InsertQuery('Abbonamento', 'Tessera', 'DataInizio', 'TipoAbbonamento')
valids = InsertQuery('Valido', 'Tessera', 'DataInizio')
expireds = InsertQuery('Scaduto', 'Tessera', 'DataInizio')
subs_check = {}
sub_types = ['mensile', 'trimestrale', 'annuale']
for i in range(N_SUBSCRIPTIONS):
    card = cards.get('NumeroTessera', i % N_CUSTOMERS)
    sub_type = random.choice(sub_types)
    
    if i < 7500: # Valid
        if sub_type == 'mensile':
            start_date = fake.date_between(start_date='-28d', end_date='today')
        elif sub_type == 'trimestrale':
            start_date = fake.date_between(start_date='-84d', end_date='today')
        else: 
            start_date = fake.date_between(start_date='-365d', end_date='today')
        valids.append(card, start_date)
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

        expireds.append(card, start_date)


    if card not in subs_check.keys():
        subs_check[card] = []

    subs_check[card].append(start_date)
    subs.append(card, start_date, sub_type)

with open(sql_file, 'a') as f:
    f.write(str(cards))
    f.write(str(customers))
    f.write(str(subs))
    f.write(str(valids))
    f.write(str(expireds))


# -------------------------------------------------------------------------------------------------- #

executed = InsertQuery('HaEseguito', 'Id', 'DataOra', 'AutoBus', 'Autista')
for i in range(N_RIDES):
    date = fake.date_time()
    autobus = random.choice(autobuses.get_col('Targa'))
    driver = random.choice(drivers.get_col('CodiceFiscale'))
    executed.append(i, date, autobus, driver)

lines = InsertQuery('LineaTrasportoUrbano', 'Numero', 'NumeroFermate')
for i in range(N_LINES):
    number = str(i)
    number_of_stops = random.randint(10, 30) # mean = 20
    lines.append(number, number_of_stops)

rides = InsertQuery('Corsa', 'NumeroLinea', 'EseguitoId')
for i in range(N_RIDES):
    line = random.randint(1, N_LINES)
    rides.append(line, i)

served_by = InsertQuery('ServitaDa', 'Targa', 'NumeroLinea')
check = {i:[] for i in range(N_LINES)}
for i in range(N_SERVED):
    line = i % N_LINES
    while True:
        autobus = random.choice(autobuses.get_col('Targa'))
        if autobus not in check[line]:
            break
    check[line].append(autobus)
    served_by.append(autobus, line)

busstops = InsertQuery('Fermata', 'Nome', 'Indirizzo')
for i in range(N_STOPS):
    name = fake.unique.md5()
    address = fake.address().replace('\n', ' - ').replace("'", "''")

    busstops.append(name, address)

composto = InsertQuery('Composto', 'NomeFermata', 'NumeroLinea', 'Posizione')
check = {}
for line, nstops in lines.get_zipped('Numero', 'NumeroFermate'):
    check[line] = []
    for i in range(int(nstops)):
        while True:
            stopname = random.choice(busstops.get_col('Nome'))
            if stopname not in check[line]:
                break
        
        check[line].append(stopname)
        composto.append(stopname, line, i+1) # from 1 to nstops


used = InsertQuery('HaUsufruito', 'Cliente', 'EseguitoId', 'NumeroLinea')
for _ in range(N_USED):
    execd, line = random.choice(rides.get_zipped('EseguitoId', 'NumeroLinea'))
    user = random.choice(customers.get_col('CodiceFiscale'))
    used.append(user, execd, line)

with open(sql_file, 'a') as f:
    f.write('START TRANSACTION;')
    f.write('SET CONSTRAINTS ALL DEFERRED;')
    f.write(str(served_by))
    f.write(str(composto))
    f.write(str(lines))
    f.write(str(busstops))
    f.write(str(executed))
    f.write(str(rides))
    f.write(str(used))