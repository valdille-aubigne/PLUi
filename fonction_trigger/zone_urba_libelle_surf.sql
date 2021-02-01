-- FUNCTION: plui.zone_urba_libelle_suppr()

-- DROP FUNCTION plui.zone_urba_libelle_suppr();

CREATE FUNCTION plui.zone_urba_libelle_suppr()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET zone_urba_libelle = array_remove(zone_urba_libelle,'||NEW.idkey||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET zone_urba_libelle = array_append(zone_urba_libelle,'||OLD.idkey||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

IF TG_OP = 'UPDATE' AND NEW.idkey_du <> OLD.idkey_du THEN
EXECUTE 
'UPDATE plui.doc_urba
SET zone_urba_libelle = array_remove(zone_urba_libelle,'||NEW.idkey||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
EXECUTE 
'UPDATE plui.doc_urba
SET zone_urba_libelle = array_append(zone_urba_libelle,'||OLD.idkey||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.zone_urba_libelle_suppr()
    OWNER TO postgres;
