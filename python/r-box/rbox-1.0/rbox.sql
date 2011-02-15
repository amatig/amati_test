--
-- PostgreSQL database dump
--

-- Started on 2010-12-14 09:38:31 CET

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1555 (class 1259 OID 58591)
-- Dependencies: 3
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 1554 (class 1259 OID 58589)
-- Dependencies: 3 1555
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- TOC entry 2012 (class 0 OID 0)
-- Dependencies: 1554
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- TOC entry 2013 (class 0 OID 0)
-- Dependencies: 1554
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- TOC entry 1553 (class 1259 OID 58576)
-- Dependencies: 3
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 1552 (class 1259 OID 58574)
-- Dependencies: 1553 3
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 2014 (class 0 OID 0)
-- Dependencies: 1552
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- TOC entry 2015 (class 0 OID 0)
-- Dependencies: 1552
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 1563 (class 1259 OID 58656)
-- Dependencies: 3
-- Name: auth_message; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_message (
    id integer NOT NULL,
    user_id integer NOT NULL,
    message text NOT NULL
);


ALTER TABLE public.auth_message OWNER TO postgres;

--
-- TOC entry 1562 (class 1259 OID 58654)
-- Dependencies: 3 1563
-- Name: auth_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.auth_message_id_seq OWNER TO postgres;

--
-- TOC entry 2016 (class 0 OID 0)
-- Dependencies: 1562
-- Name: auth_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_message_id_seq OWNED BY auth_message.id;


--
-- TOC entry 2017 (class 0 OID 0)
-- Dependencies: 1562
-- Name: auth_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_message_id_seq', 1, false);


--
-- TOC entry 1551 (class 1259 OID 58566)
-- Dependencies: 3
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 1550 (class 1259 OID 58564)
-- Dependencies: 3 1551
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- TOC entry 2018 (class 0 OID 0)
-- Dependencies: 1550
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- TOC entry 2019 (class 0 OID 0)
-- Dependencies: 1550
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_permission_id_seq', 51, true);


--
-- TOC entry 1561 (class 1259 OID 58636)
-- Dependencies: 3
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    password character varying(128) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    is_superuser boolean NOT NULL,
    last_login timestamp with time zone NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 1559 (class 1259 OID 58621)
-- Dependencies: 3
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 1558 (class 1259 OID 58619)
-- Dependencies: 3 1559
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- TOC entry 2020 (class 0 OID 0)
-- Dependencies: 1558
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- TOC entry 2021 (class 0 OID 0)
-- Dependencies: 1558
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, false);


--
-- TOC entry 1560 (class 1259 OID 58634)
-- Dependencies: 3 1561
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgres;

--
-- TOC entry 2022 (class 0 OID 0)
-- Dependencies: 1560
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- TOC entry 2023 (class 0 OID 0)
-- Dependencies: 1560
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_id_seq', 1, true);


--
-- TOC entry 1557 (class 1259 OID 58606)
-- Dependencies: 3
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 1556 (class 1259 OID 58604)
-- Dependencies: 3 1557
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- TOC entry 2024 (class 0 OID 0)
-- Dependencies: 1556
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- TOC entry 2025 (class 0 OID 0)
-- Dependencies: 1556
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 1568 (class 1259 OID 58695)
-- Dependencies: 1871 3
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    content_type_id integer,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 1567 (class 1259 OID 58693)
-- Dependencies: 1568 3
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- TOC entry 2026 (class 0 OID 0)
-- Dependencies: 1567
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- TOC entry 2027 (class 0 OID 0)
-- Dependencies: 1567
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 1, false);


--
-- TOC entry 1565 (class 1259 OID 58672)
-- Dependencies: 3
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 1564 (class 1259 OID 58670)
-- Dependencies: 1565 3
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- TOC entry 2028 (class 0 OID 0)
-- Dependencies: 1564
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- TOC entry 2029 (class 0 OID 0)
-- Dependencies: 1564
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_content_type_id_seq', 17, true);


--
-- TOC entry 1566 (class 1259 OID 58685)
-- Dependencies: 3
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 1572 (class 1259 OID 58730)
-- Dependencies: 3
-- Name: rbox_dest; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_dest (
    id integer NOT NULL,
    label character varying(255) NOT NULL,
    ip inet NOT NULL,
    dtype_id character varying(30) NOT NULL,
    path character varying(255) NOT NULL,
    removed boolean NOT NULL,
    uname character varying(50) NOT NULL,
    passwd character varying(50) NOT NULL,
    remote_path character varying(255) NOT NULL
);


ALTER TABLE public.rbox_dest OWNER TO postgres;

--
-- TOC entry 1571 (class 1259 OID 58728)
-- Dependencies: 3 1572
-- Name: rbox_dest_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rbox_dest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.rbox_dest_id_seq OWNER TO postgres;

--
-- TOC entry 2030 (class 0 OID 0)
-- Dependencies: 1571
-- Name: rbox_dest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rbox_dest_id_seq OWNED BY rbox_dest.id;


--
-- TOC entry 2031 (class 0 OID 0)
-- Dependencies: 1571
-- Name: rbox_dest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('rbox_dest_id_seq', 1, false);


--
-- TOC entry 1570 (class 1259 OID 58723)
-- Dependencies: 3
-- Name: rbox_foldtype; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_foldtype (
    name character varying(30) NOT NULL,
    need_user boolean NOT NULL,
    need_passwd boolean NOT NULL,
    need_rpath boolean NOT NULL
);


ALTER TABLE public.rbox_foldtype OWNER TO postgres;

--
-- TOC entry 1584 (class 1259 OID 58844)
-- Dependencies: 3
-- Name: rbox_logrecord; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_logrecord (
    id integer NOT NULL,
    date timestamp with time zone NOT NULL,
    pid character varying(255) NOT NULL,
    level integer NOT NULL,
    msg text NOT NULL
);


ALTER TABLE public.rbox_logrecord OWNER TO postgres;

--
-- TOC entry 1583 (class 1259 OID 58842)
-- Dependencies: 3 1584
-- Name: rbox_logrecord_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rbox_logrecord_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.rbox_logrecord_id_seq OWNER TO postgres;

--
-- TOC entry 2032 (class 0 OID 0)
-- Dependencies: 1583
-- Name: rbox_logrecord_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rbox_logrecord_id_seq OWNED BY rbox_logrecord.id;


--
-- TOC entry 2033 (class 0 OID 0)
-- Dependencies: 1583
-- Name: rbox_logrecord_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('rbox_logrecord_id_seq', 1, false);


--
-- TOC entry 1575 (class 1259 OID 58759)
-- Dependencies: 1874 1875 3
-- Name: rbox_origin; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_origin (
    code character varying(6) NOT NULL,
    label character varying(255) NOT NULL,
    ip inet NOT NULL,
    otype_id character varying(30) NOT NULL,
    path character varying(255) NOT NULL,
    bc integer NOT NULL,
    tollerance integer NOT NULL,
    last_scan timestamp with time zone NOT NULL,
    removed boolean NOT NULL,
    uname character varying(50) NOT NULL,
    passwd character varying(50) NOT NULL,
    remote_path character varying(255) NOT NULL,
    CONSTRAINT rbox_origin_bc_check CHECK ((bc >= 0)),
    CONSTRAINT rbox_origin_tollerance_check CHECK ((tollerance >= 0))
);


ALTER TABLE public.rbox_origin OWNER TO postgres;

--
-- TOC entry 1574 (class 1259 OID 58748)
-- Dependencies: 3
-- Name: rbox_previous; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_previous (
    id integer NOT NULL,
    first character varying(15) NOT NULL,
    last character varying(15) NOT NULL,
    dest_id integer NOT NULL,
    manual boolean NOT NULL
);


ALTER TABLE public.rbox_previous OWNER TO postgres;

--
-- TOC entry 1573 (class 1259 OID 58746)
-- Dependencies: 1574 3
-- Name: rbox_previous_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rbox_previous_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.rbox_previous_id_seq OWNER TO postgres;

--
-- TOC entry 2034 (class 0 OID 0)
-- Dependencies: 1573
-- Name: rbox_previous_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rbox_previous_id_seq OWNED BY rbox_previous.id;


--
-- TOC entry 2035 (class 0 OID 0)
-- Dependencies: 1573
-- Name: rbox_previous_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('rbox_previous_id_seq', 1, false);


--
-- TOC entry 1576 (class 1259 OID 58776)
-- Dependencies: 1876 1877 3
-- Name: rbox_registration; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_registration (
    name character varying(15) NOT NULL,
    origin_id character varying(6) NOT NULL,
    cdt timestamp with time zone NOT NULL,
    xml_size integer NOT NULL,
    wav_size integer NOT NULL,
    CONSTRAINT rbox_registration_wav_size_check CHECK ((wav_size >= 0)),
    CONSTRAINT rbox_registration_xml_size_check CHECK ((xml_size >= 0))
);


ALTER TABLE public.rbox_registration OWNER TO postgres;

--
-- TOC entry 1578 (class 1259 OID 58790)
-- Dependencies: 1879 3
-- Name: rbox_route; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_route (
    id integer NOT NULL,
    label character varying(255) NOT NULL,
    origin_id character varying(6) NOT NULL,
    dest_id integer NOT NULL,
    start date NOT NULL,
    "end" date NOT NULL,
    rdate timestamp with time zone NOT NULL,
    state integer NOT NULL,
    removed boolean NOT NULL,
    CONSTRAINT rbox_route_state_check CHECK ((state >= 0))
);


ALTER TABLE public.rbox_route OWNER TO postgres;

--
-- TOC entry 1577 (class 1259 OID 58788)
-- Dependencies: 1578 3
-- Name: rbox_route_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rbox_route_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.rbox_route_id_seq OWNER TO postgres;

--
-- TOC entry 2036 (class 0 OID 0)
-- Dependencies: 1577
-- Name: rbox_route_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rbox_route_id_seq OWNED BY rbox_route.id;


--
-- TOC entry 2037 (class 0 OID 0)
-- Dependencies: 1577
-- Name: rbox_route_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('rbox_route_id_seq', 1, false);


--
-- TOC entry 1580 (class 1259 OID 58811)
-- Dependencies: 3
-- Name: rbox_schedule; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_schedule (
    id integer NOT NULL,
    route_id integer,
    s_start time without time zone NOT NULL,
    s_end time without time zone NOT NULL,
    force boolean NOT NULL,
    last_run date NOT NULL
);


ALTER TABLE public.rbox_schedule OWNER TO postgres;

--
-- TOC entry 1579 (class 1259 OID 58809)
-- Dependencies: 3 1580
-- Name: rbox_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rbox_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.rbox_schedule_id_seq OWNER TO postgres;

--
-- TOC entry 2038 (class 0 OID 0)
-- Dependencies: 1579
-- Name: rbox_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rbox_schedule_id_seq OWNED BY rbox_schedule.id;


--
-- TOC entry 2039 (class 0 OID 0)
-- Dependencies: 1579
-- Name: rbox_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('rbox_schedule_id_seq', 1, false);


--
-- TOC entry 1582 (class 1259 OID 58824)
-- Dependencies: 3
-- Name: rbox_schedulemove; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_schedulemove (
    id integer NOT NULL,
    registration_id character varying(15) NOT NULL,
    route_id integer NOT NULL,
    sdate timestamp with time zone NOT NULL,
    state integer NOT NULL
);


ALTER TABLE public.rbox_schedulemove OWNER TO postgres;

--
-- TOC entry 1581 (class 1259 OID 58822)
-- Dependencies: 1582 3
-- Name: rbox_schedulemove_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE rbox_schedulemove_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.rbox_schedulemove_id_seq OWNER TO postgres;

--
-- TOC entry 2040 (class 0 OID 0)
-- Dependencies: 1581
-- Name: rbox_schedulemove_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE rbox_schedulemove_id_seq OWNED BY rbox_schedulemove.id;


--
-- TOC entry 2041 (class 0 OID 0)
-- Dependencies: 1581
-- Name: rbox_schedulemove_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('rbox_schedulemove_id_seq', 1, false);


--
-- TOC entry 1569 (class 1259 OID 58715)
-- Dependencies: 3
-- Name: rbox_setting; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE rbox_setting (
    name character varying(25) NOT NULL,
    value text NOT NULL,
    editable boolean NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.rbox_setting OWNER TO postgres;

--
-- TOC entry 1864 (class 2604 OID 58594)
-- Dependencies: 1554 1555 1555
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- TOC entry 1863 (class 2604 OID 58579)
-- Dependencies: 1552 1553 1553
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 1868 (class 2604 OID 58659)
-- Dependencies: 1563 1562 1563
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_message ALTER COLUMN id SET DEFAULT nextval('auth_message_id_seq'::regclass);


--
-- TOC entry 1862 (class 2604 OID 58569)
-- Dependencies: 1550 1551 1551
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- TOC entry 1867 (class 2604 OID 58639)
-- Dependencies: 1561 1560 1561
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- TOC entry 1866 (class 2604 OID 58624)
-- Dependencies: 1559 1558 1559
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- TOC entry 1865 (class 2604 OID 58609)
-- Dependencies: 1557 1556 1557
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 1870 (class 2604 OID 58698)
-- Dependencies: 1568 1567 1568
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- TOC entry 1869 (class 2604 OID 58675)
-- Dependencies: 1565 1564 1565
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- TOC entry 1872 (class 2604 OID 58733)
-- Dependencies: 1572 1571 1572
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE rbox_dest ALTER COLUMN id SET DEFAULT nextval('rbox_dest_id_seq'::regclass);


--
-- TOC entry 1882 (class 2604 OID 58847)
-- Dependencies: 1583 1584 1584
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE rbox_logrecord ALTER COLUMN id SET DEFAULT nextval('rbox_logrecord_id_seq'::regclass);


--
-- TOC entry 1873 (class 2604 OID 58751)
-- Dependencies: 1573 1574 1574
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE rbox_previous ALTER COLUMN id SET DEFAULT nextval('rbox_previous_id_seq'::regclass);


--
-- TOC entry 1878 (class 2604 OID 58793)
-- Dependencies: 1577 1578 1578
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE rbox_route ALTER COLUMN id SET DEFAULT nextval('rbox_route_id_seq'::regclass);


--
-- TOC entry 1880 (class 2604 OID 58814)
-- Dependencies: 1579 1580 1580
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE rbox_schedule ALTER COLUMN id SET DEFAULT nextval('rbox_schedule_id_seq'::regclass);


--
-- TOC entry 1881 (class 2604 OID 58827)
-- Dependencies: 1581 1582 1582
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE rbox_schedulemove ALTER COLUMN id SET DEFAULT nextval('rbox_schedulemove_id_seq'::regclass);


--
-- TOC entry 1990 (class 0 OID 58591)
-- Dependencies: 1555
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 1989 (class 0 OID 58576)
-- Dependencies: 1553
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 1994 (class 0 OID 58656)
-- Dependencies: 1563
-- Data for Name: auth_message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_message (id, user_id, message) FROM stdin;
\.


--
-- TOC entry 1988 (class 0 OID 58566)
-- Dependencies: 1551
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add permission	1	add_permission
2	Can change permission	1	change_permission
3	Can delete permission	1	delete_permission
4	Can add group	2	add_group
5	Can change group	2	change_group
6	Can delete group	2	delete_group
7	Can add user	3	add_user
8	Can change user	3	change_user
9	Can delete user	3	delete_user
10	Can add message	4	add_message
11	Can change message	4	change_message
12	Can delete message	4	delete_message
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add log entry	7	add_logentry
20	Can change log entry	7	change_logentry
21	Can delete log entry	7	delete_logentry
22	Can add setting	8	add_setting
23	Can change setting	8	change_setting
24	Can delete setting	8	delete_setting
25	Can add foldtype	9	add_foldtype
26	Can change foldtype	9	change_foldtype
27	Can delete foldtype	9	delete_foldtype
28	Can add dest	10	add_dest
29	Can change dest	10	change_dest
30	Can delete dest	10	delete_dest
31	Can add Previous History	11	add_previous
32	Can change Previous History	11	change_previous
33	Can delete Previous History	11	delete_previous
34	Can add origin	12	add_origin
35	Can change origin	12	change_origin
36	Can delete origin	12	delete_origin
37	Can add registration	13	add_registration
38	Can change registration	13	change_registration
39	Can delete registration	13	delete_registration
40	Can add route	14	add_route
41	Can change route	14	change_route
42	Can delete route	14	delete_route
43	Can add schedule	15	add_schedule
44	Can change schedule	15	change_schedule
45	Can delete schedule	15	delete_schedule
46	Can add schedule move	16	add_schedulemove
47	Can change schedule move	16	change_schedulemove
48	Can delete schedule move	16	delete_schedulemove
49	Can add log record	17	add_logrecord
50	Can change log record	17	change_logrecord
51	Can delete log record	17	delete_logrecord
\.


--
-- TOC entry 1993 (class 0 OID 58636)
-- Dependencies: 1561
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user (id, username, first_name, last_name, email, password, is_staff, is_active, is_superuser, last_login, date_joined) FROM stdin;
1	admin			admin@mail.com	sha1$fa790$f584e8f7e1e13d9e48302fe3b4b9e430d7323366	t	t	t	2010-12-14 09:38:00.531192+01	2010-12-14 09:38:00.531192+01
\.


--
-- TOC entry 1992 (class 0 OID 58621)
-- Dependencies: 1559
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 1991 (class 0 OID 58606)
-- Dependencies: 1557
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 1997 (class 0 OID 58695)
-- Dependencies: 1568
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_admin_log (id, action_time, user_id, content_type_id, object_id, object_repr, action_flag, change_message) FROM stdin;
\.


--
-- TOC entry 1995 (class 0 OID 58672)
-- Dependencies: 1565
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_content_type (id, name, app_label, model) FROM stdin;
1	permission	auth	permission
2	group	auth	group
3	user	auth	user
4	message	auth	message
5	content type	contenttypes	contenttype
6	session	sessions	session
7	log entry	admin	logentry
8	setting	rbox	setting
9	foldtype	rbox	foldtype
10	dest	rbox	dest
11	Previous History	rbox	previous
12	origin	rbox	origin
13	registration	rbox	registration
14	route	rbox	route
15	schedule	rbox	schedule
16	schedule move	rbox	schedulemove
17	log record	rbox	logrecord
\.


--
-- TOC entry 1996 (class 0 OID 58685)
-- Dependencies: 1566
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- TOC entry 2000 (class 0 OID 58730)
-- Dependencies: 1572
-- Data for Name: rbox_dest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_dest (id, label, ip, dtype_id, path, removed, uname, passwd, remote_path) FROM stdin;
\.


--
-- TOC entry 1999 (class 0 OID 58723)
-- Dependencies: 1570
-- Data for Name: rbox_foldtype; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_foldtype (name, need_user, need_passwd, need_rpath) FROM stdin;
\.


--
-- TOC entry 2007 (class 0 OID 58844)
-- Dependencies: 1584
-- Data for Name: rbox_logrecord; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_logrecord (id, date, pid, level, msg) FROM stdin;
\.


--
-- TOC entry 2002 (class 0 OID 58759)
-- Dependencies: 1575
-- Data for Name: rbox_origin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_origin (code, label, ip, otype_id, path, bc, tollerance, last_scan, removed, uname, passwd, remote_path) FROM stdin;
\.


--
-- TOC entry 2001 (class 0 OID 58748)
-- Dependencies: 1574
-- Data for Name: rbox_previous; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_previous (id, first, last, dest_id, manual) FROM stdin;
\.


--
-- TOC entry 2003 (class 0 OID 58776)
-- Dependencies: 1576
-- Data for Name: rbox_registration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_registration (name, origin_id, cdt, xml_size, wav_size) FROM stdin;
\.


--
-- TOC entry 2004 (class 0 OID 58790)
-- Dependencies: 1578
-- Data for Name: rbox_route; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_route (id, label, origin_id, dest_id, start, "end", rdate, state, removed) FROM stdin;
\.


--
-- TOC entry 2005 (class 0 OID 58811)
-- Dependencies: 1580
-- Data for Name: rbox_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_schedule (id, route_id, s_start, s_end, force, last_run) FROM stdin;
\.


--
-- TOC entry 2006 (class 0 OID 58824)
-- Dependencies: 1582
-- Data for Name: rbox_schedulemove; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_schedulemove (id, registration_id, route_id, sdate, state) FROM stdin;
\.


--
-- TOC entry 1998 (class 0 OID 58715)
-- Dependencies: 1569
-- Data for Name: rbox_setting; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY rbox_setting (name, value, editable, description) FROM stdin;
\.


--
-- TOC entry 1895 (class 2606 OID 58598)
-- Dependencies: 1555 1555
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 1890 (class 2606 OID 58583)
-- Dependencies: 1553 1553 1553
-- Name: auth_group_permissions_group_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_key UNIQUE (group_id, permission_id);


--
-- TOC entry 1893 (class 2606 OID 58581)
-- Dependencies: 1553 1553
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 1897 (class 2606 OID 58596)
-- Dependencies: 1555 1555
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 1915 (class 2606 OID 58664)
-- Dependencies: 1563 1563
-- Name: auth_message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_message
    ADD CONSTRAINT auth_message_pkey PRIMARY KEY (id);


--
-- TOC entry 1885 (class 2606 OID 58573)
-- Dependencies: 1551 1551 1551
-- Name: auth_permission_content_type_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_key UNIQUE (content_type_id, codename);


--
-- TOC entry 1887 (class 2606 OID 58571)
-- Dependencies: 1551 1551
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 1906 (class 2606 OID 58626)
-- Dependencies: 1559 1559
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 1909 (class 2606 OID 58628)
-- Dependencies: 1559 1559 1559
-- Name: auth_user_groups_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_key UNIQUE (user_id, group_id);


--
-- TOC entry 1911 (class 2606 OID 58641)
-- Dependencies: 1561 1561
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 1900 (class 2606 OID 58611)
-- Dependencies: 1557 1557
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 1903 (class 2606 OID 58613)
-- Dependencies: 1557 1557 1557
-- Name: auth_user_user_permissions_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_key UNIQUE (user_id, permission_id);


--
-- TOC entry 1913 (class 2606 OID 58643)
-- Dependencies: 1561 1561
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 1925 (class 2606 OID 58704)
-- Dependencies: 1568 1568
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 1918 (class 2606 OID 58679)
-- Dependencies: 1565 1565 1565
-- Name: django_content_type_app_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_key UNIQUE (app_label, model);


--
-- TOC entry 1920 (class 2606 OID 58677)
-- Dependencies: 1565 1565
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 1922 (class 2606 OID 58692)
-- Dependencies: 1566 1566
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 1934 (class 2606 OID 58740)
-- Dependencies: 1572 1572
-- Name: rbox_dest_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_dest
    ADD CONSTRAINT rbox_dest_label_key UNIQUE (label);


--
-- TOC entry 1936 (class 2606 OID 58738)
-- Dependencies: 1572 1572
-- Name: rbox_dest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_dest
    ADD CONSTRAINT rbox_dest_pkey PRIMARY KEY (id);


--
-- TOC entry 1930 (class 2606 OID 58727)
-- Dependencies: 1570 1570
-- Name: rbox_foldtype_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_foldtype
    ADD CONSTRAINT rbox_foldtype_pkey PRIMARY KEY (name);


--
-- TOC entry 1968 (class 2606 OID 58852)
-- Dependencies: 1584 1584
-- Name: rbox_logrecord_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_logrecord
    ADD CONSTRAINT rbox_logrecord_pkey PRIMARY KEY (id);


--
-- TOC entry 1941 (class 2606 OID 58770)
-- Dependencies: 1575 1575
-- Name: rbox_origin_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_origin
    ADD CONSTRAINT rbox_origin_label_key UNIQUE (label);


--
-- TOC entry 1945 (class 2606 OID 58768)
-- Dependencies: 1575 1575
-- Name: rbox_origin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_origin
    ADD CONSTRAINT rbox_origin_pkey PRIMARY KEY (code);


--
-- TOC entry 1939 (class 2606 OID 58753)
-- Dependencies: 1574 1574
-- Name: rbox_previous_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_previous
    ADD CONSTRAINT rbox_previous_pkey PRIMARY KEY (id);


--
-- TOC entry 1949 (class 2606 OID 58782)
-- Dependencies: 1576 1576
-- Name: rbox_registration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_registration
    ADD CONSTRAINT rbox_registration_pkey PRIMARY KEY (name);


--
-- TOC entry 1952 (class 2606 OID 58798)
-- Dependencies: 1578 1578
-- Name: rbox_route_label_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_route
    ADD CONSTRAINT rbox_route_label_key UNIQUE (label);


--
-- TOC entry 1956 (class 2606 OID 58796)
-- Dependencies: 1578 1578
-- Name: rbox_route_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_route
    ADD CONSTRAINT rbox_route_pkey PRIMARY KEY (id);


--
-- TOC entry 1958 (class 2606 OID 58816)
-- Dependencies: 1580 1580
-- Name: rbox_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_schedule
    ADD CONSTRAINT rbox_schedule_pkey PRIMARY KEY (id);


--
-- TOC entry 1961 (class 2606 OID 58829)
-- Dependencies: 1582 1582
-- Name: rbox_schedulemove_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_schedulemove
    ADD CONSTRAINT rbox_schedulemove_pkey PRIMARY KEY (id);


--
-- TOC entry 1964 (class 2606 OID 58831)
-- Dependencies: 1582 1582 1582
-- Name: rbox_schedulemove_registration_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_schedulemove
    ADD CONSTRAINT rbox_schedulemove_registration_id_key UNIQUE (registration_id, route_id);


--
-- TOC entry 1928 (class 2606 OID 58722)
-- Dependencies: 1569 1569
-- Name: rbox_setting_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rbox_setting
    ADD CONSTRAINT rbox_setting_pkey PRIMARY KEY (name);


--
-- TOC entry 1888 (class 1259 OID 58854)
-- Dependencies: 1553
-- Name: auth_group_permissions_group_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_group_permissions_group_id ON auth_group_permissions USING btree (group_id);


--
-- TOC entry 1891 (class 1259 OID 58855)
-- Dependencies: 1553
-- Name: auth_group_permissions_permission_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_group_permissions_permission_id ON auth_group_permissions USING btree (permission_id);


--
-- TOC entry 1916 (class 1259 OID 58860)
-- Dependencies: 1563
-- Name: auth_message_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_message_user_id ON auth_message USING btree (user_id);


--
-- TOC entry 1883 (class 1259 OID 58853)
-- Dependencies: 1551
-- Name: auth_permission_content_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_permission_content_type_id ON auth_permission USING btree (content_type_id);


--
-- TOC entry 1904 (class 1259 OID 58859)
-- Dependencies: 1559
-- Name: auth_user_groups_group_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_groups_group_id ON auth_user_groups USING btree (group_id);


--
-- TOC entry 1907 (class 1259 OID 58858)
-- Dependencies: 1559
-- Name: auth_user_groups_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_groups_user_id ON auth_user_groups USING btree (user_id);


--
-- TOC entry 1898 (class 1259 OID 58857)
-- Dependencies: 1557
-- Name: auth_user_user_permissions_permission_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_permission_id ON auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 1901 (class 1259 OID 58856)
-- Dependencies: 1557
-- Name: auth_user_user_permissions_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_user_id ON auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 1923 (class 1259 OID 58862)
-- Dependencies: 1568
-- Name: django_admin_log_content_type_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX django_admin_log_content_type_id ON django_admin_log USING btree (content_type_id);


--
-- TOC entry 1926 (class 1259 OID 58861)
-- Dependencies: 1568
-- Name: django_admin_log_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX django_admin_log_user_id ON django_admin_log USING btree (user_id);


--
-- TOC entry 1931 (class 1259 OID 58863)
-- Dependencies: 1572
-- Name: rbox_dest_dtype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_dest_dtype_id ON rbox_dest USING btree (dtype_id);


--
-- TOC entry 1932 (class 1259 OID 58864)
-- Dependencies: 1572
-- Name: rbox_dest_dtype_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_dest_dtype_id_like ON rbox_dest USING btree (dtype_id varchar_pattern_ops);


--
-- TOC entry 1942 (class 1259 OID 58866)
-- Dependencies: 1575
-- Name: rbox_origin_otype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_origin_otype_id ON rbox_origin USING btree (otype_id);


--
-- TOC entry 1943 (class 1259 OID 58867)
-- Dependencies: 1575
-- Name: rbox_origin_otype_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_origin_otype_id_like ON rbox_origin USING btree (otype_id varchar_pattern_ops);


--
-- TOC entry 1937 (class 1259 OID 58865)
-- Dependencies: 1574
-- Name: rbox_previous_dest_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_previous_dest_id ON rbox_previous USING btree (dest_id);


--
-- TOC entry 1946 (class 1259 OID 58868)
-- Dependencies: 1576
-- Name: rbox_registration_origin_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_registration_origin_id ON rbox_registration USING btree (origin_id);


--
-- TOC entry 1947 (class 1259 OID 58869)
-- Dependencies: 1576
-- Name: rbox_registration_origin_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_registration_origin_id_like ON rbox_registration USING btree (origin_id varchar_pattern_ops);


--
-- TOC entry 1950 (class 1259 OID 58872)
-- Dependencies: 1578
-- Name: rbox_route_dest_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_route_dest_id ON rbox_route USING btree (dest_id);


--
-- TOC entry 1953 (class 1259 OID 58870)
-- Dependencies: 1578
-- Name: rbox_route_origin_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_route_origin_id ON rbox_route USING btree (origin_id);


--
-- TOC entry 1954 (class 1259 OID 58871)
-- Dependencies: 1578
-- Name: rbox_route_origin_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_route_origin_id_like ON rbox_route USING btree (origin_id varchar_pattern_ops);


--
-- TOC entry 1959 (class 1259 OID 58873)
-- Dependencies: 1580
-- Name: rbox_schedule_route_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_schedule_route_id ON rbox_schedule USING btree (route_id);


--
-- TOC entry 1962 (class 1259 OID 58874)
-- Dependencies: 1582
-- Name: rbox_schedulemove_registration_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_schedulemove_registration_id ON rbox_schedulemove USING btree (registration_id);


--
-- TOC entry 1965 (class 1259 OID 58875)
-- Dependencies: 1582
-- Name: rbox_schedulemove_registration_id_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_schedulemove_registration_id_like ON rbox_schedulemove USING btree (registration_id varchar_pattern_ops);


--
-- TOC entry 1966 (class 1259 OID 58876)
-- Dependencies: 1582
-- Name: rbox_schedulemove_route_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX rbox_schedulemove_route_id ON rbox_schedulemove USING btree (route_id);


--
-- TOC entry 1970 (class 2606 OID 58584)
-- Dependencies: 1551 1553 1886
-- Name: auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1976 (class 2606 OID 58665)
-- Dependencies: 1563 1561 1910
-- Name: auth_message_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_message
    ADD CONSTRAINT auth_message_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1974 (class 2606 OID 58629)
-- Dependencies: 1559 1555 1896
-- Name: auth_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1972 (class 2606 OID 58614)
-- Dependencies: 1551 1557 1886
-- Name: auth_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1969 (class 2606 OID 58680)
-- Dependencies: 1565 1919 1551
-- Name: content_type_id_refs_id_728de91f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT content_type_id_refs_id_728de91f FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1978 (class 2606 OID 58710)
-- Dependencies: 1565 1919 1568
-- Name: django_admin_log_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1977 (class 2606 OID 58705)
-- Dependencies: 1910 1568 1561
-- Name: django_admin_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1971 (class 2606 OID 58599)
-- Dependencies: 1896 1555 1553
-- Name: group_id_refs_id_3cea63fe; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT group_id_refs_id_3cea63fe FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1979 (class 2606 OID 58741)
-- Dependencies: 1572 1929 1570
-- Name: rbox_dest_dtype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_dest
    ADD CONSTRAINT rbox_dest_dtype_id_fkey FOREIGN KEY (dtype_id) REFERENCES rbox_foldtype(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1981 (class 2606 OID 58771)
-- Dependencies: 1575 1929 1570
-- Name: rbox_origin_otype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_origin
    ADD CONSTRAINT rbox_origin_otype_id_fkey FOREIGN KEY (otype_id) REFERENCES rbox_foldtype(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1980 (class 2606 OID 58754)
-- Dependencies: 1574 1935 1572
-- Name: rbox_previous_dest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_previous
    ADD CONSTRAINT rbox_previous_dest_id_fkey FOREIGN KEY (dest_id) REFERENCES rbox_dest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1982 (class 2606 OID 58783)
-- Dependencies: 1944 1575 1576
-- Name: rbox_registration_origin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_registration
    ADD CONSTRAINT rbox_registration_origin_id_fkey FOREIGN KEY (origin_id) REFERENCES rbox_origin(code) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1984 (class 2606 OID 58804)
-- Dependencies: 1578 1935 1572
-- Name: rbox_route_dest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_route
    ADD CONSTRAINT rbox_route_dest_id_fkey FOREIGN KEY (dest_id) REFERENCES rbox_dest(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1983 (class 2606 OID 58799)
-- Dependencies: 1944 1578 1575
-- Name: rbox_route_origin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_route
    ADD CONSTRAINT rbox_route_origin_id_fkey FOREIGN KEY (origin_id) REFERENCES rbox_origin(code) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1985 (class 2606 OID 58817)
-- Dependencies: 1580 1955 1578
-- Name: rbox_schedule_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_schedule
    ADD CONSTRAINT rbox_schedule_route_id_fkey FOREIGN KEY (route_id) REFERENCES rbox_route(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1986 (class 2606 OID 58832)
-- Dependencies: 1582 1576 1948
-- Name: rbox_schedulemove_registration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_schedulemove
    ADD CONSTRAINT rbox_schedulemove_registration_id_fkey FOREIGN KEY (registration_id) REFERENCES rbox_registration(name) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1987 (class 2606 OID 58837)
-- Dependencies: 1582 1955 1578
-- Name: rbox_schedulemove_route_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY rbox_schedulemove
    ADD CONSTRAINT rbox_schedulemove_route_id_fkey FOREIGN KEY (route_id) REFERENCES rbox_route(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1975 (class 2606 OID 58649)
-- Dependencies: 1561 1910 1559
-- Name: user_id_refs_id_7ceef80f; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT user_id_refs_id_7ceef80f FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 1973 (class 2606 OID 58644)
-- Dependencies: 1557 1561 1910
-- Name: user_id_refs_id_dfbab7d; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT user_id_refs_id_dfbab7d FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 2011 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2010-12-14 09:38:32 CET

--
-- PostgreSQL database dump complete
--

