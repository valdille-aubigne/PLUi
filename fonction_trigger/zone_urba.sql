-- FUNCTION: plui.zone_urba()

-- DROP FUNCTION plui.zone_urba();

CREATE FUNCTION plui.zone_urba()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET zone_urba = array_append(zone_urba,'||NEW.idkey||')
WHERE etat = ''02'' OR etat =''01''' 
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET zone_urba = array_remove(zone_urba,'||OLD.idkey||')'
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.zone_urba()
    OWNER TO postgres;
