-- Set search path. Need to set it at the very start of every file.
SET search_path TO SistemaTrasportoUrbano;

-- Cronjob per muovere gli abbonamenti scaduti dalla tabella valido alla tabella scaduto

CREATE FUNCTION abbonamento_scaduto(tessera NumeroTessera, inizio DataInizio)
RETURNS BOOLEAN
LANGUAGE plpgsql AS
$$
    DECLARE
        fine DataFine;
        tipo TipoAbbonamento;
    BEGIN
        SELECT TipoAbbonamento into tipo
        FROM Abbonamento a
        WHERE a.Tessera = tessera AND a.DataInizio = inizio;

        CASE tipo
            WHEN 'mensile'::TipoAbbonamento THEN fine = inizio + make_interval(days => 28);
            WHEN 'trimestrale'::TipoAbbonamento THEN fine = inizio + make_interval(days => 28*3); 
            WHEN 'annuale'::TipoAbbonamento THEN fine = inizio + make_interval(days => 365);
            ELSE RAISE EXCEPTION 'Tipo di abbonamento inesistente';
        END CASE;

        RETURN fine > CURRENT_DATE;
    END;
$$;

CREATE FUNCTION move_expired_pass_to_expired()
RETURNS VOID
LANGUAGE SQL AS
$$
    START TRANSACTION;

    WITH expired AS (
        DELETE FROM Valido v
        WHERE abbonamento_scaduto(v.Tessera, v.DataInizio) = TRUE
        RETURNING v.*
    )
    INSERT INTO Scaduto
    SELECT * FROM expired;

    COMMIT;
$$;

SELECT cron.schedule('0 0 * * *', $$move_expired_pass_to_scaduto()$$);