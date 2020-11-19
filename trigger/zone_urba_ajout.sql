-- Trigger: zone_urba_ajout

-- DROP TRIGGER zone_urba_ajout ON plui.zone_urba_ajouts;

CREATE TRIGGER zone_urba_ajout
    AFTER INSERT OR DELETE
    ON plui.zone_urba_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_ajout();
