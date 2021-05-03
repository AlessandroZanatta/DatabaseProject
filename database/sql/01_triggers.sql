-- Set search path. Need to set it at the very start of every file.
SET search_path TO SistemaTrasportoUrbano;

------------------------------------------------------------------------------------------------------------
-- VINCOLI AZIENDALI
------------------------------------------------------------------------------------------------------------

-- 1) Nella relazione composto, per la stessa istanza di linea di trasporto urbana, 
--    non sono ammessi attributi posizione duplicati.
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - INSERT o UPDATE su Composto

CREATE FUNCTION check_composto_posizione()
RETURNS trigger
LANGUAGE plpgsql AS 
$$
    BEGIN
        PERFORM
        FROM Composto
        WHERE NomeFermata = new.NomeFermata
              AND Posizione = new.Posizione;
            
        IF NOT found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Nella relazione composto, per la stessa istanza di linea di trasporto urbana, non sono ammessi attributi posizione duplicati.';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_composto_posizione_trigger
BEFORE INSERT OR UPDATE ON Composto
FOR EACH ROW
EXECUTE PROCEDURE check_composto_posizione();

-- 2) Ogni tessera deve essere in relazione con almeno una delle due relazioni valido e scaduto. Si
--    assume infatti che ogni cliente abbia almeno un abbonamento, sia questo scaduto o ancora in vigore.
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - UPDATE o DELETE su Valido o Scaduto

CREATE FUNCTION check_valido_scaduto_update()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        IF old.Tessera = new.Tessera THEN
            RETURN new;
        ELSE
            PERFORM
            FROM (SELECT * FROM Valido UNION SELECT * FROM Scaduto) AS t
            WHERE t.Tessera = old.Tessera
                AND t.DataInizio != old.Tessera;
            
            IF found THEN
                RETURN new;
            ELSE
                RAISE EXCEPTION 'Ogni tessera deve essere in relazione con almeno una delle due relazioni valido e scaduto (UPDATE).';
                RETURN NULL;
            END IF;
        END IF;
    END;
$$;

CREATE FUNCTION check_valido_scaduto_delete()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM (SELECT * FROM Valido UNION SELECT * FROM Scaduto) AS t
        WHERE t.Tessera = old.Tessera
              AND t.DataInizio != old.Tessera;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Ogni tessera deve essere in relazione con almeno una delle due relazioni valido e scaduto (UPDATE).';
            RETURN NULL;
        END IF;
    END;
$$;


CREATE TRIGGER check_valido_scaduto_trigger
BEFORE UPDATE ON Valido
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_update();

CREATE TRIGGER check_valido_scaduto_trigger
BEFORE DELETE ON Valido
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_delete();

CREATE TRIGGER check_valido_scaduto_trigger
BEFORE UPDATE ON Scaduto
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_delete();

CREATE TRIGGER check_valido_scaduto_trigger
BEFORE DELETE ON Scaduto
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_delete();

------------------------------------------------------------------------------------------------------------
-- ALTRI VINCOLI
------------------------------------------------------------------------------------------------------------

-- 1) Vincolo di partecipazione obbligatoria fra l’entità fermata e la relazione composto;
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - INSERT su Fermata può invalidare il vincolo
--  - UPDATE o DELETE su Composto possono invalidare il vincolo

-- INSERT su Fermata
CREATE FUNCTION check_fermata_composto()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Composto
        WHERE NomeFermata = new.Nome;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità fermata e la relazione composto violato (INSERT Fermata)';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_fermata_composto_trigger
BEFORE INSERT ON Fermata
FOR EACH ROW
EXECUTE PROCEDURE check_fermata_composto();

-- UPDATE o DELETE su Composto
CREATE FUNCTION check_composto_fermata_update()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        IF old.NomeFermata = new.NomeFermata THEN
            RETURN new;
        ELSE 
            PERFORM
            FROM Composto
            WHERE NomeFermata = old.NomeFermata
                  AND NumeroLinea != old.NumeroLinea;
            
            IF found THEN
                RETURN new;
            ELSE
                RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità fermata e la relazione composto violato (UPDATE Composto)';
                RETURN NULL;
            END IF;
        END IF;
    END;
$$;

-- UPDATE o DELETE su Composto
CREATE FUNCTION check_composto_fermata_delete()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Composto
        WHERE NomeFermata = old.NomeFermata
                AND NumeroLinea != old.NumeroLinea;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità fermata e la relazione composto violato (DELETE Composto)';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_composto_fermata_update_trigger
BEFORE UPDATE ON Composto
FOR EACH ROW
EXECUTE PROCEDURE check_composto_fermata_update();

CREATE TRIGGER check_composto_fermata_delete_trigger
BEFORE DELETE ON Composto
FOR EACH ROW
EXECUTE PROCEDURE check_composto_fermata_delete();

-- 2) Controllo che l'abbonamento che voglio inserire non sia per un cliente che abbia già un abbonamento valido  in corso.
/*
CREATE FUNCTION checking_buspass()
RETURNS trigger
LANGUAGE plpgsql as $$
BEGIN
    SELECT Tessera
    FROM Valido
    WHERE Valido.Tessera=new.Tessera() and new.DataInizio<Valido.DataInizio
        IF NOT FOUND THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION("Il cliente ha già un abbonamento valido in corso, impossibile aggiungerlo uno nuovo");
            RETURN NULL;
        END IF;
END;
$$;


CREATE TRIGGER check_buspass
BEFORE INSERT ON Abbonamento
EXECUTE PROCEDURE checking_buspass();

-- 3) Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione composto;


CREATE FUNCTION checking_linebus()
RETURN trigger
LANGUAGE plpgsql as $$
BEGIN
    SELECT Numero
    from LineaTrasportoUrbano
    where LineaTrasportoUrbano.Numero==new.NumeroLinea
    IF NOT FOUND then 
       RAISE EXCEPTION("Impossibile aggiungere la linea, linea di trasporto inesistente");
       RETURN null;
    ELSE
        RETURN new;
    END IF;
END;
$$;

CREATE TRIGGER check_linebus
BEFORE INSERT OR UPDATE ON Composto
FOR EACH ROW 
EXECUTE PROCEDURE checking_linebus();

-- 3) Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione istanza di; VEDREMO IN FUTURA RESTATE CONNESSI

CREATE TRIGGER


--4) Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione servita da;

CREATE TRIGGER check_linebus
BEFORE INSERT OR UPDATE ON ServitaDa
FOR EACH ROW 
EXECUTE PROCEDURE checking_linebus();

--5) Vincoli di partecipazione obbligatoria fra l’entità tessera e le relazioni scaduto e valido. 
-- TO DOO DA FARE
CREATE FUNCTION checking_validity()
ETURN trigger
LANGUAGE plpgsql as $$
BEGIN
    SELECT NumeroTessera
    from Tessera
    where Tessera.NumeroTessera=new.Tessera
    if NOT FOUND then
        RAISE EXCEPTION("Impossibile aggiungere la tessera, tessera inesistente");


CREATE TRIGGER check_validity
BEFORE INSERT ON UPDATE ON Scaduto
for EACH ROW
EXECUTE PROCEDURE checking_validity();
*/