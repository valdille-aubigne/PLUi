-- Trigger: zone_urba_suppr

-- DROP TRIGGER zone_urba_suppr ON plui.zone_urba_suppr;

CREATE TRIGGER zone_urba_suppr
    AFTER INSERT OR DELETE
    ON plui.zone_urba_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_suppr();
