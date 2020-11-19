-- FUNCTION: plui.sup_pct()

-- DROP FUNCTION plui.sup_pct();

CREATE FUNCTION plui.sup_pct()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET sup_pct = array_append(sup_pct,'||NEW.idkey||')
WHERE etat = ''02'' OR etat =''01''' 
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET sup_pct = array_remove(sup_pct,'||OLD.idkey||')'
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.sup_pct()
    OWNER TO postgres;
