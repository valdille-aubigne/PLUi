-- Trigger: sup_surf

-- DROP TRIGGER sup_surf ON plui.sup_surf;

CREATE TRIGGER sup_surf
    AFTER INSERT OR DELETE
    ON plui.sup_surf
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_surf();
