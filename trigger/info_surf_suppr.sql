-- Trigger: info_surf_suppr

-- DROP TRIGGER info_surf_suppr ON plui.info_surf_suppr;

CREATE TRIGGER info_surf_suppr
    AFTER INSERT OR DELETE
    ON plui.info_surf_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_surf_suppr();
