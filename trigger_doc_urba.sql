-- FUNCTION: plui.doc_urba()

-- DROP FUNCTION plui.doc_urba();

CREATE FUNCTION plui.doc_urba()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN
SELECT '243500667_PLUI_'||to_char(NEW.datappro,'YYYYMMDD') as idurba, 'PLUI', '243500667', '243500667_reglement_'||to_char(NEW.datappro,'YYYYMMDD')||'.pdf' as nomreg, 
		'http://geo.valdille-aubigne.fr/download/urbanisme/reglement/243500667_reglement_'||to_char(NEW.datappro,'YYYYMMDD')||'.pdf' as urlreg, 
		'243500667_reglement_graphique_'||to_char(NEW.datappro,'YYYYMMDD')||'.zip' as nomplan, 
		'http://geo.valdille-aubigne.fr/download/urbanisme/reglement/243500667_reglement_graphique_'||to_char(NEW.datappro,'YYYYMMDD')||'.zip' as urlplan,
		'http://geo.valdille-aubigne.fr/download/urbanisme/243500667_PLUI_'||to_char(NEW.datappro,'YYYYMMDD') as urlpe,
		'http://geobretagne.fr/geonetwork/srv/fre/xml_iso19139?uuid=fr-243500667-plui'||to_char(NEW.datappro,'YYYYMMDD') as urlmd,
		'http://geo.valdille-aubigne.fr/mviewer2/?config=./apps/urbanisme/urbanisme.xml#', '01', '20180601', public.comcom_via.the_geom,
		du.zone_urba, du.zone_urba_libelle, du.prescription_surf, du.prescription_pct, 
		du.prescription_lin, du.info_pct, du.info_surf, du.info_lin, du.prescription_pieces_ecrites,
		du.sup_surf, du.sup_pct, du.sup_lin
INTO NEW.idurba, NEW.typedoc, NEW.siren, NEW.nomreg, NEW.urlreg, NEW.nomplan, NEW.urlplan, NEW.urlpe, NEW.urlmd, NEW.siteweb, NEW.typeref, NEW.dateref, NEW.the_geom,
	NEW.zone_urba, NEW.zone_urba_libelle, NEW.prescription_surf, NEW.prescription_pct, new.prescription_lin, NEW.info_pct, NEW.info_surf, NEW.info_lin, NEW.prescription_pieces_ecrites,
	NEW.sup_surf, NEW.sup_pct, NEW.sup_lin
FROM public.comcom_via, plui.doc_urba du 
WHERE du.etat='03'
;
END IF;

IF TG_OP ='UPDATE' AND NEW.datappro <> OLD.datappro THEN
SELECT '243500667_PLUI_'||to_char(NEW.datappro,'YYYYMMDD') as idurba, '243500667_reglement_'||to_char(NEW.datappro,'YYYYMMDD')||'.pdf' as nomreg, 
		'http://geo.valdille-aubigne.fr/download/urbanisme/reglement/243500667_reglement_'||to_char(NEW.datappro,'YYYYMMDD')||'.pdf' as urlreg, 
		'243500667_reglement_graphique_'||to_char(NEW.datappro,'YYYYMMDD')||'.zip' as nomplan, 
		'http://geo.valdille-aubigne.fr/download/urbanisme/reglement/243500667_reglement_graphique_'||to_char(NEW.datappro,'YYYYMMDD')||'.zip' as urlplan,
		'http://geo.valdille-aubigne.fr/download/urbanisme/243500667_PLUI_'||to_char(NEW.datappro,'YYYYMMDD') as urlpe,
		'http://geobretagne.fr/geonetwork/srv/fre/xml_iso19139?uuid=fr-243500667-plui'||to_char(NEW.datappro,'YYYYMMDD') as urlmd
INTO NEW.idurba, NEW.nomreg, NEW.urlreg, NEW.nomplan, NEW.urlplan, NEW.urlpe, NEW.urlmd ;
END IF;

IF TG_OP ='UPDATE' AND NEW.etat ='03' AND OLD.etat<>'03' THEN
/* Changement statut ancien document */
UPDATE plui.doc_urba
SET etat = '05', datefin= (NEW.datappro - INTERVAL '1 DAY')
WHERE etat = '03' ;

END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.doc_urba()
    OWNER TO postgres;
