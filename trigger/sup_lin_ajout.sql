-- Trigger: sup_lin_ajout

-- DROP TRIGGER sup_lin_ajout ON plui.sup_lin_ajouts;

CREATE TRIGGER sup_lin_ajout
    AFTER INSERT OR DELETE OR UPDATE
    ON plui.sup_lin_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.sup_lin_ajout();
