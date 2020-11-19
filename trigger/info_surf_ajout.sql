-- Trigger: info_surf_ajout

-- DROP TRIGGER info_surf_ajout ON plui.info_surf_ajouts;

CREATE TRIGGER info_surf_ajout
    AFTER INSERT OR DELETE
    ON plui.info_surf_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_surf_ajout();
