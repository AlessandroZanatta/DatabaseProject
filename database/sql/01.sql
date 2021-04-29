-- Adding trigger

-- 1) Vincolo di partecipazione obbligatoria fra l’entità fermata e la relazione composto;

CREATE FUNCTION check_busstop()
RETURN trigger
LANGUAGE plpgsql as $$
BEGIN
    SELECT Nome
    from Fermata
    where Fermata.nome==new.NomeFermata
    IF NOT FOUND then 
       RAISE EXCEPTION("Impossibile aggiungere la fermata, fermata inesistente");
       RETURN null;
    ELSE
        RETURN new;
    END IF;
END;
$$;

CREATE TRIGGER check_busstop
BEFORE INSERT OR UPDATE ON Composto
FOR EACH ROW 
EXECUTE PROCEDURE checking_busstop();





-- 2) Controllo che l'abbonamento che voglio inserire non sia per un cliente che abbia già un abbonamento valido  in corso.


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
            RETURN  NULL;
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

