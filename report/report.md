---
title: Relazione Basi di Dati 2020-2021
author: Alessandro Zanatta, Christian Abbondo, Samuele Anzolin e Fabiana Rapicavoli
date:
  - 10-09-2020
header-includes:
  - \usepackage{amsmath}
geometry: "left=3cm,right=3cm,top=2cm,bottom=2cm"
---

\newpage

# Introduzione



\newpage

# Analisi dei requisiti

Iniziamo riportando il testo del progetto assegnato:

Si vuole realizzare una base di dati per la gestione giornaliera di un sistema di trasporto urbano mediante autobus caratterizzato dal seguente insieme di requisiti:

- Il servizio sia organizzato in un certo insieme di linee di trasporto urbano. Ogni linea sia identificata univocamente da un numero (ad esempio, linea di trasporto urbano numero 1) e sia caratterizzata da un certo numero di fermate. Si tenga traccia anche dell’ordine della fermate di una data linea.
- Ogni fermata sia identificata univocamente da un nome. Ad ogni fermata sia, inoltre, associato un indirizzo. Una fermata possa essere raggiunta da più linee di trasporto.
- Ogni linea è servita, nello stesso giorno, da uno o più autobus. Ogni autobus è identificato univocamente dal numero di immatricolazione ed è caratterizzato da un numero di posti (in piedi e a sedere). Un autobus può essere guidato da guidatori diversi. Si vuol tener traccia dell'autobus e del guidatore che ha eseguito una corsa (su una certa linea, una corsa corrisponde ad un'istanza di linea effettuata ad una certa ora e giorno).
- L'autista di un autobus è identificabile univocamente tramite il suo codice fiscale o per mezzo del numero di patente ed è caratterizzato da nome, cognome, data di nascita e luogo di residenza e da zero o più numeri di recapito telefonico.
- I clienti che usufruiscono del servizio di trasporto possono viaggiare tramite biglietti giornalieri o tramite abbonamento. Si è interessati unicamente alla memorizzazione degli utenti tesserati. Si vuole, in particolare, tener traccia dei loro spostamenti, cioè si vogliono conoscere le corse di cui ha usufruito e il numero di corse utilizzate mensilmente.
- Un abbonamento è identificato univocamente da un numero di tessera e dalla data di inizio (si suppone che ad una tessera non siano collegati abbonamenti con la stessa data di inizio in quanto un singolo abbonamento permette di usufruire di qualsiasi autobus), è caratterizzato da un tipo di abbonamento (mensile, trimestrale, annuale). Ogni tessera è intestata a uno e un solo cliente il quale è, a sua volta, identificato tramite codice fiscale ed è caratterizzato da nome, cognome, data di nascita e luogo di residenza e da un recapito telefonico (utilizzato in caso di smarrimento dell'abbonamento stesso). Si vuole tener traccia di tutti gli abbonamenti sottoscritti dal cliente tesserato. 


Il **dominio di interesse** della base di dati è definito nella prima frase ed è il *sistema di trasporto urbano mediante autobus*.

\newpage

## Glossario dei termini

\begin{table}[h]
    \centering
    \begin{tabular}{|p{0.13\textwidth}|p{0.45\textwidth}|p{0.10\textwidth}|p{0.20\textwidth}|}
        \hline
        \multicolumn{1}{|c|}{\textbf{Termine}} &
  \multicolumn{1}{c|}{\textbf{Descrizione}} &
  \multicolumn{1}{c|}{\textbf{Sinonimi}} &
  \multicolumn{1}{c|}{\textbf{Collegamenti}} \\ \hline
\textit{Sistema di trasporto urbano} &
  Dominio della base di dati &
  Servizio &
   \\ \hline
\textit{Linea di trasporto urbana} &
  Successione di fermate dell'autobus &
  Linea di trasporto, Linea &
  Fermata, Autobus, Corsa \\ \hline
\textit{Fermata} &
  Punto di salita e/o discesa di un determinato luogo &
   &
  Linea di trasporto urbana \\ \hline
\textit{Autobus} &
  Mezzo utilizzato per il trasporto dei clienti &
   &
  Linea di trasporto urbana, Autista, Cliente, Corsa \\ \hline
\textit{Autista} &
  Conducente degli autobus &
  Guidatore &
  Autobus, Corsa \\ \hline
\textit{Corsa} &
  Istanza di una linea, eseguita da un certo autista su un certo autubus in una data ora e giornata &
   &
  Autobus, Autista, Linea di trasporto urbana, Cliente \\ \hline
\textit{Cliente} &
  Usufruitore del sistema di trasporto urbano &
  Utente tesserato, Cliente tesserato &
  Autobus, Corsa, Tessera \\ \hline
\textit{Tessera} &
  Documento associato ad un singolo cliente &
   &
  Cliente, Abbonamento \\ \hline
\textit{Abbonamento} &
  Contratto fra l'azienda offrente il sistema di trasporto urbano e il cliente &
   &
  Tessera \\ \hline
    \end{tabular}
\end{table}

## Strutturazione dei requisiti

Riscriviamo ora quindi i requisiti ristrutturandoli in gruppi di frasi omogenee, relative cioè agli stessi concetti.

| Frasi di ***carattere generale*** |
|:----------------------------------------------------------------------------------------------------------------------:|
| Si vuole realizzare una base di dati per la gestione giornaliera di un sistema di trasporto urbano mediante autobus. |

| Frasi relative alle ***linee di trasporto urbane*** |
|:-----------------------:|
| Il sistema di trasporto urbano sia organizzato in un certo insieme di linee di trasporto urbano. Ogni linea di trasporto urbana sia identificata univocamente da un numero e sia caratterizzata da un certo numero di fermate. Si tenga traccia anche dell’ordine delle fermate di una data linea di trasporto urbana. Ogni linea di trasporto urbana è servita, nello stesso giorno, da uno o più autobus. |

| Frasi relative alle ***fermate*** |
|:-----------------------:|
| Ogni fermata sia identificata univocamente da un nome. Ad ogni fermata sia, inoltre, associato un indirizzo. Una fermata possa essere raggiunta da più linee di trasporto urbane. |

\newpage

| Frasi relative agli ***autobus*** |
|:-----------------------:|
| Ogni autobus è identificato univocamente dal numero di immatricolazione (targa) ed è caratterizzato da un numero di posti (in piedi e a sedere). Un autobus può essere guidato da autisti diversi. |

| Frasi relative agli ***autisti*** |
|:-----------------------:|
| L’autista di un autobus è identificabile univocamente tramite il suo codice fiscale o per mezzo del numero di patente ed è caratterizzato da nome, cognome, data di nascita e luogo di residenza e da zero o più numeri di recapito telefonico. |

| Frasi relative alle ***corse*** |
|:-----------------------:|
| Si vuole tener traccia dell'autobus e del autista che ha eseguito una corsa, corrispondente cioè ad una istanza di linea di trasporto urbana effettuata ad una certa ora e giorno |

| Frasi relative ai ***clienti*** |
|:-----------------------:|
| Il cliente è identificato dal codice fiscale ed è caratterizzato da nome, cognome, data di nascita e luogo di residenza e da un recapito telefonico (in caso di smarrimento dell'abbonamento). Si è interessati alla memorizzazione dei clienti posseditori di tessera. Si vuole, in particolare, tener traccia dei loro spostamenti, cioè si vogliono conoscere le corse di cui ha usufruito, e del numero di corse utilizzate mensilmente. |

| Frasi relative alle ***tessere*** |
|:-----------------------:|
| Ogni tessera è intestata ad uno e un solo cliente. |

| Frasi relative agli ***abbonamenti*** |
|:-----------------------:|
| Un abbonamento è identificato univocamente da un numero di tessera e dalla data di inizio (si suppone che ad una tessera non siano collegati abbonamenti con la stessa data di inizio in quanto un singolo abbonamento permette di usufruire di qualsiasi autobus), è caratterizzato da un tipo di abbonamento (mensile, trimestrale, annuale). Si vuole tener traccia di tutti gli abbonamenti sottoscritti dal cliente tesserato. |

\newpage 

## Operazioni frequenti sui dati

<!-- Uno o due attributi derivati dal conteggio di relazioni con cui una certa entità partecipa (es. numero di fermate di una certa linea!) -->
<!-- Attributi derivati (1-2, max 3), attributi composti, multivalore, generalizzazioni (1-2) -->
<!-- Numero di fermate di una linea di trasporto -->
<!-- Nei casi in cui è possibile, tenere uno storico di informazioni passate -->

<!-- Definire un insieme di operazioni che pensiamo essere più frequenti (7-10 operazioni) indicando le frequenze -->
<!-- Devono esserci, fra queste operazioni, sia letture sia aggiornamento di dati ridondanti (1 che beneficia del dato ridondate (letture) e 1 che NON beneficia del dato ridondante (aggiornamento)) -->
<!-- Inserimento di una nuova linea di trasporto(?) -->


<!-- Lo storico NON c'è in quanto si parla di una base di dati GIORNALIERA -->

1. Inserimento di una nuove linea di trasporto urbano (2 all'anno)
1. Inserimento di una nuova fermata in una linea di trasporto (20 all'anno) <!-- Scrittura su dato ridondante -->
1. Inserimento di una nuova corsa (250 al giorno)
1. Inserimento di una nuova corsa effettuata da un cliente (500000 al giorno) <!-- Scrittura su dato ridondante -->
1. Lettura del numero di medio di corse mensili effettuate <!-- Lettura su dato ridondante -->
1. Inserimento di un nuovo cliente (50 al mese)
1. Inserimento di un nuovo abbonamento (750 al mese)
1. Stampa del numero di fermate per una data linea di trasporto urbana (una alla settimana) <!-- Lettura su dato ridondante -->
1. Stampa del numero abbonamenti attualmente validi (una al giorno)

\newpage

# Progettazione concettuale

## Analisi preliminare

<!-- Commands for colors -->
\definecolor{bettergreen}{rgb}{0.0, 0.5, 0.0}
\newcommand\entita[1]{\textbf{\textcolor{red}{#1}}}
\newcommand\attributo[1]{\textbf{\textcolor{bettergreen}{#1}}}
\newcommand\relazione[1]{\textbf{\textcolor{blue}{#1}}}
\newcommand\relattr[1]{\textbf{\textcolor{cyan}{#1}}}

Iniziamo preliminarmente da un'analisi del testo di specifiche dei requisiti utilizzando la seguente legenda:


\renewcommand{\arraystretch}{1.5}
\begin{table}[h]
    \centering
\begin{tabular}{lllll}
\hline
    \textbf{Legenda} & \entita{Entità} & \attributo{Attributo} & \relazione{Relazioni} & \relattr{Attributi di relazione} \\ \hline
\end{tabular}
\end{table}

Si vuole realizzare una base di dati per la gestione giornaliera di un sistema di trasporto urbano mediante autobus:

- Il sistema di trasporto urbano sia organizzato in un certo insieme di \entita{linee di trasporto urbano}. Ogni linea di trasporto urbana sia identificata univocamente da un \attributo{numero} e sia caratterizzata da un certo \attributo{numero di fermate}. Si tenga traccia anche dell’\relazione{ordine} delle \entita{fermate} di una data linea di trasporto urbana. Ogni linea di trasporto urbana \relazione{è servita}, nello stesso giorno, da uno o più \entita{autobus}.

- Ogni fermata sia identificata univocamente da un \attributo{nome}. Ad ogni fermata sia, inoltre, associato un \attributo{indirizzo}. Una fermata possa essere \relazione{raggiunta} da più linee di trasporto urbane.

- Ogni autobus è identificato univocamente dal \attributo{numero di immatricolazione (targa)} ed è caratterizzato da un \attributo{numero di posti (in piedi e a sedere)}. Un autobus può \relazione{essere guidato da} \entita{autisti} diversi.

- L’autista di un autobus è identificabile univocamente tramite il suo \attributo{codice fiscale} o per mezzo del \attributo{numero di patente} ed è caratterizzato da \attributo{nome}, \attributo{cognome}, \attributo{data di nascita} e \attributo{luogo di residenza} e da zero o più \attributo{numeri di recapito telefonico}.

- Si vuole tener traccia dell’autobus e del autista che \relazione{ha eseguito} una corsa, corrispondente cioè ad una istanza di linea di trasporto urbana effettuata ad una certa \relattr{ora} e \relattr{giorno}.

- Il \entita{cliente} è identificato dal \attributo{codice fiscale} ed è caratterizzato da \attributo{nome}, \attributo{cognome}, \attributo{data di nascita} e \attributo{luogo di residenza} e da un \attributo{recapito telefonico} (in caso di smarrimento dell'abbonamento). Si è interessati alla memorizzazione dei clienti posseditori di \entita{tessera}. Si vuole, in particolare, tener traccia dei loro spostamenti, cioè si vogliono conoscere le corse di cui \relazione{ha usufruito}, e del \attributo{numero di corse utilizzate mensilmente}. 

- Ogni tessera è \relazione{intestata a} uno e un solo cliente.

- Un \entita{abbonamento} è identificato univocamente da un \attributo{numero di tessera} e dalla \attributo{data di inizio} (si suppone che ad una tessera non siano collegati abbonamenti con la stessa data di inizio in quanto un singolo abbonamento permette di usufruire di qualsiasi autobus), è caratterizzato da un \attributo{tipo di abbonamento} (mensile, trimestrale, annuale). Si vuole tener traccia di tutti gli abbonamenti sottoscritti dal cliente tesserato.

\newpage

# Progettazione logica

\newpage

# Progettazione fisica

\newpage

# Implementazione

\newpage

# Analisi dei dati
