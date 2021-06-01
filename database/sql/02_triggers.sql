-- Set search path. Need to set it at the very start of every file.
SET search_path TO SistemaTrasportoUrbano;

--------------------------------------------------------------------------------------------------------------
-- VINCOLI AZIENDALI
--------------------------------------------------------------------------------------------------------------

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
        WHERE NumeroLinea = new.NumeroLinea
              AND Posizione = new.Posizione;
            
        IF found THEN
            RAISE EXCEPTION 'Nella relazione composto, per la stessa istanza di linea di trasporto urbana, non sono ammessi attributi posizione duplicati.';
            RETURN NULL;
        ELSE
            RETURN new;
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


CREATE TRIGGER check_valido_scaduto_trigger_update
BEFORE UPDATE ON Valido
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_update();

CREATE TRIGGER check_valido_scaduto_trigger_delete
BEFORE DELETE ON Valido
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_delete();

CREATE TRIGGER check_valido_scaduto_trigger_update
BEFORE UPDATE ON Scaduto
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_delete();

CREATE TRIGGER check_valido_scaduto_trigger_delete
BEFORE DELETE ON Scaduto
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_delete();

--------------------------------------------------------------------------------------------------------------
-- VINCOLI RISPETTIVI AI CICLI
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
-- 1) Tessera - abbonamento;
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - INSERT o UPDATE su Valido o Scaduto
--------------------------------------------------------------------------------------------------------------

CREATE FUNCTION check_valido_scaduto_ciclo()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Scaduto
        WHERE Tessera = new.Tessera
              AND DataInizio = new.DataInizio;

        IF found THEN
            RAISE EXCEPTION 'Tessera - abbonamento ciclo (valido)!';
            RETURN NULL;
        ELSE
            RETURN new;
        END IF;
    END;
$$;

CREATE TRIGGER check_valido_scaduto_ciclo_trigger
BEFORE INSERT OR UPDATE ON Valido
FOR EACH ROW
EXECUTE PROCEDURE check_valido_scaduto_ciclo();

CREATE FUNCTION check_scaduto_valido_ciclo()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Valido
        WHERE Tessera = new.Tessera
              AND DataInizio = new.DataInizio;

        IF found THEN
            RAISE EXCEPTION 'Tessera - abbonamento ciclo (scaduto)!';
            RETURN NULL;
        ELSE
            RETURN new;
        END IF;
    END;
$$;

CREATE TRIGGER check_scaduto_valido_ciclo_trigger
BEFORE INSERT OR UPDATE ON Scaduto
FOR EACH ROW
EXECUTE PROCEDURE check_scaduto_valido_ciclo();

--------------------------------------------------------------------------------------------------------------
-- ALTRI VINCOLI
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
-- 1) Vincolo di partecipazione obbligatoria fra l’entità fermata e la relazione composto;
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - INSERT su Fermata può invalidare il vincolo
--  - UPDATE o DELETE su Composto possono invalidare il vincolo
--------------------------------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------------------------------
-- 2) Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione composto;
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - INSERT su LineaTrasportoUrbano può invalidare il vincolo
--  - UPDATE o DELETE su Composto possono invalidare il vincolo
--------------------------------------------------------------------------------------------------------------

-- INSERT su LineaTrasportoUrbano
CREATE FUNCTION check_lineatrasporto_composto()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Composto
        WHERE NumeroLinea = new.Numero;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione composto (INSERT LineaTrasportoUrbano)';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_lineatrasporto_composto_trigger
BEFORE INSERT ON LineaTrasportoUrbano
FOR EACH ROW
EXECUTE PROCEDURE check_lineatrasporto_composto();

-- UPDATE o DELETE su Composto
CREATE FUNCTION check_composto_lineatrasporto_update()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        IF old.NumeroLinea = new.NumeroLinea THEN
            RETURN new;
        ELSE 
            PERFORM
            FROM Composto
            WHERE NumeroLinea = old.NumeroLinea
                  AND NomeFermata != old.NomeFermata;
            
            IF found THEN
                RETURN new;
            ELSE
                RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione composto (UPDATE Composto)';
                RETURN NULL;
            END IF;
        END IF;
    END;
$$;

-- UPDATE o DELETE su Composto
CREATE FUNCTION check_composto_lineatrasporto_delete()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Composto
        WHERE NumeroLinea = old.NumeroLinea
                AND NomeFermata != old.NomeFermata;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione composto (DELETE Composto)';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_composto_lineatrasporto_update_trigger
BEFORE UPDATE ON Composto
FOR EACH ROW
EXECUTE PROCEDURE check_composto_lineatrasporto_update();

CREATE TRIGGER check_composto_lineatrasporto_delete_trigger
BEFORE DELETE ON Composto
FOR EACH ROW
EXECUTE PROCEDURE check_composto_lineatrasporto_delete();

--------------------------------------------------------------------------------------------------------------
-- 3) Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione istanza di;
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - INSERT su LineaTrasportoUrbano può invalidare il vincolo
--  - UPDATE o DELETE su Corsa possono invalidare il vincolo
--------------------------------------------------------------------------------------------------------------

-- INSERT su LineaTrasportoUrbano
CREATE FUNCTION check_lineatrasporto_corsa()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Corsa
        WHERE NumeroLinea = new.Numero;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione istanza di (INSERT LineaTrasportoUrbano)';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_lineatrasporto_corsa_trigger
BEFORE INSERT ON LineaTrasportoUrbano
FOR EACH ROW
EXECUTE PROCEDURE check_lineatrasporto_corsa();

-- UPDATE o DELETE su Corsa
CREATE FUNCTION check_corsa_lineatrasporto_update()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        IF old.NumeroLinea = new.NumeroLinea THEN
            RETURN new;
        ELSE 
            PERFORM
            FROM Corsa
            WHERE NumeroLinea = old.NumeroLinea
                  AND EseguitoId != old.EseguitoId;
            
            IF found THEN
                RETURN new;
            ELSE
                RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione istanza di (UPDATE Corsa)';
                RETURN NULL;
            END IF;
        END IF;
    END;
$$;

-- UPDATE o DELETE su Composto
CREATE FUNCTION check_corsa_lineatrasporto_delete()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Corsa
        WHERE NumeroLinea = old.NumeroLinea
                AND EseguitoId != old.EseguitoId;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione istanza di (DELETE Corsa)';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_corsa_lineatrasporto_update_trigger
BEFORE UPDATE ON Corsa
FOR EACH ROW
EXECUTE PROCEDURE check_corsa_lineatrasporto_update();

CREATE TRIGGER check_corsa_lineatrasporto_delete_trigger
BEFORE DELETE ON Corsa
FOR EACH ROW
EXECUTE PROCEDURE check_corsa_lineatrasporto_delete();

--------------------------------------------------------------------------------------------------------------
-- 4) Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione servita da;
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - INSERT su LineaTrasportoUrbano può invalidare il vincolo
--  - UPDATE o DELETE su ServitaDa possono invalidare il vincolo
--------------------------------------------------------------------------------------------------------------

-- INSERT su LineaTrasportoUrbano
CREATE FUNCTION check_lineatrasporto_servitada()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM ServitaDa
        WHERE NumeroLinea = new.Numero;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione servita da (INSERT LineaTrasportoUrbano)';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_lineatrasporto_servitada_trigger
BEFORE INSERT ON LineaTrasportoUrbano
FOR EACH ROW
EXECUTE PROCEDURE check_lineatrasporto_servitada();

-- UPDATE o DELETE su Corsa
CREATE FUNCTION check_servitada_lineatrasporto_update()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        IF old.NumeroLinea = new.NumeroLinea THEN
            RETURN new;
        ELSE 
            PERFORM
            FROM Corsa
            WHERE NumeroLinea = old.NumeroLinea
                  AND Targa != old.Targa;
            
            IF found THEN
                RETURN new;
            ELSE
                RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione servita da (UPDATE ServitaDa)';
                RETURN NULL;
            END IF;
        END IF;
    END;
$$;

-- UPDATE o DELETE su Composto
CREATE FUNCTION check_servitada_lineatrasporto_delete()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM Corsa
        WHERE NumeroLinea = old.NumeroLinea
                AND Targa != old.Targa;
        
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Vincolo di partecipazione obbligatoria fra l’entità linea di trasporto urbano e la relazione servita da (UPDATE ServitaDa)';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_servitada_lineatrasporto_update_trigger
BEFORE UPDATE ON ServitaDa
FOR EACH ROW
EXECUTE PROCEDURE check_servitada_lineatrasporto_update();

CREATE TRIGGER check_servitada_lineatrasporto_delete_trigger
BEFORE DELETE ON ServitaDa
FOR EACH ROW
EXECUTE PROCEDURE check_servitada_lineatrasporto_delete();

