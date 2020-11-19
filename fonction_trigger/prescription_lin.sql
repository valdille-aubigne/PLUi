-- FUNCTION: plui.prescription_lin()

-- DROP FUNCTION plui.prescription_lin();

CREATE FUNCTION plui.prescription_lin()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET prescription_lin = array_append(prescription_lin,'||NEW.idkey||')
WHERE etat = ''02'' OR etat =''01''' 
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET prescription_lin = array_remove(prescription_lin,'||OLD.idkey||')'
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.prescription_lin()
    OWNER TO postgres;
