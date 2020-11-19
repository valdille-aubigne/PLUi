-- FUNCTION: plui.zone_urba_libelle()

-- DROP FUNCTION plui.zone_urba_libelle();

CREATE FUNCTION plui.zone_urba_libelle()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET zone_urba_libelle = array_append(zone_urba_libelle,'||NEW.idkey||')
WHERE etat = ''02'' OR etat =''01''' 
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET zone_urba_libelle = array_remove(zone_urba_libelle,'||OLD.idkey||')'
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.zone_urba_libelle()
    OWNER TO postgres;
