--
-- PostgreSQL database dump
--

-- Started on 2008-04-22 17:23:29 PET

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 1695 (class 1262 OID 16385)
-- Name: AcademicDB; Type: DATABASE; Schema: -; Owner: academic
--

CREATE DATABASE "AcademicDB" WITH TEMPLATE = template0 ENCODING = 'UTF8';

ALTER DATABASE "AcademicDB" OWNER TO academic;


SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 1696 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1292 (class 1259 OID 24615)
-- Dependencies: 4
-- Name: dependence; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE dependence (
    id_dependence integer NOT NULL,
    name character varying,
    acronym character varying(10),
    id_parent integer
);


ALTER TABLE public.dependence OWNER TO academic;

--
-- TOC entry 1698 (class 0 OID 0)
-- Dependencies: 1292
-- Name: COLUMN dependence.id_dependence; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN dependence.id_dependence IS 'id of this dependence';


--
-- TOC entry 1699 (class 0 OID 0)
-- Dependencies: 1292
-- Name: COLUMN dependence.name; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN dependence.name IS 'name of this area';


--
-- TOC entry 1700 (class 0 OID 0)
-- Dependencies: 1292
-- Name: COLUMN dependence.acronym; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN dependence.acronym IS 'acronym of this area (sigla)';


--
-- TOC entry 1701 (class 0 OID 0)
-- Dependencies: 1292
-- Name: COLUMN dependence.id_parent; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN dependence.id_parent IS 'id of its parent';


--
-- TOC entry 1291 (class 1259 OID 24613)
-- Dependencies: 4 1292
-- Name: area_id_area_seq; Type: SEQUENCE; Schema: public; Owner: academic
--

CREATE SEQUENCE area_id_area_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.area_id_area_seq OWNER TO academic;

--
-- TOC entry 1702 (class 0 OID 0)
-- Dependencies: 1291
-- Name: area_id_area_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: academic
--

ALTER SEQUENCE area_id_area_seq OWNED BY dependence.id_dependence;


--
-- TOC entry 1703 (class 0 OID 0)
-- Dependencies: 1291
-- Name: area_id_area_seq; Type: SEQUENCE SET; Schema: public; Owner: academic
--

SELECT pg_catalog.setval('area_id_area_seq', 1, false);


--
-- TOC entry 1308 (class 1259 OID 32816)
-- Dependencies: 4
-- Name: assigment; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE assigment (
    id_assigment integer NOT NULL,
    id_course integer,
    id_plan integer,
    id_user integer
);


ALTER TABLE public.assigment OWNER TO academic;

--
-- TOC entry 1704 (class 0 OID 0)
-- Dependencies: 1308
-- Name: TABLE assigment; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON TABLE assigment IS 'relation between professors and courses';


--
-- TOC entry 1705 (class 0 OID 0)
-- Dependencies: 1308
-- Name: COLUMN assigment.id_assigment; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN assigment.id_assigment IS 'Assigment';


--
-- TOC entry 1706 (class 0 OID 0)
-- Dependencies: 1308
-- Name: COLUMN assigment.id_course; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN assigment.id_course IS 'id course';


--
-- TOC entry 1707 (class 0 OID 0)
-- Dependencies: 1308
-- Name: COLUMN assigment.id_plan; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN assigment.id_plan IS 'id plan';


--
-- TOC entry 1708 (class 0 OID 0)
-- Dependencies: 1308
-- Name: COLUMN assigment.id_user; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN assigment.id_user IS 'id user (profesor)';


--
-- TOC entry 1307 (class 1259 OID 32814)
-- Dependencies: 4 1308
-- Name: assigment_id_assigment_seq; Type: SEQUENCE; Schema: public; Owner: academic
--

CREATE SEQUENCE assigment_id_assigment_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.assigment_id_assigment_seq OWNER TO academic;

--
-- TOC entry 1709 (class 0 OID 0)
-- Dependencies: 1307
-- Name: assigment_id_assigment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: academic
--

ALTER SEQUENCE assigment_id_assigment_seq OWNED BY assigment.id_assigment;


--
-- TOC entry 1710 (class 0 OID 0)
-- Dependencies: 1307
-- Name: assigment_id_assigment_seq; Type: SEQUENCE SET; Schema: public; Owner: academic
--

SELECT pg_catalog.setval('assigment_id_assigment_seq', 1, false);


--
-- TOC entry 1302 (class 1259 OID 32770)
-- Dependencies: 4
-- Name: course; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE course (
    id_course integer NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.course OWNER TO academic;

--
-- TOC entry 1711 (class 0 OID 0)
-- Dependencies: 1302
-- Name: TABLE course; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON TABLE course IS 'List of courses';


--
-- TOC entry 1712 (class 0 OID 0)
-- Dependencies: 1302
-- Name: COLUMN course.id_course; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN course.id_course IS 'Id of this course';


--
-- TOC entry 1713 (class 0 OID 0)
-- Dependencies: 1302
-- Name: COLUMN course.code; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN course.code IS 'code of this course (i.e. CS101F)';


--
-- TOC entry 1714 (class 0 OID 0)
-- Dependencies: 1302
-- Name: COLUMN course.name; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN course.name IS 'Name of this course';


--
-- TOC entry 1301 (class 1259 OID 32768)
-- Dependencies: 1302 4
-- Name: course_id_course_seq; Type: SEQUENCE; Schema: public; Owner: academic
--

CREATE SEQUENCE course_id_course_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.course_id_course_seq OWNER TO academic;

--
-- TOC entry 1715 (class 0 OID 0)
-- Dependencies: 1301
-- Name: course_id_course_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: academic
--

ALTER SEQUENCE course_id_course_seq OWNED BY course.id_course;


--
-- TOC entry 1716 (class 0 OID 0)
-- Dependencies: 1301
-- Name: course_id_course_seq; Type: SEQUENCE SET; Schema: public; Owner: academic
--

SELECT pg_catalog.setval('course_id_course_seq', 1, false);


--
-- TOC entry 1295 (class 1259 OID 24641)
-- Dependencies: 1642 4 1292
-- Name: department; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE department (
)
INHERITS (dependence);


ALTER TABLE public.department OWNER TO academic;

--
-- TOC entry 1717 (class 0 OID 0)
-- Dependencies: 1295
-- Name: TABLE department; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON TABLE department IS 'list of departments';


--
-- TOC entry 1294 (class 1259 OID 24635)
-- Dependencies: 1641 4 1292
-- Name: facultad; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE facultad (
)
INHERITS (dependence);


ALTER TABLE public.facultad OWNER TO academic;

--
-- TOC entry 1718 (class 0 OID 0)
-- Dependencies: 1294
-- Name: TABLE facultad; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON TABLE facultad IS 'list of facultad';


--
-- TOC entry 1293 (class 1259 OID 24629)
-- Dependencies: 1640 4 1292
-- Name: institution; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE institution (
    ubigeo character varying(6) NOT NULL
)
INHERITS (dependence);


ALTER TABLE public.institution OWNER TO academic;

--
-- TOC entry 1719 (class 0 OID 0)
-- Dependencies: 1293
-- Name: TABLE institution; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON TABLE institution IS 'list of institutions';


--
-- TOC entry 1720 (class 0 OID 0)
-- Dependencies: 1293
-- Name: COLUMN institution.ubigeo; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN institution.ubigeo IS 'Geographical location';


--
-- TOC entry 1304 (class 1259 OID 32777)
-- Dependencies: 4
-- Name: outcome; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE outcome (
    id_outcome integer NOT NULL,
    description character varying NOT NULL,
    id_plan integer
);


ALTER TABLE public.outcome OWNER TO academic;

--
-- TOC entry 1721 (class 0 OID 0)
-- Dependencies: 1304
-- Name: COLUMN outcome.id_outcome; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN outcome.id_outcome IS 'if of this outcome';


--
-- TOC entry 1722 (class 0 OID 0)
-- Dependencies: 1304
-- Name: COLUMN outcome.description; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN outcome.description IS 'description of this outcome';


--
-- TOC entry 1303 (class 1259 OID 32775)
-- Dependencies: 1304 4
-- Name: outcome_id_outcome_seq; Type: SEQUENCE; Schema: public; Owner: academic
--

CREATE SEQUENCE outcome_id_outcome_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.outcome_id_outcome_seq OWNER TO academic;

--
-- TOC entry 1723 (class 0 OID 0)
-- Dependencies: 1303
-- Name: outcome_id_outcome_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: academic
--

ALTER SEQUENCE outcome_id_outcome_seq OWNED BY outcome.id_outcome;


--
-- TOC entry 1724 (class 0 OID 0)
-- Dependencies: 1303
-- Name: outcome_id_outcome_seq; Type: SEQUENCE SET; Schema: public; Owner: academic
--

SELECT pg_catalog.setval('outcome_id_outcome_seq', 1, false);


--
-- TOC entry 1298 (class 1259 OID 24655)
-- Dependencies: 4
-- Name: plan; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE plan (
    id_plan integer NOT NULL,
    name character varying,
    description character varying,
    id_school integer NOT NULL
);


ALTER TABLE public.plan OWNER TO academic;

--
-- TOC entry 1725 (class 0 OID 0)
-- Dependencies: 1298
-- Name: COLUMN plan.id_plan; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan.id_plan IS 'id of this plan';


--
-- TOC entry 1726 (class 0 OID 0)
-- Dependencies: 1298
-- Name: COLUMN plan.name; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan.name IS '2006, 2001';


--
-- TOC entry 1727 (class 0 OID 0)
-- Dependencies: 1298
-- Name: COLUMN plan.description; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan.description IS 'more specific information about this plan';


--
-- TOC entry 1728 (class 0 OID 0)
-- Dependencies: 1298
-- Name: COLUMN plan.id_school; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan.id_school IS 'id of the school it belongs to';


--
-- TOC entry 1305 (class 1259 OID 32791)
-- Dependencies: 4
-- Name: plan_course; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE plan_course (
    id_course integer NOT NULL,
    id_plan integer NOT NULL,
    ht smallint,
    hp smallint,
    hl abstime,
    "type" character(1),
    semester smallint,
    alias character varying(10)
);


ALTER TABLE public.plan_course OWNER TO academic;

--
-- TOC entry 1729 (class 0 OID 0)
-- Dependencies: 1305
-- Name: TABLE plan_course; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON TABLE plan_course IS 'Relation between Course ann Plan';


--
-- TOC entry 1730 (class 0 OID 0)
-- Dependencies: 1305
-- Name: COLUMN plan_course.id_course; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan_course.id_course IS 'course ID';


--
-- TOC entry 1731 (class 0 OID 0)
-- Dependencies: 1305
-- Name: COLUMN plan_course.id_plan; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan_course.id_plan IS 'plans id';


--
-- TOC entry 1732 (class 0 OID 0)
-- Dependencies: 1305
-- Name: COLUMN plan_course.ht; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan_course.ht IS 'Theory hours';


--
-- TOC entry 1733 (class 0 OID 0)
-- Dependencies: 1305
-- Name: COLUMN plan_course.hp; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan_course.hp IS 'Practice Hours';


--
-- TOC entry 1734 (class 0 OID 0)
-- Dependencies: 1305
-- Name: COLUMN plan_course.hl; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan_course.hl IS 'Lab Hours';


--
-- TOC entry 1735 (class 0 OID 0)
-- Dependencies: 1305
-- Name: COLUMN plan_course."type"; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan_course."type" IS 'type of this course (Obligatorio, Electivo)';


--
-- TOC entry 1736 (class 0 OID 0)
-- Dependencies: 1305
-- Name: COLUMN plan_course.semester; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan_course.semester IS 'semester of this course';


--
-- TOC entry 1737 (class 0 OID 0)
-- Dependencies: 1305
-- Name: COLUMN plan_course.alias; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN plan_course.alias IS 'alias for this cour in this plan';


--
-- TOC entry 1297 (class 1259 OID 24653)
-- Dependencies: 4 1298
-- Name: plan_id_plan_seq; Type: SEQUENCE; Schema: public; Owner: academic
--

CREATE SEQUENCE plan_id_plan_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.plan_id_plan_seq OWNER TO academic;

--
-- TOC entry 1738 (class 0 OID 0)
-- Dependencies: 1297
-- Name: plan_id_plan_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: academic
--

ALTER SEQUENCE plan_id_plan_seq OWNED BY plan.id_plan;


--
-- TOC entry 1739 (class 0 OID 0)
-- Dependencies: 1297
-- Name: plan_id_plan_seq; Type: SEQUENCE SET; Schema: public; Owner: academic
--

SELECT pg_catalog.setval('plan_id_plan_seq', 1, false);


--
-- TOC entry 1296 (class 1259 OID 24647)
-- Dependencies: 1643 4 1292
-- Name: school; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE school (
)
INHERITS (dependence);


ALTER TABLE public.school OWNER TO academic;

--
-- TOC entry 1740 (class 0 OID 0)
-- Dependencies: 1296
-- Name: TABLE school; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON TABLE school IS 'list of schools';


--
-- TOC entry 1306 (class 1259 OID 32795)
-- Dependencies: 4
-- Name: type_course; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE type_course (
    "type" character(1) NOT NULL,
    description character varying
);


ALTER TABLE public.type_course OWNER TO academic;

--
-- TOC entry 1741 (class 0 OID 0)
-- Dependencies: 1306
-- Name: COLUMN type_course."type"; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN type_course."type" IS 'E, O';


--
-- TOC entry 1742 (class 0 OID 0)
-- Dependencies: 1306
-- Name: COLUMN type_course.description; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN type_course.description IS 'Obligatorio, Electivo';


--
-- TOC entry 1300 (class 1259 OID 24681)
-- Dependencies: 4
-- Name: user; Type: TABLE; Schema: public; Owner: academic; Tablespace: 
--

CREATE TABLE "user" (
    id_user integer NOT NULL,
    name character varying(40) NOT NULL,
    lastname character varying(30) NOT NULL,
    email character varying(30) NOT NULL
);


ALTER TABLE public."user" OWNER TO academic;

--
-- TOC entry 1743 (class 0 OID 0)
-- Dependencies: 1300
-- Name: COLUMN "user".id_user; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN "user".id_user IS 'id of this user';


--
-- TOC entry 1744 (class 0 OID 0)
-- Dependencies: 1300
-- Name: COLUMN "user".name; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN "user".name IS 'name of this user';


--
-- TOC entry 1745 (class 0 OID 0)
-- Dependencies: 1300
-- Name: COLUMN "user".lastname; Type: COMMENT; Schema: public; Owner: academic
--

COMMENT ON COLUMN "user".lastname IS 'last name of this user';


--
-- TOC entry 1299 (class 1259 OID 24679)
-- Dependencies: 4 1300
-- Name: user_id_user_seq; Type: SEQUENCE; Schema: public; Owner: academic
--

CREATE SEQUENCE user_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_id_user_seq OWNER TO academic;

--
-- TOC entry 1746 (class 0 OID 0)
-- Dependencies: 1299
-- Name: user_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: academic
--

ALTER SEQUENCE user_id_user_seq OWNED BY "user".id_user;


--
-- TOC entry 1747 (class 0 OID 0)
-- Dependencies: 1299
-- Name: user_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: academic
--

SELECT pg_catalog.setval('user_id_user_seq', 1, false);


--
-- TOC entry 1648 (class 2604 OID 32818)
-- Dependencies: 1308 1307 1308
-- Name: id_assigment; Type: DEFAULT; Schema: public; Owner: academic
--

ALTER TABLE assigment ALTER COLUMN id_assigment SET DEFAULT nextval('assigment_id_assigment_seq'::regclass);


--
-- TOC entry 1646 (class 2604 OID 32772)
-- Dependencies: 1301 1302 1302
-- Name: id_course; Type: DEFAULT; Schema: public; Owner: academic
--

ALTER TABLE course ALTER COLUMN id_course SET DEFAULT nextval('course_id_course_seq'::regclass);


--
-- TOC entry 1639 (class 2604 OID 24617)
-- Dependencies: 1292 1291 1292
-- Name: id_dependence; Type: DEFAULT; Schema: public; Owner: academic
--

ALTER TABLE dependence ALTER COLUMN id_dependence SET DEFAULT nextval('area_id_area_seq'::regclass);


--
-- TOC entry 1647 (class 2604 OID 32779)
-- Dependencies: 1303 1304 1304
-- Name: id_outcome; Type: DEFAULT; Schema: public; Owner: academic
--

ALTER TABLE outcome ALTER COLUMN id_outcome SET DEFAULT nextval('outcome_id_outcome_seq'::regclass);


--
-- TOC entry 1644 (class 2604 OID 24657)
-- Dependencies: 1298 1297 1298
-- Name: id_plan; Type: DEFAULT; Schema: public; Owner: academic
--

ALTER TABLE plan ALTER COLUMN id_plan SET DEFAULT nextval('plan_id_plan_seq'::regclass);


--
-- TOC entry 1645 (class 2604 OID 24683)
-- Dependencies: 1300 1299 1300
-- Name: id_user; Type: DEFAULT; Schema: public; Owner: academic
--

ALTER TABLE "user" ALTER COLUMN id_user SET DEFAULT nextval('user_id_user_seq'::regclass);


--
-- TOC entry 1692 (class 0 OID 32816)
-- Dependencies: 1308
-- Data for Name: assigment; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY assigment (id_assigment, id_course, id_plan, id_user) FROM stdin;


--
-- TOC entry 1688 (class 0 OID 32770)
-- Dependencies: 1302
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY course (id_course, code, name) FROM stdin;



--
-- TOC entry 1684 (class 0 OID 24641)
-- Dependencies: 1295
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY department (id_dependence, name, acronym, id_parent) FROM stdin;



--
-- TOC entry 1681 (class 0 OID 24615)
-- Dependencies: 1292
-- Data for Name: dependence; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY dependence (id_dependence, name, acronym, id_parent) FROM stdin;



--
-- TOC entry 1683 (class 0 OID 24635)
-- Dependencies: 1294
-- Data for Name: facultad; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY facultad (id_dependence, name, acronym, id_parent) FROM stdin;



--
-- TOC entry 1682 (class 0 OID 24629)
-- Dependencies: 1293
-- Data for Name: institution; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY institution (id_dependence, name, acronym, id_parent, ubigeo) FROM stdin;



--
-- TOC entry 1689 (class 0 OID 32777)
-- Dependencies: 1304
-- Data for Name: outcome; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY outcome (id_outcome, description, id_plan) FROM stdin;



--
-- TOC entry 1686 (class 0 OID 24655)
-- Dependencies: 1298
-- Data for Name: plan; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY plan (id_plan, name, description, id_school) FROM stdin;



--
-- TOC entry 1690 (class 0 OID 32791)
-- Dependencies: 1305
-- Data for Name: plan_course; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY plan_course (id_course, id_plan, ht, hp, hl, "type", semester, alias) FROM stdin;



--
-- TOC entry 1685 (class 0 OID 24647)
-- Dependencies: 1296
-- Data for Name: school; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY school (id_dependence, name, acronym, id_parent) FROM stdin;



--
-- TOC entry 1691 (class 0 OID 32795)
-- Dependencies: 1306
-- Data for Name: type_course; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY type_course ("type", description) FROM stdin;



--
-- TOC entry 1687 (class 0 OID 24681)
-- Dependencies: 1300
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: academic
--

COPY "user" (id_user, name, lastname, email) FROM stdin;



--
-- TOC entry 1673 (class 2606 OID 32822)
-- Dependencies: 1308 1308 1308 1308
-- Name: assigment_id_course_key; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY assigment
    ADD CONSTRAINT assigment_id_course_key UNIQUE (id_course, id_plan, id_user);


--
-- TOC entry 1675 (class 2606 OID 32820)
-- Dependencies: 1308 1308
-- Name: assigment_pkey; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY assigment
    ADD CONSTRAINT assigment_pkey PRIMARY KEY (id_assigment);


--
-- TOC entry 1651 (class 2606 OID 24622)
-- Dependencies: 1292 1292
-- Name: id_area; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY dependence
    ADD CONSTRAINT id_area PRIMARY KEY (id_dependence);


--
-- TOC entry 1661 (class 2606 OID 32774)
-- Dependencies: 1302 1302
-- Name: id_course; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY course
    ADD CONSTRAINT id_course PRIMARY KEY (id_course);


--
-- TOC entry 1653 (class 2606 OID 24672)
-- Dependencies: 1292 1292
-- Name: id_dependence; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY dependence
    ADD CONSTRAINT id_dependence UNIQUE (id_dependence);


--
-- TOC entry 1664 (class 2606 OID 32784)
-- Dependencies: 1304 1304
-- Name: id_outcome; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY outcome
    ADD CONSTRAINT id_outcome PRIMARY KEY (id_outcome);


--
-- TOC entry 1657 (class 2606 OID 24662)
-- Dependencies: 1298 1298
-- Name: id_plan; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY plan
    ADD CONSTRAINT id_plan PRIMARY KEY (id_plan);


--
-- TOC entry 1659 (class 2606 OID 24685)
-- Dependencies: 1300 1300
-- Name: id_user; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT id_user PRIMARY KEY (id_user);


--
-- TOC entry 1669 (class 2606 OID 32794)
-- Dependencies: 1305 1305 1305
-- Name: pk_plan_course; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY plan_course
    ADD CONSTRAINT pk_plan_course PRIMARY KEY (id_course, id_plan);


--
-- TOC entry 1671 (class 2606 OID 32801)
-- Dependencies: 1306 1306
-- Name: type; Type: CONSTRAINT; Schema: public; Owner: academic; Tablespace: 
--

ALTER TABLE ONLY type_course
    ADD CONSTRAINT "type" PRIMARY KEY ("type");


--
-- TOC entry 1665 (class 1259 OID 32839)
-- Dependencies: 1305
-- Name: fki_course; Type: INDEX; Schema: public; Owner: academic; Tablespace: 
--

CREATE INDEX fki_course ON plan_course USING btree (id_course);


--
-- TOC entry 1654 (class 1259 OID 24678)
-- Dependencies: 1298
-- Name: fki_id_dependence; Type: INDEX; Schema: public; Owner: academic; Tablespace: 
--

CREATE INDEX fki_id_dependence ON plan USING btree (id_school);


--
-- TOC entry 1649 (class 1259 OID 24628)
-- Dependencies: 1292
-- Name: fki_id_parent; Type: INDEX; Schema: public; Owner: academic; Tablespace: 
--

CREATE INDEX fki_id_parent ON dependence USING btree (id_parent);


--
-- TOC entry 1662 (class 1259 OID 32790)
-- Dependencies: 1304
-- Name: fki_id_plan; Type: INDEX; Schema: public; Owner: academic; Tablespace: 
--

CREATE INDEX fki_id_plan ON outcome USING btree (id_plan);


--
-- TOC entry 1655 (class 1259 OID 24670)
-- Dependencies: 1298
-- Name: fki_id_school; Type: INDEX; Schema: public; Owner: academic; Tablespace: 
--

CREATE INDEX fki_id_school ON plan USING btree (id_school);


--
-- TOC entry 1666 (class 1259 OID 32813)
-- Dependencies: 1305
-- Name: fki_type; Type: INDEX; Schema: public; Owner: academic; Tablespace: 
--

CREATE INDEX fki_type ON plan_course USING btree ("type");


--
-- TOC entry 1667 (class 1259 OID 32807)
-- Dependencies: 1305
-- Name: fki_type_course; Type: INDEX; Schema: public; Owner: academic; Tablespace: 
--

CREATE INDEX fki_type_course ON plan_course USING btree ("type");


--
-- TOC entry 1680 (class 2606 OID 32834)
-- Dependencies: 1660 1305 1302
-- Name: course; Type: FK CONSTRAINT; Schema: public; Owner: academic
--

ALTER TABLE ONLY plan_course
    ADD CONSTRAINT course FOREIGN KEY (id_course) REFERENCES course(id_course);


--
-- TOC entry 1677 (class 2606 OID 24673)
-- Dependencies: 1292 1298 1650
-- Name: id_dependence; Type: FK CONSTRAINT; Schema: public; Owner: academic
--

ALTER TABLE ONLY plan
    ADD CONSTRAINT id_dependence FOREIGN KEY (id_school) REFERENCES dependence(id_dependence);


--
-- TOC entry 1676 (class 2606 OID 24623)
-- Dependencies: 1292 1292 1650
-- Name: id_parent; Type: FK CONSTRAINT; Schema: public; Owner: academic
--

ALTER TABLE ONLY dependence
    ADD CONSTRAINT id_parent FOREIGN KEY (id_parent) REFERENCES dependence(id_dependence) ON DELETE CASCADE;


--
-- TOC entry 1678 (class 2606 OID 32785)
-- Dependencies: 1656 1298 1304
-- Name: id_plan; Type: FK CONSTRAINT; Schema: public; Owner: academic
--

ALTER TABLE ONLY outcome
    ADD CONSTRAINT id_plan FOREIGN KEY (id_plan) REFERENCES plan(id_plan);


--
-- TOC entry 1679 (class 2606 OID 32808)
-- Dependencies: 1305 1306 1670
-- Name: type; Type: FK CONSTRAINT; Schema: public; Owner: academic
--

ALTER TABLE ONLY plan_course
    ADD CONSTRAINT "type" FOREIGN KEY ("type") REFERENCES type_course("type");


--
-- TOC entry 1697 (class 0 OID 0)
-- Dependencies: 4
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2008-04-22 17:23:30 PET

--
-- PostgreSQL database dump complete
--

