-- Trigger: info_lin

-- DROP TRIGGER info_lin ON plui.info_lin;

CREATE TRIGGER info_lin
    AFTER INSERT OR DELETE
    ON plui.info_lin
    FOR EACH ROW
    EXECUTE PROCEDURE plui.info_lin();
