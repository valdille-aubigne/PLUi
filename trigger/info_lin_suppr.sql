-- Trigger: info_lin_suppr

-- DROP TRIGGER info_lin_suppr ON plui.info_lin_suppr;

CREATE TRIGGER info_lin_suppr
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.info_lin_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_lin_suppr();
