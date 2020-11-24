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

> Si vuole realizzare una base di dati per la gestione giornaliera di un sistema di trasporto urbano mediante autobus caratterizzato dal seguente insieme di requisiti:

> - Il servizio sia organizzato in un certo insieme di linee di trasporto urbano. Ogni linea sia identificata univocamente da un numero (ad esempio, linea di trasporto urbano numero 1) e sia caratterizzata da un certo numero di fermate. Si tenga traccia anche dell’ordine della fermate di una data linea.
> - Ogni fermata sia identificata univocamente da un nome. Ad ogni fermata sia, inoltre, associato un indirizzo. Una fermata possa essere raggiunta da più linee di trasporto.
> - Si tenga traccia anche dei passaggi di una determinata linea in una determinata fermata. Si assuma che una linea possa effettuare più passaggi in una data fermata nel corso della giornata, ovviamente in orari diversi. Si escluda, invece, la possibilità che autobus di linee diverse possano passare nella stessa fermata esattamente nello stesso orario.

Il dominio di interesse della base di dati è definito nella prima frase ed è il *sistema di trasporto urbano mediante autobus*.

Definiamo un glossario dei termini per disambiguare eventuali termini generici, eliminare i sinonomi presenti nel testo e definire in maniera univoca il significato dei termini utilizzati:

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