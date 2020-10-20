[![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](http://badges.mit-license.org)

# DatabaseProject

A repository for a universitary project on Database requirement analysis, conceptual design, logic design and implementation.

# Problem statement (in italian)

Si vuole realizzare una base di dati per la gestione giornaliera di un sistema di trasporto urbano mediante autobus
caratterizzato dal seguente insieme di requisiti.

* Il servizio sia organizzato in un certo insieme di linee di trasporto urbano. Ogni linea sia identificata uni-
vocamente da un numero (ad esempio, linea di trasporto urbano numero 1) e sia caratterizzata da un certo
numero di fermate. Si tenga traccia anche dell’ordine della fermate di una data linea.
* Ogni fermata sia identificata univocamente da un nome. Ad ogni fermata sia, inoltre, associato un indirizzo.
Una fermata possa essere raggiunta da più linee di trasporto.
* Si tenga traccia anche dei passaggi di una determinata linea in una determinata fermata. Si assuma che una
linea possa effettuare più passaggi in una data fermata nel corso della giornata, ovviamente in orari diversi.
Si escluda, invece, la possibilità che autobus di linee diverse possano passare nella stessa fermata esattamente
nello stesso orario.

La progettazione dovrà consistere delle seguenti fasi:

1. raccolta e analisi dei requisiti
1. progettazione concettuale
1.  progettazione logica
1. progettazione fisica
1. implementazione
1. analisi dei dati in R

N.B. La descrizione del problema va arricchita, se necessario, in modo da
includere tutti (o quasi) i costrutti trattati durante il corso.
