-- FUNCTION: plui.prescription_lin_ajout()

-- DROP FUNCTION plui.prescription_lin_ajout();

CREATE FUNCTION plui.prescription_lin_ajout()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET prescription_lin = array_append(prescription_lin,'||NEW.idkey_ajout||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET prescription_lin = array_remove(prescription_lin,'||OLD.idkey_ajout||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

IF TG_OP = 'UPDATE' AND NEW.idkey_du <> OLD.idkey_du THEN
EXECUTE 
'UPDATE plui.doc_urba
SET prescription_lin = array_append(prescription_lin,'||NEW.idkey_ajout||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
EXECUTE 
'UPDATE plui.doc_urba
SET prescription_lin = array_remove(prescription_lin,'||OLD.idkey_ajout||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.prescription_lin_ajout()
    OWNER TO postgres;
