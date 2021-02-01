-- Trigger: info_lin_ajout

-- DROP TRIGGER info_lin_ajout ON plui.info_lin_ajouts;

CREATE TRIGGER info_lin_ajout
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.info_lin_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_lin_ajout();
