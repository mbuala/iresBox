--
-- PostgreSQL database dump
--

-- Dumped from database version 12.8 (Ubuntu 12.8-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.8 (Ubuntu 12.8-0ubuntu0.20.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: certificat; Type: TABLE; Schema: public; Owner: mbuala
--

CREATE TABLE public.certificat (
    idcertificat integer NOT NULL,
    nomcertificat character varying(100) NOT NULL,
    path character varying(100) NOT NULL
);


ALTER TABLE public.certificat OWNER TO mbuala;

--
-- Name: certificat_idcertificat_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public.certificat_idcertificat_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.certificat_idcertificat_seq OWNER TO mbuala;

--
-- Name: certificat_idcertificat_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public.certificat_idcertificat_seq OWNED BY public.certificat.idcertificat;


--
-- Name: compterendubox; Type: TABLE; Schema: public; Owner: mbuala
--

CREATE TABLE public.compterendubox (
    idcoompterendu integer NOT NULL,
    path character varying(100) NOT NULL,
    dateedition date NOT NULL,
    biologistevalidateur character varying(100) NOT NULL,
    nbrpage integer,
    disponible boolean DEFAULT false,
    piedpage boolean DEFAULT false,
    signature boolean DEFAULT false,
    entetepage boolean DEFAULT false,
    certificat boolean DEFAULT false,
    patient character varying NOT NULL,
    numerodossier text NOT NULL,
    sexe character varying(100),
    adresse character varying(100) NOT NULL,
    medecin character varying(100) NOT NULL,
    nom character varying,
    prenom character varying,
    email character varying,
    nommedecin character varying,
    prenommedecin character varying,
    emailmedecin character varying,
    datecreation date,
    etat character varying NOT NULL,
    datenaissance date
);


ALTER TABLE public.compterendubox OWNER TO mbuala;

--
-- Name: compterendubox_EmailMedecin_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public."compterendubox_EmailMedecin_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."compterendubox_EmailMedecin_seq" OWNER TO mbuala;

--
-- Name: compterendubox_EmailMedecin_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public."compterendubox_EmailMedecin_seq" OWNED BY public.compterendubox.emailmedecin;


--
-- Name: compterendubox_emailPatient_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public."compterendubox_emailPatient_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."compterendubox_emailPatient_seq" OWNER TO mbuala;

--
-- Name: compterendubox_emailPatient_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public."compterendubox_emailPatient_seq" OWNED BY public.compterendubox.email;


--
-- Name: compterendubox_idcoompterendu_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public.compterendubox_idcoompterendu_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.compterendubox_idcoompterendu_seq OWNER TO mbuala;

--
-- Name: compterendubox_idcoompterendu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public.compterendubox_idcoompterendu_seq OWNED BY public.compterendubox.idcoompterendu;


--
-- Name: compterendubox_prenomPatient_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public."compterendubox_prenomPatient_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."compterendubox_prenomPatient_seq" OWNER TO mbuala;

--
-- Name: compterendubox_prenomPatient_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public."compterendubox_prenomPatient_seq" OWNED BY public.compterendubox.prenom;


--
-- Name: entetepage; Type: TABLE; Schema: public; Owner: mbuala
--

CREATE TABLE public.entetepage (
    identete integer NOT NULL,
    nomentete character varying(100) NOT NULL,
    path character varying(100) NOT NULL
);


ALTER TABLE public.entetepage OWNER TO mbuala;

--
-- Name: entetepage_identete_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public.entetepage_identete_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entetepage_identete_seq OWNER TO mbuala;

--
-- Name: entetepage_identete_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public.entetepage_identete_seq OWNED BY public.entetepage.identete;


--
-- Name: erreur; Type: TABLE; Schema: public; Owner: mbuala
--

CREATE TABLE public.erreur (
    iderreur integer NOT NULL,
    typeerreurid integer NOT NULL,
    date timestamp without time zone NOT NULL
);


ALTER TABLE public.erreur OWNER TO mbuala;

--
-- Name: erreur_iderreur_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public.erreur_iderreur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.erreur_iderreur_seq OWNER TO mbuala;

--
-- Name: erreur_iderreur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public.erreur_iderreur_seq OWNED BY public.erreur.iderreur;


--
-- Name: erreur_typeerreurid_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public.erreur_typeerreurid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.erreur_typeerreurid_seq OWNER TO mbuala;

--
-- Name: erreur_typeerreurid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public.erreur_typeerreurid_seq OWNED BY public.erreur.typeerreurid;


--
-- Name: piedpage; Type: TABLE; Schema: public; Owner: mbuala
--

CREATE TABLE public.piedpage (
    idpiedpage integer NOT NULL,
    nompied character varying(100) NOT NULL,
    path character varying(100) NOT NULL
);


ALTER TABLE public.piedpage OWNER TO mbuala;

--
-- Name: piedpage_idpiedpage_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public.piedpage_idpiedpage_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.piedpage_idpiedpage_seq OWNER TO mbuala;

--
-- Name: piedpage_idpiedpage_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public.piedpage_idpiedpage_seq OWNED BY public.piedpage.idpiedpage;


--
-- Name: signature; Type: TABLE; Schema: public; Owner: mbuala
--

CREATE TABLE public.signature (
    idsignature integer NOT NULL,
    nomsignature character varying(100) NOT NULL,
    path character varying(100) NOT NULL
);


ALTER TABLE public.signature OWNER TO mbuala;

--
-- Name: signature_idsignature_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public.signature_idsignature_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.signature_idsignature_seq OWNER TO mbuala;

--
-- Name: signature_idsignature_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public.signature_idsignature_seq OWNED BY public.signature.idsignature;


--
-- Name: typeerreur; Type: TABLE; Schema: public; Owner: mbuala
--

CREATE TABLE public.typeerreur (
    idtypeerreur integer NOT NULL,
    typeerreur character varying(100) NOT NULL,
    description character varying(100) NOT NULL
);


ALTER TABLE public.typeerreur OWNER TO mbuala;

--
-- Name: typeerreur_idtypeerreur_seq; Type: SEQUENCE; Schema: public; Owner: mbuala
--

CREATE SEQUENCE public.typeerreur_idtypeerreur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.typeerreur_idtypeerreur_seq OWNER TO mbuala;

--
-- Name: typeerreur_idtypeerreur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mbuala
--

ALTER SEQUENCE public.typeerreur_idtypeerreur_seq OWNED BY public.typeerreur.idtypeerreur;


--
-- Name: certificat idcertificat; Type: DEFAULT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.certificat ALTER COLUMN idcertificat SET DEFAULT nextval('public.certificat_idcertificat_seq'::regclass);


--
-- Name: compterendubox idcoompterendu; Type: DEFAULT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.compterendubox ALTER COLUMN idcoompterendu SET DEFAULT nextval('public.compterendubox_idcoompterendu_seq'::regclass);


--
-- Name: entetepage identete; Type: DEFAULT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.entetepage ALTER COLUMN identete SET DEFAULT nextval('public.entetepage_identete_seq'::regclass);


--
-- Name: erreur iderreur; Type: DEFAULT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.erreur ALTER COLUMN iderreur SET DEFAULT nextval('public.erreur_iderreur_seq'::regclass);


--
-- Name: erreur typeerreurid; Type: DEFAULT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.erreur ALTER COLUMN typeerreurid SET DEFAULT nextval('public.erreur_typeerreurid_seq'::regclass);


--
-- Name: piedpage idpiedpage; Type: DEFAULT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.piedpage ALTER COLUMN idpiedpage SET DEFAULT nextval('public.piedpage_idpiedpage_seq'::regclass);


--
-- Name: signature idsignature; Type: DEFAULT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.signature ALTER COLUMN idsignature SET DEFAULT nextval('public.signature_idsignature_seq'::regclass);


--
-- Name: typeerreur idtypeerreur; Type: DEFAULT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.typeerreur ALTER COLUMN idtypeerreur SET DEFAULT nextval('public.typeerreur_idtypeerreur_seq'::regclass);


--
-- Data for Name: certificat; Type: TABLE DATA; Schema: public; Owner: mbuala
--



--
-- Data for Name: compterendubox; Type: TABLE DATA; Schema: public; Owner: mbuala
--



--
-- Data for Name: entetepage; Type: TABLE DATA; Schema: public; Owner: mbuala
--

INSERT INTO public.entetepage VALUES (3, 'e', 'CALQUES/entete1.pdf');


--
-- Data for Name: erreur; Type: TABLE DATA; Schema: public; Owner: mbuala
--



--
-- Data for Name: piedpage; Type: TABLE DATA; Schema: public; Owner: mbuala
--



--
-- Data for Name: signature; Type: TABLE DATA; Schema: public; Owner: mbuala
--



--
-- Data for Name: typeerreur; Type: TABLE DATA; Schema: public; Owner: mbuala
--

INSERT INTO public.typeerreur VALUES (3, 'ERREUR3', 'Erreur insertion de calques');
INSERT INTO public.typeerreur VALUES (2, 'ERREUR2', 'Erreur les champs importants ne sont renseignés numeroDossier et nomPatient');
INSERT INTO public.typeerreur VALUES (5, 'ERREUR5', 'Erreur insertion données');
INSERT INTO public.typeerreur VALUES (1, 'ERREUR1', 'Erreur fichier non compatible Erreur de Conversion pdftotext	');
INSERT INTO public.typeerreur VALUES (4, 'ERREUR4', 'pdftotext errerr');


--
-- Name: certificat_idcertificat_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public.certificat_idcertificat_seq', 1, true);


--
-- Name: compterendubox_EmailMedecin_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public."compterendubox_EmailMedecin_seq"', 1, false);


--
-- Name: compterendubox_emailPatient_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public."compterendubox_emailPatient_seq"', 1, false);


--
-- Name: compterendubox_idcoompterendu_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public.compterendubox_idcoompterendu_seq', 1, true);


--
-- Name: compterendubox_prenomPatient_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public."compterendubox_prenomPatient_seq"', 1, false);


--
-- Name: entetepage_identete_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public.entetepage_identete_seq', 3, true);


--
-- Name: erreur_iderreur_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public.erreur_iderreur_seq', 1, true);


--
-- Name: erreur_typeerreurid_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public.erreur_typeerreurid_seq', 1, false);


--
-- Name: piedpage_idpiedpage_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public.piedpage_idpiedpage_seq', 1, true);


--
-- Name: signature_idsignature_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public.signature_idsignature_seq', 1, true);


--
-- Name: typeerreur_idtypeerreur_seq; Type: SEQUENCE SET; Schema: public; Owner: mbuala
--

SELECT pg_catalog.setval('public.typeerreur_idtypeerreur_seq', 7, true);


--
-- Name: certificat certificat_pkey; Type: CONSTRAINT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.certificat
    ADD CONSTRAINT certificat_pkey PRIMARY KEY (idcertificat);


--
-- Name: compterendubox compterendubox_pkey; Type: CONSTRAINT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.compterendubox
    ADD CONSTRAINT compterendubox_pkey PRIMARY KEY (idcoompterendu);


--
-- Name: entetepage entetepage_pkey; Type: CONSTRAINT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.entetepage
    ADD CONSTRAINT entetepage_pkey PRIMARY KEY (identete);


--
-- Name: erreur erreur_pkey; Type: CONSTRAINT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.erreur
    ADD CONSTRAINT erreur_pkey PRIMARY KEY (iderreur);


--
-- Name: piedpage piedpage_pkey; Type: CONSTRAINT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.piedpage
    ADD CONSTRAINT piedpage_pkey PRIMARY KEY (idpiedpage);


--
-- Name: signature signature_pkey; Type: CONSTRAINT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.signature
    ADD CONSTRAINT signature_pkey PRIMARY KEY (idsignature);


--
-- Name: typeerreur typeerreur_pkey; Type: CONSTRAINT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.typeerreur
    ADD CONSTRAINT typeerreur_pkey PRIMARY KEY (idtypeerreur);


--
-- Name: erreur erreur_typeerreurid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mbuala
--

ALTER TABLE ONLY public.erreur
    ADD CONSTRAINT erreur_typeerreurid_fkey FOREIGN KEY (typeerreurid) REFERENCES public.typeerreur(idtypeerreur);


--
-- PostgreSQL database dump complete
--

