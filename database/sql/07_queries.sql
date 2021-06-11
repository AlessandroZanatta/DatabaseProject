-- Set search path. Need to set it at the very start of every file.
SET search_path TO SistemaTrasportoUrbano;

-- Lettura del numero di corse mensili effettuate (1 al mese)
SELECT COUNT(*)
FROM Corsa INNER JOIN HaEseguito 
     ON EseguitoId = Id 
WHERE date_trunc('month', DataOra)
        = date_trunc('month', NOW());

-- Stampa del numero di fermate per una data linea di trasporto urbana (una alla settimana)
-- Using redundant attribute
SELECT *
FROM LineaTrasportoUrbano;

-- Without using redundant attribute
SELECT NumeroLinea, COUNT(NomeFermata)
FROM Composto
GROUP BY NumeroLinea;


-- Stampa del numero di abbonamenti attualmente validi (una al giorno)
SELECT COUNT(*)
FROM Valido;

-- Senza utilizzare la divisione in valido/scaduto
SELECT COUNT(*)
FROM Abbonamento NATURAL JOIN Valido;
