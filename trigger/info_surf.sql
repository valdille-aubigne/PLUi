-- Trigger: info_surf

-- DROP TRIGGER info_surf ON plui.info_surf;

CREATE TRIGGER info_surf
    AFTER INSERT OR DELETE
    ON plui.info_surf
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_surf();
