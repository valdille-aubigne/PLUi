-- Trigger: sup_surf_ajout

-- DROP TRIGGER sup_surf_ajout ON plui.sup_surf_ajouts;

CREATE TRIGGER sup_surf_ajout
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.sup_surf_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_surf_ajout();
