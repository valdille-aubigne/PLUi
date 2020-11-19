-- Trigger: zone_urba

-- DROP TRIGGER zone_urba ON plui.zone_urba;

CREATE TRIGGER zone_urba
    AFTER INSERT OR DELETE
    ON plui.zone_urba
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba();
