-- FUNCTION: plui.sup_surf()

-- DROP FUNCTION plui.sup_surf();

CREATE FUNCTION plui.sup_surf()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET sup_surf = array_append(sup_surf,'||NEW.idkey||')
WHERE etat = ''02'' OR etat =''01''' 
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET sup_surf = array_remove(sup_surf,'||OLD.idkey||')'
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.sup_surf()
    OWNER TO postgres;
