-- FUNCTION: plui.prescription_pct_suppr()

-- DROP FUNCTION plui.prescription_pct_suppr();

CREATE FUNCTION plui.prescription_pct_suppr()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET prescription_pct = array_remove(prescription_pct,'||NEW.idkey||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET prescription_pct = array_append(prescription_pct,'||OLD.idkey||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.prescription_pct_suppr()
    OWNER TO postgres;
