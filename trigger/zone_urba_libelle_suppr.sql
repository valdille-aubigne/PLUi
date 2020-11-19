-- Trigger: zone_urba_libelle_suppr

-- DROP TRIGGER zone_urba_libelle_suppr ON plui.zone_urba_libelle_suppr;

CREATE TRIGGER zone_urba_libelle_suppr
    AFTER INSERT OR DELETE
    ON plui.zone_urba_libelle_suppr
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_libelle_suppr();
