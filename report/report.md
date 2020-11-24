---
title: Relazione Basi di Dati 2020-2021
author: 
  - Alessandro Zanatta, Christian Abbondo,
  - Samuele Anzolin e Fabiana Rapicavoli
date:
  - 10-09-2020
header-includes:
  - \usepackage{amsmath}
---

\newpage

# Introduzione



\newpage

# Analisi dei requisiti

Iniziamo riportando il testo del progetto assegnato:

Si vuole realizzare una base di dati per la gestione giornaliera di un sistema di trasporto urbano mediante autobus caratterizzato dal seguente insieme di requisiti:

- Il servizio sia organizzato in un certo insieme di linee di trasporto urbano. Ogni linea sia identificata univocamente da un numero (ad esempio, linea di trasporto urbano numero 1) e sia caratterizzata da un certo numero di fermate. Si tenga traccia anche dell’ordine della fermate di una data linea.
- Ogni fermata sia identificata univocamente da un nome. Ad ogni fermata sia, inoltre, associato un indirizzo. Una fermata possa essere raggiunta da più linee di trasporto.
- Si tenga traccia anche dei passaggi di una determinata linea in una determinata fermata. Si assuma che una linea possa effettuare più passaggi in una data fermata nel corso della giornata, ovviamente in orari diversi. Si escluda, invece, la possibilità che autobus di linee diverse possano passare nella stessa fermata esattamente nello stesso orario.
- Ogni linea è servita, nello stesso giorno da uno o più autobus. Ogni autobus è identificato univocamente dal numero di immatricolazione ed è caratterizzato da un numero di posti (in piedi e a sedere) e da un autista. <!--Sono presenti due tipologie di autobus: turistici e di linea.-->
- L'autista di un autobus identificabile univocamente tramite il suo codice fiscale o per mezzo del numero di patente ed è caratterizzato da nome, cognome, data di nascita e luogo di residenza e da zero o più numeri di recapito telefonico.
- I clienti che usufruiscono del servizio di trasporto possono viaggiare tramite biglietti giornalieri o tramite abbonamento. Si è interessati unicamente alla memorizzazione degli utenti abbonati (dei quali cioè si conoscono i dati anagrafici). Si vuole, in particolare, tener traccia dei loro spostatamenti, cioè si vogliono conoscere le linee di cui ha usufruito nelle varie giornate, e del numero di linee percorse mensilmente.
- Un abbonamento è intestato a uno e un solo cliente il quale è identificato tramite codice fiscale ed è caratterizzato da nome, cognome, data di nascita e luogo di residenza e da un recapito telefonico (utilizzato in caso di smarrimento dell'abbonamento stesso).


Il **dominio di interesse** della base di dati è definito nella prima frase ed è il *sistema di trasporto urbano mediante autobus*.

Definiamo un ***glossario dei termini*** per disambiguare eventuali termini generici, eliminare i sinonomi presenti nel testo e definire in maniera univoca il significato dei termini utilizzati:

| **Termine**                     | **Descrizione**                                                                | **Sinonimi**                 | **Collegamenti**                        |
|-----------------------------|----------------------------------------------------------------------------|--------------------------|-------------------------------------|
| Sistema di trasporto urbano | Dominio della base di dati                                                 | Servizio                 |                                     |
| Linea di trasporto urbana   | Successione di fermate dell'autobus                                        | Linea di trasporto Linea | Fermata Passaggio                   |
| Fermata                     | Punto di salito e/o discesa per un determinato luogo                       |                          | Linea di trasporto urbana Passaggio |
| Passaggio                   | Transito di un autobus appartenente ad una data linea in una certa fermata |                          | Linea di trasporto urbana  Fermata  |

\newpage

Riscriviamo ora quindi i requisiti ristrutturandoli in gruppi di frasi omogenee, relative cioè agli stessi concetti.

| Frasi di ***carattere generale*** |
|:----------------------------------------------------------------------------------------------------------------------:|
| Si vuole realizzare una base di dati per la gestione giornaliera di un sistema di trasporto urbano mediante autobus. |

| Frasi relative alle ***linee di trasporto urbane*** |
|:-----------------------:|
| Il sistema di trasporto urbano sia organizzato in un certo insieme di linee di trasporto urbano. Ogni linea di trasporto urbano sia identificata univocamente da un numero (ad esempio, linea di trasporto urbano numero 1) e sia caratterizzata da un certo numero di fermate. Si tenga traccia anche dell’ordine della fermate di una data linea di trasporto urbano. |

| Frasi relative alle ***fermate*** |
|:-----------------------:|
| Ogni fermata sia identificata univocamente da un nome. Ad ogni fermata sia, inoltre, associato un indirizzo. Una fermata possa essere raggiunta da più linee di trasporto urbane. |

| Frasi relative ai ***passaggi*** |
|:-----------------------:|
| Si tenga traccia anche dei passaggi degli autobus appartenenti ad una determinata linea di trasporto urbano in una specifica fermata. Si assuma che una linea di trasporto urbano possa effettuare più passaggi in una data fermata nel corso della giornata, ovviamente in orari diversi. Si escluda, invece, la possibilità che autobus di linee di trasporto urbano diverse possano passare nella stessa fermata esattamente nello stesso orario. |


<!-- Uno o due attributi derivati dal conteggio di relazioni con cui una certa entità partecipa (es. numero di fermate di una certa linea!) -->
<!-- Attributi derivati (1-2, max 3), attributi composti, multivalore, generalizzazioni (1-2) -->
<!-- Numero di fermate di una linea di trasporto -->
<!-- Nei casi in cui è possibile, tenere uno storico di informazioni passate -->

<!-- Definire un insieme di operazioni che pensiamo essere più frequenti (7-10 operazioni) indicando le frequenze -->
<!-- Devono esserci, fra queste operazioni, sia letture sia aggiornamento di dati ridondanti (1 che beneficia del dato ridondate (letture) e 1 che NON beneficia del dato ridondante (aggiornamento)) -->
<!-- Inserimento di una nuova linea di trasporto(?) -->


<!-- Lo storico NON c'è in quanto si parla di una base di dati GIORNALIERA -->

\newpage

# Progettazione concettuale

\newpage

# Progettazione logica

\newpage

# Progettazione fisica

\newpage

# Implementazione

\newpage

# Analisi dei dati