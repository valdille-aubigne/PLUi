-- Trigger: zone_urba_libelle

-- DROP TRIGGER zone_urba_libelle ON plui.zone_urba_libelle;

CREATE TRIGGER zone_urba_libelle
    AFTER INSERT OR DELETE
    ON plui.zone_urba_libelle
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_libelle();
