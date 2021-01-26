-- FUNCTION: plui.vues_urba()

-- DROP FUNCTION plui.vues_urba();

CREATE OR REPLACE FUNCTION plui.vues_urba()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF TG_OP='INSERT' THEN

/*
ZONE URBA
*/

EXECUTE
'CREATE VIEW plui.zone_urba_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 WITH zuo AS (SELECT unnest(zone_urba) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
 	  zulo AS (SELECT unnest(zone_urba_libelle) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
	  zu AS (
	  	SELECT libelle, typezone, destdomi, datvalid, idkey, the_geom 
		FROM plui.zone_urba zu, zuo 
		WHERE zu.idkey=zuo.id 
	  	UNION 
		SELECT libelle, typezone, destdomi, datvalid, idkey_ajout as idkey, the_geom
		FROM plui.zone_urba_ajouts zu, zuo 
		WHERE zu.idkey_ajout=zuo.id),
	  zul AS (
	  	SELECT libelle, libelong, datvalid, idkey, num_page 
		FROM plui.zone_urba_libelle zul, zulo 
		WHERE zul.idkey=zulo.id
		UNION
		SELECT libelle, libelong, datvalid, idkey_ajout as idkey, num_page 
		FROM plui.zone_urba_libelle_ajouts zul, zulo 
		WHERE zul.idkey_ajout=zulo.id)
 
 SELECT zu.idkey,
    du.idurba,
    zu.libelle,
    zu.typezone,
    zu.destdomi,
    zu.datvalid,
    zud.libelle AS lib_destdomi,
    zul.libelong,
    ((("left"(du.idurba::text, 9) || ''_reglement_''::text) || "right"(du.idurba::text, 8)) || ''.pdf#''::text) || zul.num_page AS nomfic,
    ((((''https://geo.valdille-aubigne.fr/download/urbanisme/reglement/''::text || "left"(du.idurba::text, 9)) || ''_reglement_''::text) || "right"(du.idurba::text, 8)) || ''.pdf#page=''::text) || zul.num_page AS urlfic,
    zu.the_geom
   FROM zu,
    zul,
    plui.zone_urba_destdomi zud
    LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey||'
    WHERE zu.destdomi = zud.code::bpchar AND zu.libelle::text = zul.libelle::text'  
USING NEW;

EXECUTE 'ALTER TABLE plui.zone_urba_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.zone_urba_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.zone_urba_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW ;

EXECUTE 'GRANT ALL ON TABLE plui.zone_urba_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''zone_urba_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''zone_urba_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''zone_urba'' AND stylename=''zone_urba_plui'''
USING NEW ;

/*
PRESCRIPTIONS SURF
*/

EXECUTE
'CREATE VIEW plui.prescription_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH pso AS (SELECT unnest(prescription_surf) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
 	  ppeo AS (SELECT unnest(prescription_pieces_ecrites) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
	  psce AS (
	  	SELECT typepsc, stypepsc, code_commune, idkey, piece_ecrite 
		FROM plui.prescription_pieces_ecrites ppe, ppeo 
		WHERE ppeo.id = ppe.idkey
	  	UNION
		SELECT typepsc, stypepsc, code_commune, idkey_ajout as idkey, piece_ecrite 
		FROM plui.prescription_pieces_ecrites_ajouts ppe, ppeo 
		WHERE ppeo.id = ppe.idkey_ajout), 
	   psc AS (
		SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey, the_geom
		FROM plui.prescription_surf psc, pso 
		WHERE pso.id = psc.idkey
		UNION
		SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey_ajout as idkey, the_geom 
		FROM plui.prescription_surf_ajouts psc, pso 
		WHERE pso.id = psc.idkey_ajout)
 
 SELECT psc.idkey,
    du.idurba,
    psc.libelle,
    psc.txt,
    psc.typepsc,
    psc.stypepsc,
    psc.datvalid,
    psct.libelle AS libtypepsc,
    psct.ref_leg_cu,
    psct.ref_regl_cu,
    (((((''https://geo.valdille-aubigne.fr/download/urbanisme/reglement/''::text || "left"(du.idurba::text, 9)) || ''_''::text) || psce.piece_ecrite::text) || ''_''::text) || "right"(du.idurba::text, 8)) || ''.pdf''::text AS piece_ecrite,
    psc.the_geom
   FROM psc
     LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey||'
     LEFT JOIN psce ON psce.typepsc = psc.typepsc AND (psce.code_commune::text = regexp_replace(psc.txt::text, ''(.*)-(.*)''::text, ''\1''::text) OR psce.code_commune IS NULL)
     LEFT JOIN plui.prescription_urba_type psct ON psc.typepsc = psct.code::bpchar AND psc.stypepsc = psct.sous_code::bpchar;'
	 USING NEW;

EXECUTE 'ALTER TABLE plui.prescription_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.prescription_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.prescription_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.prescription_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''prescription_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''prescription_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''prescription_surf'' AND stylename=''prescription_surf_plui'''
USING NEW ;

/*
PRESCRIPTIONS LIN
*/

EXECUTE
'CREATE VIEW plui.prescription_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH pso AS (SELECT unnest(prescription_lin) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
 	  ppeo AS (SELECT unnest(prescription_pieces_ecrites) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
	  psce AS (
	  	SELECT typepsc, stypepsc, code_commune, idkey, piece_ecrite 
		FROM plui.prescription_pieces_ecrites ppe, ppeo 
		WHERE ppeo.id = ppe.idkey
	  	UNION
		SELECT typepsc, stypepsc, code_commune, idkey_ajout as idkey, piece_ecrite 
		FROM plui.prescription_pieces_ecrites_ajouts ppe, ppeo 
		WHERE ppeo.id = ppe.idkey_ajout), 
	   psc AS (
		SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey, the_geom
		FROM plui.prescription_lin psc, pso 
		WHERE pso.id = psc.idkey
		UNION
		SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey_ajout as idkey, the_geom 
		FROM plui.prescription_lin_ajouts psc, pso 
		WHERE pso.id = psc.idkey_ajout)
 
 SELECT psc.idkey,
    du.idurba,
    psc.libelle,
    psc.txt,
    psc.typepsc,
    psc.stypepsc,
    psc.datvalid,
    psct.libelle AS libtypepsc,
    psct.ref_leg_cu,
    psct.ref_regl_cu,
    (((((''https://geo.valdille-aubigne.fr/download/urbanisme/reglement/''::text || "left"(du.idurba::text, 9)) || ''_''::text) || psce.piece_ecrite::text) || ''_''::text) || "right"(du.idurba::text, 8)) || ''.pdf''::text AS piece_ecrite,
    psc.the_geom
   FROM psc
     LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey||'
     LEFT JOIN psce ON psce.typepsc = psc.typepsc AND (psce.code_commune::text = regexp_replace(psc.txt::text, ''(.*)-(.*)''::text, ''\1''::text) OR psce.code_commune IS NULL)
     LEFT JOIN plui.prescription_urba_type psct ON psc.typepsc = psct.code::bpchar AND psc.stypepsc = psct.sous_code::bpchar;'
	 USING NEW;

EXECUTE 'ALTER TABLE plui.prescription_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.prescription_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.prescription_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.prescription_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''prescription_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''prescription_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''prescription_lin'' AND stylename=''prescription_lin_plui'''
USING NEW ;

/*
PRESCRIPTIONS PCT
*/

EXECUTE
'CREATE VIEW plui.prescription_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH pso AS (SELECT unnest(prescription_pct) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
 	  ppeo AS (SELECT unnest(prescription_pieces_ecrites) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
	  psce AS (
	  	SELECT typepsc, stypepsc, code_commune, idkey, piece_ecrite 
		FROM plui.prescription_pieces_ecrites ppe, ppeo 
		WHERE ppeo.id = ppe.idkey
	  	UNION
		SELECT typepsc, stypepsc, code_commune, idkey_ajout as idkey, piece_ecrite 
		FROM plui.prescription_pieces_ecrites_ajouts ppe, ppeo 
		WHERE ppeo.id = ppe.idkey_ajout), 
	   psc AS (
		SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey, the_geom
		FROM plui.prescription_pct psc, pso 
		WHERE pso.id = psc.idkey
		UNION
		SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey_ajout as idkey, the_geom 
		FROM plui.prescription_pct_ajouts psc, pso 
		WHERE pso.id = psc.idkey_ajout)
 
 SELECT psc.idkey,
    du.idurba,
    psc.libelle,
    psc.txt,
    psc.typepsc,
    psc.stypepsc,
    psc.datvalid,
    psct.libelle AS libtypepsc,
    psct.ref_leg_cu,
    psct.ref_regl_cu,
    (((((''https://geo.valdille-aubigne.fr/download/urbanisme/reglement/''::text || "left"(du.idurba::text, 9)) || ''_''::text) || psce.piece_ecrite::text) || ''_''::text) || "right"(du.idurba::text, 8)) || ''.pdf''::text AS piece_ecrite,
    psc.the_geom
   FROM psc
     LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey||'
     LEFT JOIN psce ON psce.typepsc = psc.typepsc AND (psce.code_commune::text = regexp_replace(psc.txt::text, ''(.*)-(.*)''::text, ''\1''::text) OR psce.code_commune IS NULL)
     LEFT JOIN plui.prescription_urba_type psct ON psc.typepsc = psct.code::bpchar AND psc.stypepsc = psct.sous_code::bpchar;'
	 USING NEW;

EXECUTE 'ALTER TABLE plui.prescription_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.prescription_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.prescription_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.prescription_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''prescription_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''prescription_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''prescription_pct'' AND stylename=''prescription_pct_plui'''
USING NEW ;

/*
INFOS SURF
*/

EXECUTE
'CREATE VIEW plui.info_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH ino AS (SELECT unnest(info_surf) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
	  inf AS (
		SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey, the_geom
		FROM plui.info_surf inf, ino 
		WHERE ino.id = inf.idkey
		UNION
		SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey_ajout as idkey, the_geom 
		FROM plui.info_surf_ajouts inf, ino 
		WHERE ino.id = inf.idkey_ajout)
		
 SELECT inf.idkey,
    du.idurba,
    inf.libelle,
    inf.txt,
    inf.typeinf,
    inf.stypeinf,
    inf.datvalid,
	inf.nomfic,
	inf.urlfic,
    inft.libelle AS libtypeinf,
    inft.ref_leg_cu,
    inft.ref_regl_cu,
    inf.the_geom
    FROM inf
	 LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey||'
	 LEFT JOIN plui.info_urba_type inft ON inf.typeinf = inft.code::bpchar AND inf.stypeinf = inft.sous_code::bpchar'
USING NEW;

EXECUTE 'ALTER TABLE plui.info_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.info_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.info_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.info_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''info_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''info_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''info_surf'' AND stylename=''info_surf_plui'''
USING NEW ;

/*
INFOS LIN
*/

EXECUTE
'CREATE VIEW plui.info_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH ino AS (SELECT unnest(info_lin) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
	  inf AS (
		SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey, the_geom
		FROM plui.info_lin inf, ino 
		WHERE ino.id = inf.idkey
		UNION
		SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey_ajout as idkey, the_geom 
		FROM plui.info_lin_ajouts inf, ino 
		WHERE ino.id = inf.idkey_ajout)
		
 SELECT inf.idkey,
    du.idurba,
    inf.libelle,
    inf.txt,
    inf.typeinf,
    inf.stypeinf,
    inf.datvalid,
	inf.nomfic,
	inf.urlfic,
    inft.libelle AS libtypeinf,
    inft.ref_leg_cu,
    inft.ref_regl_cu,
    inf.the_geom
    FROM inf
	 LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey||'
	 LEFT JOIN plui.info_urba_type inft ON inf.typeinf = inft.code::bpchar AND inf.stypeinf = inft.sous_code::bpchar'
USING NEW;

EXECUTE 'ALTER TABLE plui.info_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.info_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.info_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.info_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''info_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''info_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''info_lin'' AND stylename=''info_lin_plui'''
USING NEW ;

/*
INFOS PCT
*/

EXECUTE
'CREATE VIEW plui.info_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH ino AS (SELECT unnest(info_pct) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
	  inf AS (
		SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey, the_geom
		FROM plui.info_pct inf, ino 
		WHERE ino.id = inf.idkey
		UNION
		SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey_ajout as idkey, the_geom 
		FROM plui.info_pct_ajouts inf, ino 
		WHERE ino.id = inf.idkey_ajout)
		
 SELECT inf.idkey,
    du.idurba,
    inf.libelle,
    inf.txt,
    inf.typeinf,
    inf.stypeinf,
    inf.datvalid,
	inf.nomfic,
	inf.urlfic,
    inft.libelle AS libtypeinf,
    inft.ref_leg_cu,
    inft.ref_regl_cu,
    inf.the_geom
    FROM inf
	 LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey||'
	 LEFT JOIN plui.info_urba_type inft ON inf.typeinf = inft.code::bpchar AND inf.stypeinf = inft.sous_code::bpchar'
USING NEW;

EXECUTE 'ALTER TABLE plui.info_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.info_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.info_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.info_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''info_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''info_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''info_pct'' AND stylename=''info_pct_plui'''
USING NEW ;

/*
SUP SURF
*/

EXECUTE
'CREATE VIEW plui.sup_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH supo AS (SELECT unnest(sup_surf) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
 	  sup AS (
		SELECT idkey, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom
		FROM plui.sup_surf sup, supo 
		WHERE supo.id = sup.idkey
		UNION
		SELECT idkey_ajout as idkey, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom 
		FROM plui.sup_surf_ajouts sup, supo 
		WHERE supo.id = sup.idkey_ajout)
		
 SELECT sup.idkey,
    du.idurba,
    sup.libsup,
    sup.categorie,
    sup.infos,
    sup.regles,
    sup.datappro,
   	sup.nomfic,
	sup.urlfic,
	sup.datvalid,
    sup.the_geom
   FROM sup
     LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey	
USING NEW;

EXECUTE 'ALTER TABLE plui.sup_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.sup_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.sup_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.sup_surf_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''sup_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''sup_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''sup_surf'' AND stylename=''sup_surf_plui'''
USING NEW ;

/*
SUP LIN
*/

EXECUTE
'CREATE VIEW plui.sup_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH supo AS (SELECT unnest(sup_lin) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
 	  sup AS (
		SELECT idkey, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom
		FROM plui.sup_lin sup, supo 
		WHERE supo.id = sup.idkey
		UNION
		SELECT idkey_ajout as idkey, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom 
		FROM plui.sup_lin_ajouts sup, supo 
		WHERE supo.id = sup.idkey_ajout)
		
 SELECT sup.idkey,
    du.idurba,
    sup.libsup,
    sup.categorie,
    sup.infos,
    sup.regles,
    sup.datappro,
   	sup.nomfic,
	sup.urlfic,
	sup.datvalid,
    sup.the_geom
   FROM sup
     LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey	
USING NEW;

EXECUTE 'ALTER TABLE plui.sup_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.sup_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.sup_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.sup_lin_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''sup_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''sup_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''sup_lin'' AND stylename=''sup_lin_plui'''
USING NEW ;

/*
SUP PCT
*/

EXECUTE
'CREATE VIEW plui.sup_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||'
 AS
 
 WITH supo AS (SELECT unnest(sup_pct) as id FROM plui.doc_urba WHERE idkey='||NEW.idkey||'),
 	  sup AS (
		SELECT idkey, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom
		FROM plui.sup_pct sup, supo 
		WHERE supo.id = sup.idkey
		UNION
		SELECT idkey_ajout as idkey, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom 
		FROM plui.sup_pct_ajouts sup, supo 
		WHERE supo.id = sup.idkey_ajout)
		
 SELECT sup.idkey,
    du.idurba,
    sup.libsup,
    sup.categorie,
    sup.infos,
    sup.regles,
    sup.datappro,
   	sup.nomfic,
	sup.urlfic,
	sup.datvalid,
    sup.the_geom
   FROM sup
     LEFT JOIN plui.doc_urba du ON du.idkey = '||NEW.idkey	
USING NEW;

EXECUTE 'ALTER TABLE plui.sup_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' OWNER TO postgres'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.sup_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO postgres'
USING NEW;

EXECUTE 'GRANT SELECT ON TABLE plui.sup_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO g_valdilleaubigne'
USING NEW;

EXECUTE 'GRANT ALL ON TABLE plui.sup_pct_'||NEW.nomproc||'_'||to_char(NEW.datappro,'ddmmyyyy')||' TO vm4ms_admin'
USING NEW;

EXECUTE 
'INSERT INTO public.layer_styles (f_table_catalog, f_table_schema, f_table_name, f_geometry_column, stylename, styleqml, stylesld, useasdefault, description, owner, ui)
SELECT f_table_catalog, f_table_schema, ''sup_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', f_geometry_column, ''sup_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', styleqml, stylesld, useasdefault, description, owner, ui
FROM public.layer_styles
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' AND f_table_name=''sup_pct'' AND stylename=''sup_pct_plui'''
USING NEW ;

END IF;

IF TG_OP ='DELETE' THEN
EXECUTE 'DROP VIEW IF EXISTS plui.zone_urba_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles 
WHERE f_table_catalog=''sig'' AND f_table_schema=''plui''
	AND f_table_name=''zone_urba_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||'''   
	AND stylename=''zone_urba_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.prescription_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''prescription_surf_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''prescription_surf_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.prescription_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''prescription_lin_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''prescription_lin_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.prescription_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''prescription_pct_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''prescription_pct_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.info_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''info_surf_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''info_surf_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.info_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''info_lin_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''info_lin_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.info_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''info_pct_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''info_pct_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.sup_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''sup_surf_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''sup_surf_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.sup_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''sup_lin_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''sup_lin_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

EXECUTE 'DROP VIEW IF EXISTS plui.sup_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')
USING OLD;

EXECUTE 
'DELETE FROM public.layer_styles
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''sup_pct_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''sup_pct_'||OLD.nomproc||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING OLD ;

END IF;

IF TG_OP ='UPDATE' AND (NEW.nomproc <> OLD.nomproc OR NEW.datappro <> OLD.datappro) THEN

EXECUTE 'ALTER VIEW IF EXISTS plui.zone_urba_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO zone_urba_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''zone_urba_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''zone_urba_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''zone_urba_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''zone_urba_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.prescription_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO prescription_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''prescription_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''prescription_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''prescription_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''prescription_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.prescription_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO prescription_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''prescription_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''prescription_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''prescription_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''prescription_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.prescription_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO prescription_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''prescription_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''prescription_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''prescription_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''prescription_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.info_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO info_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''info_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''info_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''info_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''info_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.info_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO info_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''info_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''info_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''info_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''info_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.info_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO info_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''info_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''info_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''info_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''info_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.sup_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO sup_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''sup_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''sup_surf_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''sup_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''sup_surf_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.sup_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO sup_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;
EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''sup_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''sup_lin_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''sup_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''sup_lin_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

EXECUTE 'ALTER VIEW IF EXISTS plui.sup_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||' RENAME TO sup_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')
USING NEW, OLD;

EXECUTE 
'UPDATE public.layer_styles
 SET f_table_name = ''sup_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||''', 
	stylename = ''sup_pct_'||lower(NEW.nomproc)||'_'||to_char(NEW.datappro,'ddmmyyyy')||'''
 WHERE f_table_catalog=''sig'' AND f_table_schema=''plui'' 
	AND f_table_name=''sup_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''' 
	AND stylename=''sup_pct_'||lower(OLD.nomproc)||'_'||to_char(OLD.datappro,'ddmmyyyy')||''''
USING NEW, OLD ;

END IF;

IF TG_OP ='UPDATE' AND NEW.etat ='03' AND OLD.etat<>'03' THEN

/* Copie ajouts vers couches globales */

INSERT INTO plui.zone_urba
	SELECT libelle, typezone, destdomi, datvalid, idkey_ajout, the_geom 
	FROM plui.zone_urba_ajouts
	WHERE idkey_du = NEW.idkey
	;
INSERT INTO plui.zone_urba_libelle
	SELECT libelle, libelong, datvalid, idkey_ajout, num_page 
	FROM plui.zone_urba_libelle_ajouts
	WHERE idkey_du = NEW.idkey
	;

INSERT INTO plui.prescription_surf
	SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey_ajout, the_geom 
	FROM plui.prescription_surf_ajouts
	WHERE idkey_du = NEW.idkey
	;
INSERT INTO plui.prescription_lin
	SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey_ajout, the_geom 
	FROM plui.prescription_lin_ajouts
	WHERE idkey_du = NEW.idkey
	;
INSERT INTO plui.prescription_pct
	SELECT libelle, txt, typepsc, stypepsc, nomfic, urlfic, datvalid, idkey_ajout, the_geom 
	FROM plui.prescription_pct_ajouts
	WHERE idkey_du = NEW.idkey
	;
INSERT INTO plui.prescription_pieces_ecrites
	SELECT typepsc, stypepsc, code_commune, idkey_ajout, piece_ecrite 
	FROM plui.prescription_pieces_ecrites_ajouts
	WHERE idkey_du = NEW.idkey
	;

INSERT INTO plui.info_surf
	SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey_ajout, the_geom 
	FROM plui.info_surf_ajouts
	WHERE idkey_du = NEW.idkey
	;
INSERT INTO plui.info_lin
	SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey_ajout, the_geom 
	FROM plui.info_lin_ajouts
	WHERE idkey_du = NEW.idkey
	;
INSERT INTO plui.info_pct
	SELECT libelle, txt, typeinf, stypeinf, nomfic, urlfic, datvalid, idkey_ajout, the_geom 
	FROM plui.info_pct_ajouts
	WHERE idkey_du = NEW.idkey
	;

INSERT INTO plui.sup_surf
	SELECT idkey_ajout, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom 
	FROM plui.sup_surf_ajouts
	WHERE idkey_du = NEW.idkey
	;
INSERT INTO plui.sup_lin
	SELECT idkey_ajout, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom 
	FROM plui.sup_lin_ajouts
	WHERE idkey_du = NEW.idkey
	;
INSERT INTO plui.sup_pct
	SELECT idkey_ajout, libsup, categorie, infos, regles, datappro, nomfic, urlfic, datvalid, the_geom 
	FROM plui.sup_pct_ajouts
	WHERE idkey_du = NEW.idkey
	;	

/* DELETE FROM COUCHES AJOUTS */
ALTER TABLE plui.zone_urba_ajouts DISABLE TRIGGER zone_urba_ajout;
DELETE FROM plui.zone_urba_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.zone_urba_ajouts ENABLE TRIGGER zone_urba_ajout;

ALTER TABLE plui.zone_urba_libelle_ajouts DISABLE TRIGGER zone_urba_libelle_ajout;
DELETE FROM plui.zone_urba_libelle_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.zone_urba_libelle_ajouts ENABLE TRIGGER zone_urba_libelle_ajout;

ALTER TABLE plui.prescription_surf_ajouts DISABLE TRIGGER prescription_surf_ajout;
DELETE FROM plui.prescription_surf_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.prescription_surf_ajouts ENABLE TRIGGER prescription_surf_ajout;

ALTER TABLE plui.prescription_lin_ajouts DISABLE TRIGGER prescription_lin_ajout;
DELETE FROM plui.prescription_lin_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.prescription_lin_ajouts ENABLE TRIGGER prescription_lin_ajout;

ALTER TABLE plui.prescription_pct_ajouts DISABLE TRIGGER prescription_pct_ajout;
DELETE FROM plui.prescription_pct_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.prescription_pct_ajouts ENABLE TRIGGER prescription_pct_ajout;

ALTER TABLE plui.prescription_pieces_ecrites_ajouts DISABLE TRIGGER prescription_pieces_ecrites_ajout;
DELETE FROM plui.prescription_pieces_ecrites_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.prescription_pieces_ecrites_ajouts ENABLE TRIGGER prescription_pieces_ecrites_ajout;

ALTER TABLE plui.info_surf_ajouts DISABLE TRIGGER info_surf_ajout;
DELETE FROM plui.info_surf_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.info_surf_ajouts ENABLE TRIGGER info_surf_ajout;

ALTER TABLE plui.info_lin_ajouts DISABLE TRIGGER info_lin_ajout;
DELETE FROM plui.info_lin_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.info_lin_ajouts ENABLE TRIGGER info_lin_ajout;

ALTER TABLE plui.info_pct_ajouts DISABLE TRIGGER info_pct_ajout;
DELETE FROM plui.info_pct_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.info_pct_ajouts ENABLE TRIGGER info_pct_ajout;

ALTER TABLE plui.sup_surf_ajouts DISABLE TRIGGER sup_surf_ajout;
DELETE FROM plui.sup_surf_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.sup_surf_ajouts ENABLE TRIGGER sup_surf_ajout;

ALTER TABLE plui.sup_lin_ajouts DISABLE TRIGGER sup_lin_ajout;
DELETE FROM plui.sup_lin_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.sup_lin_ajouts ENABLE TRIGGER sup_lin_ajout;

ALTER TABLE plui.sup_pct_ajouts DISABLE TRIGGER sup_pct_ajout;
DELETE FROM plui.sup_pct_ajouts WHERE idkey_du = NEW.idkey ;
ALTER TABLE plui.sup_pct_ajouts ENABLE TRIGGER sup_pct_ajout;

END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION plui.vues_urba()
    OWNER TO postgres;
