-- FUNCTION: plui.sup_surf_ajout()

-- DROP FUNCTION plui.sup_surf_ajout();

CREATE FUNCTION plui.sup_surf_ajout()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET sup_surf = array_append(sup_surf,'||NEW.idkey_ajout||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 
'UPDATE plui.doc_urba
SET sup_surf = array_remove(sup_surf,'||OLD.idkey_ajout||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

IF TG_OP = 'UPDATE' AND NEW.idkey_du <> OLD.idkey_du THEN
EXECUTE 
'UPDATE plui.doc_urba
SET sup_surf = array_append(sup_surf,'||NEW.idkey_ajout||')
WHERE idkey = '||NEW.idkey_du
USING NEW ;
EXECUTE 
'UPDATE plui.doc_urba
SET sup_surf = array_remove(sup_surf,'||OLD.idkey_ajout||')
WHERE idkey = '||OLD.idkey_du
USING OLD ;
END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.sup_surf_ajout()
    OWNER TO postgres;
