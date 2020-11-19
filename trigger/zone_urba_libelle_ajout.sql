-- Trigger: zone_urba_libelle_ajout

-- DROP TRIGGER zone_urba_libelle_ajout ON plui.zone_urba_libelle_ajouts;

CREATE TRIGGER zone_urba_libelle_ajout
    AFTER INSERT OR DELETE
    ON plui.zone_urba_libelle_ajouts
    FOR EACH ROW
    EXECUTE PROCEDURE plui.zone_urba_libelle_ajout();
