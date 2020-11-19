-- Trigger: sup_lin

-- DROP TRIGGER sup_lin ON plui.sup_lin;

CREATE TRIGGER sup_lin
    AFTER INSERT OR DELETE
    ON plui.sup_lin
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_lin();
