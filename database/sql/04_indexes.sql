-- Set search path. Need to set it at the very start of every file.
SET search_path TO SistemaTrasportoUrbano;

-- Avendo utilizzato un ID per riferire la tabella HaEseguito, l'indice su DataOra
-- viene creato sulla tabella HaEseguito stessa, invece che su Corsa.
CREATE INDEX ON HaEseguito( DataOra );