-- Trigger: sup_lin_suppr

-- DROP TRIGGER sup_lin_suppr ON plui.sup_lin_suppr;

CREATE TRIGGER sup_lin_suppr
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.sup_lin_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_lin_suppr();
