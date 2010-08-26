--
-- PostgreSQL database dump
--

-- Started on 2010-08-26 20:01:53 CEST

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1508 (class 1259 OID 16456)
-- Dependencies: 3
-- Name: links_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE links_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.links_seq OWNER TO postgres;

--
-- TOC entry 1816 (class 0 OID 0)
-- Dependencies: 1508
-- Name: links_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('links_seq', 1, true);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1509 (class 1259 OID 16458)
-- Dependencies: 1790 3
-- Name: links; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE links (
    id integer DEFAULT nextval('links_seq'::regclass) NOT NULL,
    place integer NOT NULL,
    near_place integer NOT NULL
);


ALTER TABLE public.links OWNER TO postgres;

--
-- TOC entry 1504 (class 1259 OID 16420)
-- Dependencies: 3
-- Name: messages_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE messages_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.messages_seq OWNER TO postgres;

--
-- TOC entry 1817 (class 0 OID 0)
-- Dependencies: 1504
-- Name: messages_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('messages_seq', 19, true);


--
-- TOC entry 1505 (class 1259 OID 16422)
-- Dependencies: 1788 3
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE messages (
    id integer DEFAULT nextval('messages_seq'::regclass) NOT NULL,
    label character(25),
    text text NOT NULL
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 1506 (class 1259 OID 16443)
-- Dependencies: 3
-- Name: places_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE places_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.places_seq OWNER TO postgres;

--
-- TOC entry 1818 (class 0 OID 0)
-- Dependencies: 1506
-- Name: places_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('places_seq', 2, true);


--
-- TOC entry 1507 (class 1259 OID 16445)
-- Dependencies: 1789 3
-- Name: places; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE places (
    id integer DEFAULT nextval('places_seq'::regclass) NOT NULL,
    name character(50) NOT NULL,
    descr text NOT NULL
);


ALTER TABLE public.places OWNER TO postgres;

--
-- TOC entry 1502 (class 1259 OID 16385)
-- Dependencies: 3
-- Name: users_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.users_seq OWNER TO postgres;

--
-- TOC entry 1819 (class 0 OID 0)
-- Dependencies: 1502
-- Name: users_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_seq', 4, true);


--
-- TOC entry 1503 (class 1259 OID 16414)
-- Dependencies: 1787 3
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer DEFAULT nextval('users_seq'::regclass) NOT NULL,
    nick character(25) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 1810 (class 0 OID 16458)
-- Dependencies: 1509
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY links (id, place, near_place) FROM stdin;
1	1	2
\.


--
-- TOC entry 1808 (class 0 OID 16422)
-- Dependencies: 1505
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY messages (id, label, text) FROM stdin;
1	\N	non ho capito
2	\N	puoi ripetere?
3	gu_molti                 	ci sono
6	gu_uno                   	c'e'
7	gu                       	nella zona
9	rich_benv                	prima di ogni cosa un saluto e' doveroso!
8	benv                     	benvenuto...
10	up_true                  	ti sei alzato
12	up_false                 	sei gia' in piedi!
13	down_true                	ti sei adagiato per terra
16	down_false               	sei gia' per terra!
18	non_reg                  	il nuo nome non e' registrato!
19	pl                       	ti trovi nella
\.


--
-- TOC entry 1809 (class 0 OID 16445)
-- Dependencies: 1507
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY places (id, name, descr) FROM stdin;
1	valle della morte                                 	sei finito nel luogo piu remoto e desolato del regno...
2	canyon di fuoco                                   	poche sono le persone che sono sopravvissute a questo passo
\.


--
-- TOC entry 1807 (class 0 OID 16414)
-- Dependencies: 1503
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, nick) FROM stdin;
2	amati                    
3	prova                    
4	battista                 
\.


--
-- TOC entry 1804 (class 2606 OID 16463)
-- Dependencies: 1509 1509
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- TOC entry 1806 (class 2606 OID 16465)
-- Dependencies: 1509 1509 1509
-- Name: links_place_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_place_key UNIQUE (place, near_place);


--
-- TOC entry 1796 (class 2606 OID 16438)
-- Dependencies: 1505 1505
-- Name: messages_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_label_key UNIQUE (label);


--
-- TOC entry 1798 (class 2606 OID 16436)
-- Dependencies: 1505 1505
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 1800 (class 2606 OID 16455)
-- Dependencies: 1507 1507
-- Name: places_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_name_key UNIQUE (name);


--
-- TOC entry 1802 (class 2606 OID 16453)
-- Dependencies: 1507 1507
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- TOC entry 1792 (class 2606 OID 16442)
-- Dependencies: 1503 1503
-- Name: users_nick_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_nick_key UNIQUE (nick);


--
-- TOC entry 1794 (class 2606 OID 16440)
-- Dependencies: 1503 1503
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 1815 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2010-08-26 20:01:53 CEST

--
-- PostgreSQL database dump complete
--

