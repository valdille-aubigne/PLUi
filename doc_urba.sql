-- Trigger: doc_urba

-- DROP TRIGGER doc_urba ON plui.doc_urba;

CREATE TRIGGER doc_urba
    BEFORE INSERT OR UPDATE 
    ON plui.doc_urba
    FOR EACH ROW
    EXECUTE PROCEDURE plui.doc_urba();
