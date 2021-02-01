-- Trigger: prescription_surf_ajout

-- DROP TRIGGER prescription_surf_ajout ON plui.prescription_surf_ajouts;

CREATE TRIGGER prescription_surf_ajout
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.prescription_surf_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_surf_ajout();
