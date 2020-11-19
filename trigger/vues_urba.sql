-- Trigger: vues_urba

-- DROP TRIGGER vues_urba ON plui.doc_urba;

CREATE TRIGGER vues_urba
    AFTER INSERT OR DELETE OR UPDATE 
    ON plui.doc_urba
    FOR EACH ROW
    EXECUTE PROCEDURE plui.vues_urba();
