---
title: Relazione Basi di Dati 2020-2021
author: Alessandro Zanatta, Christian Abbondo, Samuele Anzolin e Fabiana Rapicavoli
date:
  - 10-09-2020
header-includes:
  - \usepackage{amsmath}
  - \usepackage[italian]{babel}
  - \usepackage{float}
geometry: "left=3cm,right=3cm,top=2cm,bottom=2cm"
---

\newcommand{\floor}[1]{\lfloor #1 \rfloor}

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
| Si vuole tener traccia dell'autobus e dell'autista che ha eseguito una corsa, corrispondente cioè ad una istanza di linea di trasporto urbana effettuata ad una certa ora e giorno |

| Frasi relative ai ***clienti*** |
|:-----------------------:|
| Il cliente è identificato dal codice fiscale ed è caratterizzato da nome, cognome, data di nascita e luogo di residenza e da un recapito telefonico (in caso di smarrimento dell'abbonamento). Si è interessati alla memorizzazione dei clienti possessori di tessera. Si vuole, in particolare, tener traccia dei loro spostamenti, cioè si vogliono conoscere le corse di cui ha usufruito, e del numero di corse utilizzate mensilmente. |

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

1. Inserimento di una nuova fermata in una linea di trasporto (15 all'anno) <!-- Scrittura su dato ridondante -->
1. Inserimento di una nuova corsa (450 al giorno)
1. Inserimento di una nuova corsa effettuata da un cliente (12500 al giorno) <!-- Scrittura su dato ridondante -->
1. Lettura del numero medio di corse mensili effettuate (1 al mese) <!-- Lettura su dato ridondante -->
1. Inserimento di un nuovo cliente (50 al mese)
1. Inserimento di un nuovo abbonamento (2500 al mese)
1. Stampa del numero di fermate per una data linea di trasporto urbana (una alla settimana) <!-- Lettura su dato ridondante -->
1. Stampa del numero di abbonamenti attualmente validi (una al giorno)

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

- Ogni fermata sia identificata univocamente da un \attributo{nome}. Ad ogni fermata sia, inoltre, associato un \attributo{indirizzo}. Una fermata possa essere raggiunta da più linee di trasporto urbane.

- Ogni autobus è identificato univocamente dal \attributo{numero di immatricolazione (targa)} ed è caratterizzato da un \attributo{numero di posti (in piedi e a sedere)}. Un autobus può \relazione{essere guidato da} \entita{autisti} diversi.

- L’autista di un autobus è identificabile univocamente tramite il suo \attributo{codice fiscale} o per mezzo del \attributo{numero di patente} ed è caratterizzato da \attributo{nome}, \attributo{cognome}, \attributo{data di nascita} e \attributo{luogo di residenza} e da zero o più \attributo{numeri di recapito telefonico}.

- Si vuole tener traccia dell’autobus e dell'autista che \relazione{ha eseguito} una corsa, corrispondente cioè ad una istanza di linea di trasporto urbana effettuata ad una certa \relattr{ora} e \relattr{giorno}.

- Il \entita{cliente} è identificato dal \attributo{codice fiscale} ed è caratterizzato da \attributo{nome}, \attributo{cognome}, \attributo{data di nascita} e \attributo{luogo di residenza} e da un \attributo{recapito telefonico} (in caso di smarrimento dell'abbonamento). Si è interessati alla memorizzazione dei clienti possessori di \entita{tessera}. Si vuole, in particolare, tener traccia dei loro spostamenti, cioè si vogliono conoscere le corse di cui \relazione{ha usufruito}, e del \attributo{numero di corse utilizzate mensilmente}. 

- Ogni tessera è \relazione{intestata a} uno e un solo cliente.

- Un \entita{abbonamento} è identificato univocamente da un \attributo{numero di tessera} e dalla \attributo{data di inizio} (si suppone che ad una tessera non siano collegati abbonamenti con la stessa data di inizio in quanto un singolo abbonamento permette di usufruire di qualsiasi autobus), è caratterizzato da un \attributo{tipo di abbonamento} (mensile, trimestrale, annuale). Si vuole tener traccia di tutti gli abbonamenti sottoscritti dal cliente tesserato.

\newpage

## Schema Entità-Relazioni

La strategia di progetto utilizzata è la strategia mista.

Si riporta di seguito il diagramma Entità-Relazioni risultante dallo sviluppo delle specifiche:

![](images/first_ER.pdf)

\newpage

### Vincoli aggiuntivi

Si evidenzia il seguente ***vincolo aziendale***:

- Nella relazione `composto`, per la stessa istanza di `linea di trasporto urbana`, non sono ammessi attributi `posizione` duplicati. Si noti che l'attributo `posizione` è inserito nello schema al fine di tener conto dell'ordine delle `fermate` della singola `linea di trasporto urbana`.

Si indicano inoltre le seguenti ***regole di derivazione***:

- L'attributo `numero di fermate` dell'entità `linea di trasporto urbana` è derivabile contando il numero di istanze di `fermata` in relazione con una data istanza di `linea di trasporto urbana`. 
- L'attributo `numero di corse mensili` dell'entità `cliente` è derivabile contando il numero di istanze di `corsa` in un dato mese in relazione con una data istanza di `cliente`

### Considerazioni

Nello schema sono presenti dei cicli. Dato che i cicli potrebbero essere, potenzialmente, fonti di incoerenze, segue una loro analisi:

1. Linea di trasporto - autobus - corsa
    - Questo ciclo è problematico. Un `autobus` non può, infatti, essere utilizzato per eseguire una `corsa` che è istanza di una `linea di trasporto urbana` diversa da quella servita dall'`autobus` stesso. 
1. Tessera - abbonamento
    - Anche questo ciclo è problematico. Risulta infatti insensato che un `abbonamento` possa essere in relazione con una `tessera` sia in qualità di `abbonamento` valido che in qualità di `abbonamento` scaduto.


Si riportano alcune decisioni progettuali attinenti alle cardinalità delle relazioni:

- Il vincolo di partecipazione opzionale è stato utilizzato, nella relazione ternaria `ha eseguito`, sia per autobus che per autista in quanto:
    - Un autobus potrebbe, se esso è nuovo o di riserva, non aver effettuato alcuna corsa
    - Un autista potrebbe, nel caso in cui questo fosse neo-assunto, non aver eseguito alcuna corsa
- Per considerazioni analoghe a quelle precedenti, la partecipazione di `autobus` alla relazione `servita da` è opzionale. Un autobus potrebbe, infatti, non servire alcuna `linea di trasporto urbano`.
- La partecipazione nella relazione `ha usufruito` è, da ambo i lati, opzionale in quanto:
    - Una `corsa` potrebbe non avere alcun `cliente` tra i passeggeri del mezzo
    - Un `cliente` potrebbe, se appena tesserato, non aver usufruito di alcuna `corsa`

\newpage

# Progettazione logica

## Ristrutturazione dello schema Entità Relazioni

### Analisi delle ridondanze

Si definiscono, innanzitutto, i volumi dei dati e si riportano le frequenze delle operazioni:

\begin{table}[h]
\centering
\begin{tabular}{|c|c|c|}
\hline
\textbf{Concetto}         & \textbf{Tipo} & \textbf{Volume} \\ \hline
Fermata                   & Entità        & 225             \\ \hline
Linea di trasporto urbana & Entità        & 15              \\ \hline
Autobus                   & Entità        & 100             \\ \hline
Corsa                     & Entità        & 450 al giorno   \\ \hline
Autista                   & Entità        & 75              \\ \hline
Cliente                   & Entità        & 7500            \\ \hline
Tessera                   & Entità        & 7500            \\ \hline
Abbonamento               & Entità        & 100000          \\ \hline
Composto                  & Relazione     & 300             \\ \hline
Istanza di                & Relazione     & 450 al giorno   \\ \hline
Ha eseguito               & Relazione     & 450 al giorno   \\ \hline
Ha usufruito              & Relazione     & 12000           \\ \hline
Intestata                 & Relazione     & 7500            \\ \hline
Scaduto                   & Relazione     & 92500           \\ \hline
Valido                    & Relazione     & 7500            \\ \hline
\end{tabular}
\end{table}

\begin{table}[h]
\centering
\begin{tabular}{|l|l|}
\hline
\multicolumn{1}{|c|}{\textbf{Operazione}}                           & \multicolumn{1}{c|}{\textbf{Frequenza}} \\ \hline
Inserimento di una nuova fermata in una linea di trasporto & 15 all'anno     \\ \hline
Inserimento di una nuova corsa                             & 450 al giorno   \\ \hline
Inserimento di una nuova corsa effettuata da un cliente    & 12500 al giorno \\ \hline
Lettura del numero medio di corse mensili effettuate       & 1 al mese       \\ \hline
Inserimento di un nuovo cliente                            & 50 al mese      \\ \hline
Inserimento di un nuovo abbonamento                        & 2500 al mese    \\ \hline
Stampa del numero di fermate per una data linea di trasporto urbana & 1 alla settimana                        \\ \hline
Stampa del numero di abbonamenti attualmente validi        & 1 al giorno     \\ \hline
\end{tabular}
\end{table}

In base alle tabelle sopra definite, si è proseguito a creare le tavole degli accessi relative alle operazioni che presentano ridondanze.

\newpage

#### Numero di fermate {-}

Segue l'analisi di vantaggi e svantaggi dell'attributo derivato `numero di fermate`, il quale riguarda le seguenti interrogazioni:

1. Inserimento di una nuova fermata in una linea di trasporto

\begin{table}[H]
\centering
\begin{tabular}{|c|c|c|c|}
\hline
    \textbf{Concetto} & \textbf{Costrutto} & \textbf{Accessi} & \textbf{Tipo} \\

    \hline Fermata & Entità & 1 & Scrittura \\
    \hline Composto & Relazione & 1 & Scrittura \\
    \hline Linea di trasporto urbano & Entità & 1 & Lettura \\
    \hline Linea di trasporto urbano & Entità & 1 & Scrittura \\
    \hline
\end{tabular}
\caption{Tabella degli accessi in presenza di ridondanza}
\end{table}

\begin{table}[H]
\centering
\begin{tabular}{|c|c|c|c|}
\hline
    \textbf{Concetto} & \textbf{Costrutto} & \textbf{Accessi} & \textbf{Tipo} \\

    \hline Fermata & Entità & 1 & Scrittura \\
    \hline Composto & Relazione & 1 & Scrittura \\
    \hline
\end{tabular}
\caption{Tabella degli accessi senza ridondanze}
\end{table}

2. Stampa del numero di fermate per una data linea di trasporto urbana

\begin{table}[H]
\centering
\begin{tabular}{|c|c|c|c|}
\hline
    \textbf{Concetto} & \textbf{Costrutto} & \textbf{Accessi} & \textbf{Tipo} \\
    \hline Linea di trasporto urbano & Entità & 1 & Lettura \\
    \hline
\end{tabular}
\caption{Tabella degli accessi in presenza di ridondanza}
\end{table}

\begin{table}[H]
\centering
\begin{tabular}{|c|c|c|c|}
\hline
    \textbf{Concetto} & \textbf{Costrutto} & \textbf{Accessi} & \textbf{Tipo} \\
    \hline Linea di trasporto urbano & Entità & 1 & Lettura \\
    \hline Composto & Relazione & 20 & Lettura \\
    \hline
\end{tabular}
\caption{Tabella degli accessi senza ridondanze}
\end{table}


Gli accessi, in lettura e scrittura, all'entità `linea di trasporto urbano`, richiesto in caso di ridondanza, è necessario per garantire che l'attributo derivato e ridondante `numero di fermate` sia aggiornato correttamente.

I seguenti calcoli sono effettuati dando un peso doppio agli accessi in scrittura dato che questi risultano essere più dispendiosi.

Il numero di accessi totale per la prima operazione è di $\left(2 + 2 + 1 + 2\right) \cdot 15 = 105$ accessi all'anno in caso di ridondanza.
Il numero di accessi annui, in caso di assenza di dato ridondante, è di $\left(2 + 2\right) \cdot 15 = 60$.

Il numero di accessi totale per la seconda operazione è di $1 \cdot \floor{\frac{365}{7}} = 52$ accessi all'anno in caso di ridondanza.
In caso di assenza, il numero degli accessi sale a $21 \cdot \floor{\frac{365}{7}} = 1092$ all'anno.

Si può quindi notare che, dato il maggior numero di accessi necessari in caso di mancanza della ridondanza (1152 contro 157), sia conveniente mantenere l'attributo derivato `numero di fermate`, a costo di un piccolo utilizzo aggiuntivo di memoria.

#### Numero di corse mensili {-}

Segue, infine, l'analisi di vantaggi e svantaggi dell'attributo derivato `numero di corse mensili`, il quale riguarda le seguenti interrogazioni:

1. Inserimento di una nuova corsa effettuata da un cliente


\begin{table}[H]
\centering
\begin{tabular}{|c|c|c|c|}
\hline
    \textbf{Concetto} & \textbf{Costrutto} & \textbf{Accessi} & \textbf{Tipo} \\
    \hline Ha usufruito & Relazione & 1 & Scrittura \\
    \hline Cliente & Entità & 1 & Lettura \\
    \hline Cliente & Entità & 1 & Scrittura \\
    \hline
\end{tabular}
\caption{Tabella degli accessi in presenza di ridondanza}
\end{table}


\begin{table}[H]
\centering
\begin{tabular}{|c|c|c|c|}
\hline
    \textbf{Concetto} & \textbf{Costrutto} & \textbf{Accessi} & \textbf{Tipo} \\
    \hline Ha usufruito & Relazione & 1 & Scrittura \\
    \hline
\end{tabular}
\caption{Tabella degli accessi senza ridondanze}
\end{table}


2. Lettura del numero medio di corse mensili effettuate[^1]

[^1]: La tabella si riferisce agli accessi necessari per ogni cliente. I calcoli relativi alla totalità sono effettuati in seguito.

\begin{table}[H]
\centering
\begin{tabular}{|c|c|c|c|}
\hline
    \textbf{Concetto} & \textbf{Costrutto} & \textbf{Accessi} & \textbf{Tipo} \\
    \hline Cliente & Entità & 1 & Lettura \\
    \hline
\end{tabular}
\caption{Tabella degli accessi in presenza di ridondanza}
\end{table}


\begin{table}[H]
\centering
\begin{tabular}{|c|c|c|c|}
\hline
    \textbf{Concetto} & \textbf{Costrutto} & \textbf{Accessi} & \textbf{Tipo} \\
    \hline Cliente & Entità & 1 & Lettura \\
    \hline Composto & Relazione & 45 & Lettura \\ 
    \hline Corsa & Entità & 45 & Lettura \\
    \hline
\end{tabular}
\caption{Tabella degli accessi senza ridondanze}
\end{table}

<!-- 45 = 4/5*2 * 28 (4/5*2 = 4/5 degli abbonati fanno due corse al giorno, *28 durata mensilità) -->

L'accesso, in lettura e scrittura, all'entità `cliente`, richiesto in caso di ridondanza, è necessario per garantire che l'attributo derivato e ridondante `numero di corse mensili` sia aggiornato correttamente.

Si ricorda che i seguenti calcoli sono effettuati dando un peso doppio agli accessi in scrittura.

Il numero di accessi totale per la prima operazione è di $\left(2 + 1 + 2\right) \cdot (12000 \cdot 28) = 1680000$ accessi al mese in caso di ridondanza, dove $28$ è la durata di una mensilità.
Il numero di accessi mensili, in caso di assenza di dato ridondante, è di $2 \cdot (12000 \cdot 28) = 672000$.

Il numero di accessi totale per la seconda operazione è di $1 \cdot 7500 = 7500$ accessi al mese in caso di ridondanza, dove $7500$ è il numero di istanze attese dell'entità `cliente`.
In caso di assenza, il numero degli accessi è invece di $(1 + 45 + 45) \cdot 7500 = 682500$ al mese.

Ricapitolando, si hanno:

 - 1687500 accessi in caso di ridondanza
 - 1354500 accessi in assenza di ridondanza

Risulta quindi conveniente **non** mantenere l'attributo `numero di corse mensili`.

Da fare: 

- Eliminazione delle generalizzazioni
- Partizionamento/accorpamento di entità e associazioni
- Scelta degli identificatori principali


## Ristrutturazione dello schema Entità Relazioni

### Analisi delle ridondanze

\newpage

# Progettazione fisica

\newpage

# Implementazione

\newpage

# Analisi dei dati
