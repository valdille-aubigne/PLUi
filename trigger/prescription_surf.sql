-- Trigger: prescription_surf

-- DROP TRIGGER prescription_surf ON plui.prescription_surf;

CREATE TRIGGER prescription_surf
    AFTER INSERT OR DELETE
    ON plui.prescription_surf
    FOR EACH ROW
    EXECUTE PROCEDURE plui.prescription_surf();
