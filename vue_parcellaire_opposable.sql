CREATE MATERIALIZED VIEW plui.parcellaire_opposable
TABLESPACE pg_default
AS
 WITH zone_urba_commune AS (
         SELECT zon.libelle,
            com.idu,
            zon.idurba,
            zon.typezone,
            zon.lib_destdomi,
            zon.libelong,
            zon.urlfic,
            st_collectionextract(st_intersection(com.geom, zon.the_geom), 3) AS the_geom
           FROM plui.zone_urba_opposable zon,
            majic.geo_commune com
        ), prescriptions_opposable AS (
         SELECT psc.libelle,
            psc.idurba,
            psc.txt,
            psc.typepsc,
            psc.stypepsc,
            psc.libtypepsc,
            psc.piece_ecrite,
            psc.the_geom
           FROM plui.prescription_surf_opposable psc
        UNION ALL
         SELECT psc.libelle,
            psc.idurba,
            psc.txt,
            psc.typepsc,
            psc.stypepsc,
            psc.libtypepsc,
            psc.piece_ecrite,
            psc.the_geom
           FROM plui.prescription_pct_opposable psc
        UNION ALL
         SELECT psc.libelle,
            psc.idurba,
            psc.txt,
            psc.typepsc,
            psc.stypepsc,
            psc.libtypepsc,
            psc.piece_ecrite,
            psc.the_geom
           FROM plui.prescription_lin_opposable psc
        ), informations_opposable AS (
         SELECT inf.libelle,
            inf.idurba,
            inf.txt,
            inf.typeinf,
            inf.stypeinf,
            inf.libtypeinf,
	    inf.urlfic,
            inf.the_geom
           FROM plui.info_surf_opposable inf
        UNION ALL
         SELECT inf.libelle,
            inf.idurba,
            inf.txt,
            inf.typeinf,
            inf.stypeinf,
            inf.libtypeinf,
	    inf.urlfic,
            inf.the_geom
           FROM plui.info_pct_opposable inf
        UNION ALL
         SELECT inf.libelle,
            inf.idurba,
            inf.txt,
            inf.typeinf,
            inf.stypeinf,
            inf.libtypeinf,
	    inf.urlfic,
            inf.the_geom
           FROM plui.info_lin_opposable inf
        ), sup_opposable AS (
         SELECT sup.libsup,
            sup.categorie,
            sup.infos,
            sup.regles,
            sup.urlfic,
            sup.the_geom
           FROM plui.sup_surf_opposable sup
        UNION ALL
         SELECT sup.libsup,
            sup.categorie,
            sup.infos,
            sup.regles,
            sup.urlfic,
            sup.the_geom
           FROM plui.sup_lin_opposable sup
        UNION ALL
         SELECT sup.libsup,
            sup.categorie,
            sup.infos,
            sup.regles,
            sup.urlfic,
            sup.the_geom
           FROM plui.sup_pct_opposable sup
        ), parc_contenu AS (
         SELECT parc.idu,
            parc.supf,
            parc.tex,
            json_agg(json_build_object('libelle', zon.libelle, 'libelong', zon.libelong, 'urlfic', zon.urlfic)) AS zonage,
            parc.geom
           FROM majic.geo_parcelle parc,
            zone_urba_commune zon
          WHERE ((zon.idu = "left"(parc.idu, 3)) AND st_contains(zon.the_geom, parc.geom))
          GROUP BY parc.idu, parc.supf, parc.tex, parc.geom
        ), parc_non_contenu AS (
         SELECT parc.idu,
            parc.supf,
            parc.tex,
            parc.geom
           FROM majic.geo_parcelle parc
          WHERE (NOT (EXISTS ( SELECT
                   FROM parc_contenu
                  WHERE (parc_contenu.idu = parc.idu))))
        ), parc_zonage AS (
         SELECT parc.idu,
            parc.supf,
            parc.tex,
            json_agg(json_build_object('libelle', zon.libelle, 'libelong', zon.libelong, 'urlfic', zon.urlfic)) AS zonage,
            parc.geom
           FROM parc_non_contenu parc,
            zone_urba_commune zon
          WHERE ((zon.idu = "left"(parc.idu, 3)) AND st_intersects(parc.geom, zon.the_geom) AND (round((((100)::double precision * st_area(st_intersection(parc.geom, zon.the_geom))) / st_area(parc.geom))) > (0)::double precision) AND (st_perimeter(st_intersection(parc.geom, zon.the_geom)) > (0)::double precision) AND (st_area(st_intersection(parc.geom, zon.the_geom)) > (0)::double precision) AND ((st_area(st_intersection(parc.geom, zon.the_geom)) / st_perimeter(st_intersection(parc.geom, zon.the_geom))) > (0.1)::double precision))
          GROUP BY parc.idu, parc.supf, parc.tex, parc.geom
        UNION ALL
         SELECT parc_contenu.idu,
            parc_contenu.supf,
            parc_contenu.tex,
            parc_contenu.zonage,
            parc_contenu.geom
           FROM parc_contenu
        ), prescriptions_opposable_parc AS (
         SELECT DISTINCT parc.idu,
            psc.libelle,
            psc.txt,
            psc.libtypepsc,
            psc.piece_ecrite
           FROM majic.geo_parcelle parc,
            prescriptions_opposable psc
          WHERE st_intersects(parc.geom, psc.the_geom)
        ), parc_prescription AS (
         SELECT prescriptions_opposable_parc.idu,
            json_agg(json_build_object('libelle', prescriptions_opposable_parc.libelle, 'txt', prescriptions_opposable_parc.txt, 'libtypepsc', prescriptions_opposable_parc.libtypepsc, 'piece_ecrite', prescriptions_opposable_parc.piece_ecrite)) AS prescription
           FROM prescriptions_opposable_parc
          GROUP BY prescriptions_opposable_parc.idu
        ), informations_opposable_parc AS (
         SELECT DISTINCT parc.idu,
            inf.libelle,
            inf.txt,
            inf.libtypeinf,
            inf.typeinf,
            inf.stypeinf,
	    inf.urlfic
           FROM majic.geo_parcelle parc,
            informations_opposable inf
          WHERE st_intersects(parc.geom, inf.the_geom)
        ), parc_information AS (
         SELECT informations_opposable_parc.idu,
            json_agg(json_build_object('libelle', informations_opposable_parc.libelle, 'txt', informations_opposable_parc.txt, 'libtypeinf', informations_opposable_parc.libtypeinf, 'typeinf', informations_opposable_parc.typeinf, 'stypeinf', informations_opposable_parc.stypeinf, 'urlfic', informations_opposable_parc.urlfic)) AS information
           FROM informations_opposable_parc
          GROUP BY informations_opposable_parc.idu
        ), sup_opposable_parc AS (
         SELECT DISTINCT parc.idu,
            sup.libsup,
            sup.categorie,
            sup.infos,
            sup.regles,
            sup.urlfic
           FROM majic.geo_parcelle parc,
            sup_opposable sup
          WHERE st_intersects(parc.geom, sup.the_geom)
        ), parc_sup AS (
         SELECT sup_opposable_parc.idu,
            json_agg(json_build_object('libelle', sup_opposable_parc.libsup, 'categorie', sup_opposable_parc.categorie, 'infos', sup_opposable_parc.infos, 'regles', sup_opposable_parc.regles, 'urlfic', sup_opposable_parc.urlfic)) AS sup
           FROM sup_opposable_parc
          GROUP BY sup_opposable_parc.idu
        )
 SELECT pzon.idu,
    pzon.supf,
    pzon.tex,
    pzon.zonage,
    ppsc.prescription,
    pinf.information,
    psup.sup,
    pzon.geom
   FROM (((parc_zonage pzon
     LEFT JOIN parc_prescription ppsc ON ((pzon.idu = ppsc.idu)))
     LEFT JOIN parc_information pinf ON ((pzon.idu = pinf.idu)))
     LEFT JOIN parc_sup psup ON ((pzon.idu = psup.idu)))
