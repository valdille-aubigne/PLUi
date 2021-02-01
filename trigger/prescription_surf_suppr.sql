-- Trigger: prescription_surf_suppr

-- DROP TRIGGER prescription_surf_suppr ON plui.prescription_surf_suppr;

CREATE TRIGGER prescription_surf_suppr
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.prescription_surf_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_surf_suppr();
