-- FUNCTION: plui.info_pct_suppr()

-- DROP FUNCTION plui.info_pct_suppr();

CREATE FUNCTION plui.info_pct_suppr()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET info_pct = array_remove(info_pct,'||NEW.idkey||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET info_pct = array_append(info_pct,'||OLD.idkey||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

IF TG_OP = 'UPDATE' AND NEW.idkey_du <> OLD.idkey_du THEN
EXECUTE 
'UPDATE plui.doc_urba
SET info_pct = array_remove(info_pct,'||NEW.idkey||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
EXECUTE 
'UPDATE plui.doc_urba
SET info_pct = array_append(info_pct,'||OLD.idkey||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.info_pct_suppr()
    OWNER TO postgres;
