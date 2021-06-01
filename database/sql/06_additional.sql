-- Set search path. Need to set it at the very start of every file.
SET search_path TO SistemaTrasportoUrbano;

--------------------------------------------------------------------------------------------------------------
-- 1) Linea di trasporto - autobus - corsa;
-- Il vincolo può essere violato dalle seguenti operazioni:
--  - INSERT o UPDATE su Corsa può invalidare il vincolo
--  - DELETE da ServitaDa
--------------------------------------------------------------------------------------------------------------

CREATE FUNCTION check_linea_autobus_corsa_ciclo_insert_update()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM 
        FROM (HaEseguito INNER JOIN Autobus
             ON Autobus = Targa) NATURAL JOIN ServitaDa
        WHERE Id = new.EseguitoId
            AND NumeroLinea = new.NumeroLinea;
            
        IF found THEN
            RETURN new;
        ELSE
            RAISE EXCEPTION 'Linea di trasporto - autobus - corsa (INSERT/UPDATE)!';
            RETURN NULL;
        END IF;
    END;
$$;

CREATE TRIGGER check_linea_autobus_corsa_insert_update_trigger
BEFORE INSERT OR UPDATE ON Corsa
FOR EACH ROW
EXECUTE PROCEDURE check_linea_autobus_corsa_ciclo_insert_update();

CREATE FUNCTION check_linea_autobus_corsa_ciclo_delete()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        PERFORM
        FROM (HaEseguito INNER JOIN Autobus ON Targa = Autobus)
             INNER JOIN Corsa ON Id = HaEseguitoId
        WHERE Autobus = old.Targa
              AND NumeroLinea = old.NumeroLinea;

        IF found THEN
            RAISE EXCEPTION 'Linea di trasporto - autobus - corsa (DELETE)!';
            RETURN NULL;
        ELSE
            RETURN new;
        END IF;
    END;
$$;

CREATE TRIGGER check_linea_autobus_corsa_ciclo_delete_trigger
BEFORE DELETE ON ServitaDa
FOR EACH ROW
EXECUTE PROCEDURE check_linea_autobus_corsa_ciclo_delete();


--------------------------------------------------------------------------------------------------------------
-- Auto-increment (decrement) number of stops when one is added (deleted) to Composto
--------------------------------------------------------------------------------------------------------------

CREATE FUNCTION increment_NumeroFermate()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        UPDATE LineaTrasportoUrbano
        SET NumeroFermate = (SELECT NumeroFermate 
                             FROM LineaTrasportoUrbano 
                             WHERE NumeroLinea = new.NumeroLinea) + 1
        WHERE NumeroLinea = new.NumeroLinea;
        RETURN new;
    END;
$$;

CREATE TRIGGER decrement_NumeroFermate_trigger
AFTER INSERT ON Composto
FOR EACH ROW
EXECUTE PROCEDURE increment_NumeroFermate();

CREATE FUNCTION increment_NumeroFermate()
RETURNS trigger
LANGUAGE plpgsql AS
$$
    BEGIN
        UPDATE LineaTrasportoUrbano
        SET NumeroFermate = (SELECT NumeroFermate 
                             FROM LineaTrasportoUrbano 
                             WHERE NumeroLinea = old.NumeroLinea) - 1
        WHERE NumeroLinea = old.NumeroLinea;
        RETURN new;
    END;
$$;

CREATE TRIGGER decrement_NumeroFermate_trigger
AFTER DELETE ON Composto
FOR EACH ROW
EXECUTE PROCEDURE decrement_NumeroFermate_trigger();