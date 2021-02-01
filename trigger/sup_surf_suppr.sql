-- Trigger: sup_surf_suppr

-- DROP TRIGGER sup_surf_suppr ON plui.sup_surf_suppr;

CREATE TRIGGER sup_surf_suppr
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.sup_surf_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_surf_suppr();
