-- FUNCTION: plui.info_pct_ajout()

-- DROP FUNCTION plui.info_pct_ajout();

CREATE FUNCTION plui.info_pct_ajout()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET info_pct = array_append(info_pct,'||NEW.idkey_ajout||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET info_pct = array_remove(info_pct,'||OLD.idkey_ajout||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.info_pct_ajout()
    OWNER TO postgres;
