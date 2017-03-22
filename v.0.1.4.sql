--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.4
-- Dumped by pg_dump version 9.4.4
-- Started on 2016-08-16 22:16:34

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 245 (class 3079 OID 11855)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2451 (class 0 OID 0)
-- Dependencies: 245
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 172 (class 1259 OID 50702)
-- Name: adapted_query; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE adapted_query (
    id_adapted_query bigint NOT NULL,
    ds_adapted_query text NOT NULL,
    id_search_engine integer NOT NULL,
    id_standard_query bigint NOT NULL,
    ds_observation text
);


--
-- TOC entry 173 (class 1259 OID 50708)
-- Name: adapted_query_search_field; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE adapted_query_search_field (
    id_adapted_query bigint NOT NULL,
    id_search_field integer NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 58197)
-- Name: author; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE author (
    id_author bigint NOT NULL,
    nm_author text,
    sn_author text,
    id_institution integer
);


--
-- TOC entry 174 (class 1259 OID 50711)
-- Name: base_use_criteria; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_use_criteria (
    id_project bigint NOT NULL,
    id_search_engine integer NOT NULL,
    ds_base_use_criteria text NOT NULL
);


--
-- TOC entry 175 (class 1259 OID 50717)
-- Name: sq_category; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_category
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 176 (class 1259 OID 50719)
-- Name: category; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE category (
    id_category bigint DEFAULT nextval('sq_category'::regclass) NOT NULL,
    ds_category text,
    id_project bigint NOT NULL
);


--
-- TOC entry 177 (class 1259 OID 50726)
-- Name: sq_classification; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_classification
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 178 (class 1259 OID 50728)
-- Name: classification; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE classification (
    id_classification bigint DEFAULT nextval('sq_classification'::regclass) NOT NULL,
    dh_classification timestamp with time zone NOT NULL,
    id_study bigint NOT NULL,
    id_category bigint NOT NULL,
    id_option bigint,
    tp_status smallint DEFAULT 0 NOT NULL,
    CONSTRAINT ck_tp_status CHECK ((tp_status = ANY (ARRAY[0, 1, 2, 3])))
);


--
-- TOC entry 2452 (class 0 OID 0)
-- Dependencies: 178
-- Name: COLUMN classification.tp_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN classification.tp_status IS 'Types of status: 0 is "Assigned", 1 is "Extracted", 2 is "In conflict" and 3 is "Final".';


--
-- TOC entry 2453 (class 0 OID 0)
-- Dependencies: 178
-- Name: CONSTRAINT ck_tp_status ON classification; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_status ON classification IS '-- Types of status: 0 is "Assigned", 1 is "Extracted", 2 is "In conflict" and 3 is "Final".';


--
-- TOC entry 179 (class 1259 OID 50732)
-- Name: country; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE country (
    id_country integer NOT NULL,
    nm_country character varying(150) NOT NULL
);


--
-- TOC entry 180 (class 1259 OID 50735)
-- Name: criteria_result_justification; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE criteria_result_justification (
    id_selection_result bigint NOT NULL,
    id_selection_criteria bigint NOT NULL,
    ds_justification text NOT NULL
);


--
-- TOC entry 181 (class 1259 OID 50741)
-- Name: criteria_review_justification; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE criteria_review_justification (
    id_review bigint NOT NULL,
    id_selection_criteria bigint NOT NULL,
    ds_justification text NOT NULL
);


--
-- TOC entry 182 (class 1259 OID 50747)
-- Name: duplicate_study; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE duplicate_study (
    id_study bigint NOT NULL,
    id_duplicate_study bigint NOT NULL
);


--
-- TOC entry 183 (class 1259 OID 50750)
-- Name: sq_extraction_step; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_extraction_step
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 184 (class 1259 OID 50752)
-- Name: extraction_step; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE extraction_step (
    id_extraction_step bigint DEFAULT nextval('sq_extraction_step'::regclass) NOT NULL,
    qt_extraction smallint NOT NULL,
    dh_start_extraction_step timestamp with time zone NOT NULL,
    dh_end_extraction_step timestamp with time zone NOT NULL,
    dh_reviewer_extraction_end timestamp with time zone NOT NULL,
    dh_conflicts_solving_end timestamp with time zone NOT NULL,
    id_project bigint NOT NULL,
    tp_status smallint NOT NULL,
    vl_lower_score smallint NOT NULL,
    CONSTRAINT ck_tp_status CHECK ((tp_status = ANY (ARRAY[0, 1, 2, 3])))
);


--
-- TOC entry 2454 (class 0 OID 0)
-- Dependencies: 184
-- Name: COLUMN extraction_step.tp_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN extraction_step.tp_status IS '0: "Setting", 1: "On going", 2: "Reviewing extraction" and 3: "Finished".';


--
-- TOC entry 2455 (class 0 OID 0)
-- Dependencies: 184
-- Name: CONSTRAINT ck_tp_status ON extraction_step; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_status ON extraction_step IS '0: "Setting", 1: "On going", 2: "Reviewing extraction" and 3: "Finished".';


--
-- TOC entry 185 (class 1259 OID 50757)
-- Name: extraction_step_researcher; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE extraction_step_researcher (
    id_extraction_step bigint NOT NULL,
    id_researcher bigint NOT NULL
);


--
-- TOC entry 186 (class 1259 OID 50760)
-- Name: institution;Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE institution (
    id_institution integer NOT NULL,
    nm_institution character varying(200) NOT NULL,
    id_country integer NOT NULL,
	id_project bigint
);


--
-- TOC entry 244 (class 1259 OID 58294)
-- Name: invitation; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitation (
    id_invitation bigint NOT NULL,
    dh_invitation timestamp with time zone DEFAULT now() NOT NULL,
    dh_confirmation timestamp with time zone,
    id_project bigint NOT NULL,
    id_researcher bigint NOT NULL
);


--
-- TOC entry 187 (class 1259 OID 50763)
-- Name: sq_language; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_language
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 188 (class 1259 OID 50765)
-- Name: language; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE language (
    id_language integer DEFAULT nextval('sq_language'::regclass) NOT NULL,
    nm_language character varying(70) NOT NULL
);


--
-- TOC entry 189 (class 1259 OID 50769)
-- Name: main_question; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE main_question (
    id_main_question bigint NOT NULL,
    ds_main_question text NOT NULL,
    ds_population text,
    ds_intervation text,
    ds_control text,
    ds_result text,
    ds_application_context text,
    ds_experimental_design text,
    id_project bigint NOT NULL
);


--
-- TOC entry 190 (class 1259 OID 50775)
-- Name: objective; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE objective (
    id_objective integer NOT NULL,
    ds_objective text NOT NULL,
    id_project bigint NOT NULL
);


--
-- TOC entry 239 (class 1259 OID 51484)
-- Name: sq_option; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_option
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 238 (class 1259 OID 51471)
-- Name: option; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE option (
    id_option bigint DEFAULT nextval('sq_option'::regclass) NOT NULL,
    ds_option text NOT NULL,
    id_category bigint NOT NULL
);


--
-- TOC entry 191 (class 1259 OID 50781)
-- Name: sq_project; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_project
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 192 (class 1259 OID 50783)
-- Name: project; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project (
    id_project bigint DEFAULT nextval('sq_project'::regclass) NOT NULL,
    ds_title text NOT NULL,
    ds_slug character varying(10) NOT NULL,
    ds_project text,
    tp_review smallint NOT NULL,
    CONSTRAINT ck_tp_review CHECK ((tp_review = ANY (ARRAY[0, 1, 2])))
);


--
-- TOC entry 2456 (class 0 OID 0)
-- Dependencies: 192
-- Name: COLUMN project.tp_review; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project.tp_review IS 'Types of review: ''0'' is "Not Systematic", ''1'' is "Systematic Mapping" and ''2'' is "Systematic Review".';


--
-- TOC entry 2457 (class 0 OID 0)
-- Dependencies: 192
-- Name: CONSTRAINT ck_tp_review ON project; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_review ON project IS 'Types of review: ''''0'''' is "Not Systematic", ''''1'''' is "Systematic Mapping" and ''''2'''' is "Systematic Review".';


--
-- TOC entry 193 (class 1259 OID 50791)
-- Name: sq_project_member; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_project_member
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 194 (class 1259 OID 50793)
-- Name: project_member; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE project_member (
    id_project_member bigint DEFAULT nextval('sq_project_member'::regclass) NOT NULL,
    id_researcher bigint NOT NULL,
    id_project bigint NOT NULL,
    --id_institution integer NOT NULL,
    tp_role smallint DEFAULT 1 NOT NULL,
    CONSTRAINT ck_tp_role CHECK ((tp_role = ANY (ARRAY[0, 1])))
);


--
-- TOC entry 2458 (class 0 OID 0)
-- Dependencies: 194
-- Name: COLUMN project_member.tp_role; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN project_member.tp_role IS '''0'': Coordinator and ''1'': Member';


--
-- TOC entry 2459 (class 0 OID 0)
-- Dependencies: 194
-- Name: CONSTRAINT ck_tp_role ON project_member; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_role ON project_member IS '''0'': Coordinator and ''1'': Member';


--
-- TOC entry 195 (class 1259 OID 50799)
-- Name: sq_rated_content; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_rated_content
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 196 (class 1259 OID 50801)
-- Name: rated_content; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rated_content (
    id_rated_content smallint DEFAULT nextval('sq_rated_content'::regclass) NOT NULL,
    ds_rated_content text NOT NULL
);


--
-- TOC entry 197 (class 1259 OID 50808)
-- Name: sq_required_data; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_required_data
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 198 (class 1259 OID 50810)
-- Name: required_data; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE required_data (
    id_required_data bigint DEFAULT nextval('sq_required_data'::regclass) NOT NULL,
    ds_required_data text NOT NULL,
    id_project bigint NOT NULL
);


--
-- TOC entry 199 (class 1259 OID 50817)
-- Name: researcher; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE researcher (
    id_researcher bigint NOT NULL,
    nm_researcher character varying(70),
    ds_email character varying(70),
    ds_password character(60),
    tp_state character(1),
    ds_sso character varying(70),
    CONSTRAINT ck_tp_state CHECK ((tp_state = ANY (ARRAY['R'::bpchar, 'A'::bpchar, 'I'::bpchar, 'D'::bpchar, 'L'::bpchar])))
);


--
-- TOC entry 2460 (class 0 OID 0)
-- Dependencies: 199
-- Name: CONSTRAINT ck_tp_state ON researcher; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_state ON researcher IS 'Types of selection states: ''R'' is Registered, ''A'' is "Active", ''I'' is "Inactive", ''D'' is "Deleted" and ''L'' is "Locked".';


--
-- TOC entry 200 (class 1259 OID 50822)
-- Name: researcher_role; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE researcher_role (
    id_researcher_role integer NOT NULL,
    nm_researcher_role character varying(70) NOT NULL
);


--
-- TOC entry 201 (class 1259 OID 50825)
-- Name: sq_researcher_search_engine; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_researcher_search_engine
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 202 (class 1259 OID 50827)
-- Name: researcher_search_engine; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE researcher_search_engine (
    id_researcher_search_engine bigint DEFAULT nextval('sq_researcher_search_engine'::regclass) NOT NULL,
    id_project bigint NOT NULL,
    id_search_engine bigint NOT NULL,
    id_researcher bigint NOT NULL,
    dh_assign timestamp with time zone NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 50831)
-- Name: sq_review; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_review
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 204 (class 1259 OID 50833)
-- Name: review; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE review (
    id_review bigint DEFAULT nextval('sq_review'::regclass) NOT NULL,
    dh_assign time with time zone NOT NULL,
    dh_review timestamp with time zone,
    id_researcher bigint NOT NULL,
    tp_status smallint DEFAULT 0 NOT NULL,
    id_study bigint NOT NULL,
    CONSTRAINT ck_tp_status CHECK ((tp_status = ANY (ARRAY[0, 1, 2])))
);


--
-- TOC entry 2461 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN review.tp_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN review.tp_status IS 'Types of selection status: 0 is "Assigned", 1 is "Accepted" and 2 is "Rejected".';


--
-- TOC entry 2462 (class 0 OID 0)
-- Dependencies: 204
-- Name: CONSTRAINT ck_tp_status ON review; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_status ON review IS 'Types of selection status: ''''0'''' is "Assigned", ''''1'''' is "Accepted" and ''''2'''' is "Rejected".';


--
-- TOC entry 205 (class 1259 OID 50845)
-- Name: sq_search; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_search
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 206 (class 1259 OID 50847)
-- Name: search; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE search (
    id_search bigint DEFAULT nextval('sq_search'::regclass) NOT NULL,
    nr_search bigint NOT NULL,
    nm_search character varying(70) DEFAULT 'Search'::character varying NOT NULL,
    dh_search timestamp with time zone DEFAULT now(),
    tp_search smallint NOT NULL,
    id_adapted_query bigint,
    ds_search text,
    id_project bigint NOT NULL,
    CONSTRAINT ck_tp_search CHECK ((tp_search = ANY (ARRAY[0, 1])))
);


--
-- TOC entry 2463 (class 0 OID 0)
-- Dependencies: 206
-- Name: COLUMN search.tp_search; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN search.tp_search IS 'Types of search: 0 is "Automatic" and 1 is "Manual".';


--
-- TOC entry 2464 (class 0 OID 0)
-- Dependencies: 206
-- Name: CONSTRAINT ck_tp_search ON search; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_search ON search IS 'Types of search: 0 is "Automatic" and 1 is "Manual".';


--
-- TOC entry 207 (class 1259 OID 50854)
-- Name: search_engine; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE search_engine (
    id_search_engine integer NOT NULL,
    nm_search_engine character varying(70) NOT NULL
);


--
-- TOC entry 208 (class 1259 OID 50857)
-- Name: sq_search_field; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_search_field
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 209 (class 1259 OID 50859)
-- Name: search_field; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE search_field (
    id_search_field integer DEFAULT nextval('sq_search_field'::regclass) NOT NULL,
    ds_search_field character varying(100) NOT NULL
);


--
-- TOC entry 210 (class 1259 OID 50863)
-- Name: search_keyword; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE search_keyword (
    id_search_keyword bigint NOT NULL,
    ds_search_keyword text NOT NULL,
    id_project bigint NOT NULL
);


--
-- TOC entry 211 (class 1259 OID 50869)
-- Name: secondary_question; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE secondary_question (
    id_secondary_question bigint NOT NULL,
    ds_secondary_question text NOT NULL,
    id_project bigint NOT NULL
);


--
-- TOC entry 212 (class 1259 OID 50875)
-- Name: selection_criteria; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE selection_criteria (
    id_selection_criteria bigint NOT NULL,
    ds_selection_criteria text NOT NULL,
    id_project bigint NOT NULL,
    tp_criteria smallint,
    CONSTRAINT ck_tp_criteria CHECK ((tp_criteria = ANY (ARRAY[0, 1])))
);


--
-- TOC entry 2465 (class 0 OID 0)
-- Dependencies: 212
-- Name: COLUMN selection_criteria.tp_criteria; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN selection_criteria.tp_criteria IS 'Types of selection criteria: 0 is "Exclusion" and 1 is "Inclusion".';


--
-- TOC entry 2466 (class 0 OID 0)
-- Dependencies: 212
-- Name: CONSTRAINT ck_tp_criteria ON selection_criteria; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_criteria ON selection_criteria IS 'Types of selection criteria: ''0'' is "Exclusion" and ''1'' is "Inclusion".';


--
-- TOC entry 213 (class 1259 OID 50882)
-- Name: sq_selection_result; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_selection_result
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 214 (class 1259 OID 50884)
-- Name: selection_result; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE selection_result (
    id_selection_result bigint DEFAULT nextval('sq_selection_result'::regclass) NOT NULL,
    dh_assign timestamp with time zone NOT NULL,
    dh_solution timestamp with time zone NOT NULL,
    id_study bigint NOT NULL,
    id_researcher bigint,
    id_selection_step bigint NOT NULL,
    tp_status smallint NOT NULL,
    CONSTRAINT ck_tp_status CHECK ((tp_status = ANY (ARRAY[0, 1, 2])))
);


--
-- TOC entry 2467 (class 0 OID 0)
-- Dependencies: 214
-- Name: COLUMN selection_result.tp_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN selection_result.tp_status IS 'Types of selection result: 0 is "In conflict", 1 is "Accepted" and 2 is "Rejected".';


--
-- TOC entry 215 (class 1259 OID 50889)
-- Name: sq_selection_step; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_selection_step
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 216 (class 1259 OID 50891)
-- Name: selection_step; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE selection_step (
    id_selection_step bigint DEFAULT nextval('sq_selection_step'::regclass) NOT NULL,
    nr_serial smallint NOT NULL,
    qt_review smallint NOT NULL,
    dh_start_selection_step timestamp with time zone NOT NULL,
    dh_end_selection_step timestamp with time zone NOT NULL,
    dh_review_end timestamp with time zone NOT NULL,
    dh_conflicts_solving_end timestamp with time zone NOT NULL,
    id_rated_content smallint NOT NULL,
    id_project bigint NOT NULL,
    tp_status smallint NOT NULL,
    vl_lower_score smallint NOT NULL,
    CONSTRAINT ck_tp_status CHECK ((tp_status = ANY (ARRAY[0, 1, 2, 3])))
);


--
-- TOC entry 2468 (class 0 OID 0)
-- Dependencies: 216
-- Name: COLUMN selection_step.tp_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN selection_step.tp_status IS 'Types of selection step: 0 is "Setting", 1 is "On going", 2 is "Solving conflicts" and 3 is "Finished".';


--
-- TOC entry 2469 (class 0 OID 0)
-- Dependencies: 216
-- Name: CONSTRAINT ck_tp_status ON selection_step; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_status ON selection_step IS 'Types of selection step: 0 is "Setting", 1 is "On going", 2 is "Solving conflicts" and 3 is "Finished".';


--
-- TOC entry 217 (class 1259 OID 50896)
-- Name: selection_step_researcher; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE selection_step_researcher (
    id_selection_step bigint NOT NULL,
    id_researcher bigint NOT NULL
);


--
-- TOC entry 218 (class 1259 OID 50899)
-- Name: sq_adapted_query; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_adapted_query
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2470 (class 0 OID 0)
-- Dependencies: 218
-- Name: sq_adapted_query; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_adapted_query OWNED BY adapted_query.id_adapted_query;


--
-- TOC entry 240 (class 1259 OID 58195)
-- Name: sq_author; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_author
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2471 (class 0 OID 0)
-- Dependencies: 240
-- Name: sq_author; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_author OWNED BY author.id_author;


--
-- TOC entry 219 (class 1259 OID 50901)
-- Name: sq_country; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_country
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2472 (class 0 OID 0)
-- Dependencies: 219
-- Name: sq_country; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_country OWNED BY country.id_country;


--
-- TOC entry 220 (class 1259 OID 50903)
-- Name: sq_institution; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_institution
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2473 (class 0 OID 0)
-- Dependencies: 220
-- Name: sq_institution; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_institution OWNED BY institution.id_institution;


--
-- TOC entry 243 (class 1259 OID 58292)
-- Name: sq_invitation; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_invitation
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2474 (class 0 OID 0)
-- Dependencies: 243
-- Name: sq_invitation; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_invitation OWNED BY invitation.id_invitation;


--
-- TOC entry 221 (class 1259 OID 50905)
-- Name: sq_main_question; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_main_question
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2475 (class 0 OID 0)
-- Dependencies: 221
-- Name: sq_main_question; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_main_question OWNED BY main_question.id_main_question;


--
-- TOC entry 222 (class 1259 OID 50907)
-- Name: sq_objective; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_objective
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2476 (class 0 OID 0)
-- Dependencies: 222
-- Name: sq_objective; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_objective OWNED BY objective.id_objective;


--
-- TOC entry 223 (class 1259 OID 50909)
-- Name: sq_researcher; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_researcher
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2477 (class 0 OID 0)
-- Dependencies: 223
-- Name: sq_researcher; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_researcher OWNED BY researcher.id_researcher;


--
-- TOC entry 224 (class 1259 OID 50911)
-- Name: sq_researcher_role; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_researcher_role
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2478 (class 0 OID 0)
-- Dependencies: 224
-- Name: sq_researcher_role; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_researcher_role OWNED BY researcher_role.id_researcher_role;


--
-- TOC entry 225 (class 1259 OID 50913)
-- Name: sq_search_engine; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_search_engine
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2479 (class 0 OID 0)
-- Dependencies: 225
-- Name: sq_search_engine; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_search_engine OWNED BY search_engine.id_search_engine;


--
-- TOC entry 226 (class 1259 OID 50915)
-- Name: sq_search_keyword; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_search_keyword
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2480 (class 0 OID 0)
-- Dependencies: 226
-- Name: sq_search_keyword; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_search_keyword OWNED BY search_keyword.id_search_keyword;


--
-- TOC entry 227 (class 1259 OID 50917)
-- Name: sq_secondary_question; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_secondary_question
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2481 (class 0 OID 0)
-- Dependencies: 227
-- Name: sq_secondary_question; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_secondary_question OWNED BY secondary_question.id_secondary_question;


--
-- TOC entry 228 (class 1259 OID 50919)
-- Name: sq_selection_criteria; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_selection_criteria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2482 (class 0 OID 0)
-- Dependencies: 228
-- Name: sq_selection_criteria; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_selection_criteria OWNED BY selection_criteria.id_selection_criteria;


--
-- TOC entry 229 (class 1259 OID 50921)
-- Name: standard_query; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE standard_query (
    id_standard_query bigint NOT NULL,
    ds_standard_query text NOT NULL,
    id_project bigint NOT NULL
);


--
-- TOC entry 230 (class 1259 OID 50927)
-- Name: sq_standard_query; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_standard_query
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2483 (class 0 OID 0)
-- Dependencies: 230
-- Name: sq_standard_query; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sq_standard_query OWNED BY standard_query.id_standard_query;


--
-- TOC entry 231 (class 1259 OID 50929)
-- Name: sq_study; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_study
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 232 (class 1259 OID 50931)
-- Name: sq_study_data; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_study_data
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 233 (class 1259 OID 50933)
-- Name: sq_study_summary; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sq_study_summary
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 234 (class 1259 OID 50935)
-- Name: study; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE study (
    id_study bigint DEFAULT nextval('sq_study'::regclass) NOT NULL,
    ds_title text,
    nm_author text,
    ds_abstract text,
    ds_keyword text,
    nr_year smallint,
    ds_volume text,
    ds_url text,
    cd_issn_isbn character varying(70),
    cd_doi character varying(70),
    ds_type text,
    ds_page text,
    ds_comment text,
    ds_journal text,
    cd_cite_key character varying(50) NOT NULL,
    tp_venue smallint,
    tp_status smallint DEFAULT 0 NOT NULL,
    tp_reading_rate smallint DEFAULT 0 NOT NULL,
    id_project bigint NOT NULL,
    id_search bigint,
    CONSTRAINT ck_tp_reading_rate CHECK ((tp_reading_rate = ANY (ARRAY[0, 1, 2, 3]))),
    CONSTRAINT ck_tp_status CHECK ((tp_status = ANY (ARRAY[0, 1, 2, 3]))),
    CONSTRAINT ck_tp_venue CHECK ((tp_venue = ANY (ARRAY[0, 1, 2, 3,4])))
);


--
-- TOC entry 2484 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN study.tp_venue; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN study.tp_venue IS 'Types of venue: 0 is "Journal", 1 is "Conference Proceedings", 2 is "Technical Report", 3 is "Thesis" and 4 is "Book".';


--
-- TOC entry 2485 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN study.tp_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN study.tp_status IS '0: Unclassified, 1: Duplicated, 2: Included, 3: Excluded';


--
-- TOC entry 2486 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN study.tp_reading_rate; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN study.tp_reading_rate IS '0: Very low, 1: Low, 2: High and 3: Very high.';


--
-- TOC entry 2487 (class 0 OID 0)
-- Dependencies: 234
-- Name: CONSTRAINT ck_tp_reading_rate ON study; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_reading_rate ON study IS '0: Very low, 1: Low, 2: High and 3: Very high.';


--
-- TOC entry 2488 (class 0 OID 0)
-- Dependencies: 234
-- Name: CONSTRAINT ck_tp_status ON study; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_status ON study IS '0: Unclassified, 1: Duplicated, 2: Included, 3: Excluded';


--
-- TOC entry 2489 (class 0 OID 0)
-- Dependencies: 234
-- Name: CONSTRAINT ck_tp_venue ON study; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_venue ON study IS 'Types of venue: 0 is "Journal", 1 is "Conference Proceedings", 2 is "Technical Report", 3 is "Thesis" and 4 is "Book".';


--
-- TOC entry 242 (class 1259 OID 58242)
-- Name: study_author; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE study_author (
    id_study bigint NOT NULL,
    id_author bigint NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 50947)
-- Name: study_data; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE study_data (
    id_study_data bigint DEFAULT nextval('sq_study_data'::regclass) NOT NULL,
    ds_data text,
    dh_extraction timestamp with time zone[],
    id_study bigint,
    id_researcher bigint NOT NULL,
    id_required_data bigint NOT NULL,
    tp_status smallint DEFAULT 0 NOT NULL,
    CONSTRAINT ck_tp_status CHECK ((tp_status = ANY (ARRAY[0, 1, 2])))
);


--
-- TOC entry 2490 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN study_data.tp_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN study_data.tp_status IS 'Types of status: 0 is "Assigned", 1 is "Extracted", 2 is "In conflict" and 3 is "Final".';


--
-- TOC entry 2491 (class 0 OID 0)
-- Dependencies: 235
-- Name: CONSTRAINT ck_tp_status ON study_data; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT ck_tp_status ON study_data IS 'Types of status: 0 is "Assigned", 1 is "Extracted" and 2 is "Final".';


--
-- TOC entry 236 (class 1259 OID 50956)
-- Name: study_language; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE study_language (
    id_project bigint NOT NULL,
    id_language integer NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 50959)
-- Name: study_summary; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE study_summary (
    id_study_summary bigint DEFAULT nextval('sq_study_summary'::regclass) NOT NULL,
    ds_context text NOT NULL,
    ds_objective text,
    ds_hypotheses text,
    ds_proposed_approach text,
    ds_research_methodology text,
    ds_result text,
    ds_conclusion text,
    id_researcher bigint NOT NULL,
    id_study bigint
);


--
-- TOC entry 2123 (class 2604 OID 50966)
-- Name: id_adapted_query; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY adapted_query ALTER COLUMN id_adapted_query SET DEFAULT nextval('sq_adapted_query'::regclass);


--
-- TOC entry 2175 (class 2604 OID 58200)
-- Name: id_author; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY author ALTER COLUMN id_author SET DEFAULT nextval('sq_author'::regclass);


--
-- TOC entry 2128 (class 2604 OID 50967)
-- Name: id_country; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY country ALTER COLUMN id_country SET DEFAULT nextval('sq_country'::regclass);


--
-- TOC entry 2131 (class 2604 OID 50968)
-- Name: id_institution; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY institution ALTER COLUMN id_institution SET DEFAULT nextval('sq_institution'::regclass);


--
-- TOC entry 2176 (class 2604 OID 58297)
-- Name: id_invitation; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitation ALTER COLUMN id_invitation SET DEFAULT nextval('sq_invitation'::regclass);


--
-- TOC entry 2133 (class 2604 OID 50969)
-- Name: id_main_question; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY main_question ALTER COLUMN id_main_question SET DEFAULT nextval('sq_main_question'::regclass);


--
-- TOC entry 2134 (class 2604 OID 50970)
-- Name: id_objective; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY objective ALTER COLUMN id_objective SET DEFAULT nextval('sq_objective'::regclass);


--
-- TOC entry 2142 (class 2604 OID 50971)
-- Name: id_researcher; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY researcher ALTER COLUMN id_researcher SET DEFAULT nextval('sq_researcher'::regclass);


--
-- TOC entry 2144 (class 2604 OID 50972)
-- Name: id_researcher_role; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY researcher_role ALTER COLUMN id_researcher_role SET DEFAULT nextval('sq_researcher_role'::regclass);


--
-- TOC entry 2153 (class 2604 OID 50973)
-- Name: id_search_engine; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_engine ALTER COLUMN id_search_engine SET DEFAULT nextval('sq_search_engine'::regclass);


--
-- TOC entry 2155 (class 2604 OID 50974)
-- Name: id_search_keyword; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_keyword ALTER COLUMN id_search_keyword SET DEFAULT nextval('sq_search_keyword'::regclass);


--
-- TOC entry 2156 (class 2604 OID 50975)
-- Name: id_secondary_question; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY secondary_question ALTER COLUMN id_secondary_question SET DEFAULT nextval('sq_secondary_question'::regclass);


--
-- TOC entry 2157 (class 2604 OID 50976)
-- Name: id_selection_criteria; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_criteria ALTER COLUMN id_selection_criteria SET DEFAULT nextval('sq_selection_criteria'::regclass);


--
-- TOC entry 2163 (class 2604 OID 50977)
-- Name: id_standard_query; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY standard_query ALTER COLUMN id_standard_query SET DEFAULT nextval('sq_standard_query'::regclass);


--
-- TOC entry 2179 (class 2606 OID 51122)
-- Name: pk_adapted_query; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY adapted_query
    ADD CONSTRAINT pk_adapted_query PRIMARY KEY (id_adapted_query);


--
-- TOC entry 2181 (class 2606 OID 51124)
-- Name: pk_adapted_query_search_field; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY adapted_query_search_field
    ADD CONSTRAINT pk_adapted_query_search_field PRIMARY KEY (id_adapted_query, id_search_field);


--
-- TOC entry 2271 (class 2606 OID 58205)
-- Name: pk_author; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT pk_author PRIMARY KEY (id_author);


--
-- TOC entry 2183 (class 2606 OID 51126)
-- Name: pk_base_use_criteria; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_use_criteria
    ADD CONSTRAINT pk_base_use_criteria PRIMARY KEY (id_project, id_search_engine);


--
-- TOC entry 2185 (class 2606 OID 51128)
-- Name: pk_category; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT pk_category PRIMARY KEY (id_category);


--
-- TOC entry 2188 (class 2606 OID 51130)
-- Name: pk_classification; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY classification
    ADD CONSTRAINT pk_classification PRIMARY KEY (id_classification);


--
-- TOC entry 2190 (class 2606 OID 51132)
-- Name: pk_country; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY country
    ADD CONSTRAINT pk_country PRIMARY KEY (id_country);


--
-- TOC entry 2192 (class 2606 OID 51134)
-- Name: pk_criteria_result_justification; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY criteria_result_justification
    ADD CONSTRAINT pk_criteria_result_justification PRIMARY KEY (id_selection_result, id_selection_criteria);


--
-- TOC entry 2194 (class 2606 OID 51136)
-- Name: pk_criteria_review_justification; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY criteria_review_justification
    ADD CONSTRAINT pk_criteria_review_justification PRIMARY KEY (id_review, id_selection_criteria);


--
-- TOC entry 2196 (class 2606 OID 51138)
-- Name: pk_duplicate_study; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY duplicate_study
    ADD CONSTRAINT pk_duplicate_study PRIMARY KEY (id_study, id_duplicate_study);


--
-- TOC entry 2198 (class 2606 OID 51140)
-- Name: pk_extraction_step; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY extraction_step
    ADD CONSTRAINT pk_extraction_step PRIMARY KEY (id_extraction_step);


--
-- TOC entry 2200 (class 2606 OID 51142)
-- Name: pk_extraction_step_researcher; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY extraction_step_researcher
    ADD CONSTRAINT pk_extraction_step_researcher PRIMARY KEY (id_extraction_step, id_researcher);


--
-- TOC entry 2202 (class 2606 OID 51144)
-- Name: pk_institution; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY institution
    ADD CONSTRAINT pk_institution PRIMARY KEY (id_institution);


--
-- TOC entry 2275 (class 2606 OID 58300)
-- Name: pk_invitation; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitation
    ADD CONSTRAINT pk_invitation PRIMARY KEY (id_invitation);


--
-- TOC entry 2204 (class 2606 OID 51146)
-- Name: pk_language; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY language
    ADD CONSTRAINT pk_language PRIMARY KEY (id_language);


--
-- TOC entry 2206 (class 2606 OID 51148)
-- Name: pk_main_question; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY main_question
    ADD CONSTRAINT pk_main_question PRIMARY KEY (id_main_question);


--
-- TOC entry 2208 (class 2606 OID 51150)
-- Name: pk_objective; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY objective
    ADD CONSTRAINT pk_objective PRIMARY KEY (id_objective);


--
-- TOC entry 2269 (class 2606 OID 51478)
-- Name: pk_option; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY option
    ADD CONSTRAINT pk_option PRIMARY KEY (id_option);


--
-- TOC entry 2210 (class 2606 OID 51152)
-- Name: pk_project; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT pk_project PRIMARY KEY (id_project);


--
-- TOC entry 2214 (class 2606 OID 51154)
-- Name: pk_project_member; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project_member
    ADD CONSTRAINT pk_project_member PRIMARY KEY (id_project_member);


--
-- TOC entry 2216 (class 2606 OID 51156)
-- Name: pk_rated_content; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rated_content
    ADD CONSTRAINT pk_rated_content PRIMARY KEY (id_rated_content);


--
-- TOC entry 2219 (class 2606 OID 51158)
-- Name: pk_required_data; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY required_data
    ADD CONSTRAINT pk_required_data PRIMARY KEY (id_required_data);


--
-- TOC entry 2221 (class 2606 OID 51160)
-- Name: pk_researcher; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY researcher
    ADD CONSTRAINT pk_researcher PRIMARY KEY (id_researcher);


--
-- TOC entry 2227 (class 2606 OID 51162)
-- Name: pk_researcher_role; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY researcher_role
    ADD CONSTRAINT pk_researcher_role PRIMARY KEY (id_researcher_role);


--
-- TOC entry 2229 (class 2606 OID 51164)
-- Name: pk_researcher_search_engine; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY researcher_search_engine
    ADD CONSTRAINT pk_researcher_search_engine PRIMARY KEY (id_researcher_search_engine);


--
-- TOC entry 2232 (class 2606 OID 51166)
-- Name: pk_review; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY review
    ADD CONSTRAINT pk_review PRIMARY KEY (id_review);


--
-- TOC entry 2235 (class 2606 OID 51170)
-- Name: pk_search; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search
    ADD CONSTRAINT pk_search PRIMARY KEY (id_search);


--
-- TOC entry 2239 (class 2606 OID 51172)
-- Name: pk_search_engine; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search_engine
    ADD CONSTRAINT pk_search_engine PRIMARY KEY (id_search_engine);


--
-- TOC entry 2241 (class 2606 OID 51174)
-- Name: pk_search_field; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search_field
    ADD CONSTRAINT pk_search_field PRIMARY KEY (id_search_field);


--
-- TOC entry 2243 (class 2606 OID 51176)
-- Name: pk_search_keyword; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search_keyword
    ADD CONSTRAINT pk_search_keyword PRIMARY KEY (id_search_keyword);


--
-- TOC entry 2247 (class 2606 OID 51178)
-- Name: pk_secondary_question; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY secondary_question
    ADD CONSTRAINT pk_secondary_question PRIMARY KEY (id_secondary_question);


--
-- TOC entry 2249 (class 2606 OID 51180)
-- Name: pk_selection_criteria; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY selection_criteria
    ADD CONSTRAINT pk_selection_criteria PRIMARY KEY (id_selection_criteria);


--
-- TOC entry 2251 (class 2606 OID 51182)
-- Name: pk_selection_result; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY selection_result
    ADD CONSTRAINT pk_selection_result PRIMARY KEY (id_selection_result);


--
-- TOC entry 2253 (class 2606 OID 51184)
-- Name: pk_selection_step; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY selection_step
    ADD CONSTRAINT pk_selection_step PRIMARY KEY (id_selection_step);


--
-- TOC entry 2255 (class 2606 OID 51186)
-- Name: pk_selection_step_researcher; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY selection_step_researcher
    ADD CONSTRAINT pk_selection_step_researcher PRIMARY KEY (id_selection_step, id_researcher);


--
-- TOC entry 2257 (class 2606 OID 51188)
-- Name: pk_standard_query; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY standard_query
    ADD CONSTRAINT pk_standard_query PRIMARY KEY (id_standard_query);


--
-- TOC entry 2259 (class 2606 OID 51190)
-- Name: pk_study; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY study
    ADD CONSTRAINT pk_study PRIMARY KEY (id_study);


--
-- TOC entry 2273 (class 2606 OID 58246)
-- Name: pk_study_author; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY study_author
    ADD CONSTRAINT pk_study_author PRIMARY KEY (id_study, id_author);


--
-- TOC entry 2263 (class 2606 OID 51192)
-- Name: pk_study_data; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY study_data
    ADD CONSTRAINT pk_study_data PRIMARY KEY (id_study_data);


--
-- TOC entry 2265 (class 2606 OID 51194)
-- Name: pk_study_language; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY study_language
    ADD CONSTRAINT pk_study_language PRIMARY KEY (id_project, id_language);


--
-- TOC entry 2267 (class 2606 OID 51196)
-- Name: pk_study_summary; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY study_summary
    ADD CONSTRAINT pk_study_summary PRIMARY KEY (id_study_summary);


--
-- TOC entry 2261 (class 2606 OID 58118)
-- Name: uq_cite_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY study
    ADD CONSTRAINT uq_cite_key UNIQUE (cd_cite_key);


--
-- TOC entry 2223 (class 2606 OID 58112)
-- Name: uq_ds_email; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY researcher
    ADD CONSTRAINT uq_ds_email UNIQUE (ds_email);


--
-- TOC entry 2245 (class 2606 OID 51198)
-- Name: uq_ds_search_keyword_id_project; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search_keyword
    ADD CONSTRAINT uq_ds_search_keyword_id_project UNIQUE (ds_search_keyword, id_project);


--
-- TOC entry 2212 (class 2606 OID 58116)
-- Name: uq_ds_slug; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT uq_ds_slug UNIQUE (ds_slug);


--
-- TOC entry 2225 (class 2606 OID 58114)
-- Name: uq_ds_sso; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY researcher
    ADD CONSTRAINT uq_ds_sso UNIQUE (ds_sso);


--
-- TOC entry 2237 (class 2606 OID 60096)
-- Name: uq_nr_search; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY search
    ADD CONSTRAINT uq_nr_search UNIQUE (nr_search);


--
-- TOC entry 2186 (class 1259 OID 51199)
-- Name: fki_category_classification; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_category_classification ON classification USING btree (id_category);


--
-- TOC entry 2217 (class 1259 OID 51200)
-- Name: fki_project_required_data; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_project_required_data ON required_data USING btree (id_project);


--
-- TOC entry 2233 (class 1259 OID 51201)
-- Name: fki_search_adapted_query; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_search_adapted_query ON search USING btree (id_adapted_query);


--
-- TOC entry 2230 (class 1259 OID 51202)
-- Name: fki_study_review; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_study_review ON review USING btree (id_study);


--
-- TOC entry 2308 (class 2606 OID 51203)
-- Name: fk_adapted_query_search; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY search
    ADD CONSTRAINT fk_adapted_query_search FOREIGN KEY (id_adapted_query) REFERENCES adapted_query(id_adapted_query);


--
-- TOC entry 2278 (class 2606 OID 51208)
-- Name: fk_adapted_query_search_field; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY adapted_query_search_field
    ADD CONSTRAINT fk_adapted_query_search_field FOREIGN KEY (id_adapted_query) REFERENCES adapted_query(id_adapted_query);


--
-- TOC entry 2333 (class 2606 OID 58252)
-- Name: fk_author_study; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_author
    ADD CONSTRAINT fk_author_study FOREIGN KEY (id_author) REFERENCES author(id_author);


--
-- TOC entry 2283 (class 2606 OID 51213)
-- Name: fk_category_classification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY classification
    ADD CONSTRAINT fk_category_classification FOREIGN KEY (id_category) REFERENCES category(id_category);


--
-- TOC entry 2330 (class 2606 OID 51479)
-- Name: fk_category_option; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY option
    ADD CONSTRAINT fk_category_option FOREIGN KEY (id_category) REFERENCES category(id_category);


--
-- TOC entry 2295 (class 2606 OID 51218)
-- Name: fk_country_institution; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY institution
    ADD CONSTRAINT fk_country_institution FOREIGN KEY (id_country) REFERENCES country(id_country);


--
-- TOC entry 2290 (class 2606 OID 51223)
-- Name: fk_duplicate_study_duplicate_study; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY duplicate_study
    ADD CONSTRAINT fk_duplicate_study_duplicate_study FOREIGN KEY (id_study) REFERENCES study(id_study);


--
-- TOC entry 2293 (class 2606 OID 51228)
-- Name: fk_extraction_step_researcher; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY extraction_step_researcher
    ADD CONSTRAINT fk_extraction_step_researcher FOREIGN KEY (id_extraction_step) REFERENCES extraction_step(id_extraction_step);


--
-- TOC entry 2299 (class 2606 OID 51233)
-- Name: fk_institution_project_member; Type: FK CONSTRAINT; Schema: public; Owner: -
--

--ALTER TABLE ONLY project_member
 --   ADD CONSTRAINT fk_institution_project_member FOREIGN KEY (id_institution) REFERENCES institution(id_institution);


--
-- TOC entry 2326 (class 2606 OID 51238)
-- Name: fk_language_study_language; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_language
    ADD CONSTRAINT fk_language_study_language FOREIGN KEY (id_language) REFERENCES language(id_language);


--
-- TOC entry 2285 (class 2606 OID 51493)
-- Name: fk_option_classification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY classification
    ADD CONSTRAINT fk_option_classification FOREIGN KEY (id_option) REFERENCES option(id_option);


--
-- TOC entry 2280 (class 2606 OID 51243)
-- Name: fk_project_base_use_criteria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_use_criteria
    ADD CONSTRAINT fk_project_base_use_criteria FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2282 (class 2606 OID 51248)
-- Name: fk_project_category; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category
    ADD CONSTRAINT fk_project_category FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2292 (class 2606 OID 51253)
-- Name: fk_project_extraction_step; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY extraction_step
    ADD CONSTRAINT fk_project_extraction_step FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2296 (class 2606 OID 58284)
-- Name: fk_project_institution; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY institution
    ADD CONSTRAINT fk_project_institution FOREIGN KEY (id_project) REFERENCES project(id_project);
	
	
--
-- TOC entry 2334 (class 2606 OID 58301)
-- Name: fk_project_invitation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitation
    ADD CONSTRAINT fk_project_invitation FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2297 (class 2606 OID 51258)
-- Name: fk_project_main_question; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY main_question
    ADD CONSTRAINT fk_project_main_question FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2298 (class 2606 OID 51263)
-- Name: fk_project_objective; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY objective
    ADD CONSTRAINT fk_project_objective FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2300 (class 2606 OID 51268)
-- Name: fk_project_project_member; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_member
    ADD CONSTRAINT fk_project_project_member FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2302 (class 2606 OID 51273)
-- Name: fk_project_required_data; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY required_data
    ADD CONSTRAINT fk_project_required_data FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2303 (class 2606 OID 51278)
-- Name: fk_project_researcher_search_engine; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY researcher_search_engine
    ADD CONSTRAINT fk_project_researcher_search_engine FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2310 (class 2606 OID 51283)
-- Name: fk_project_search_keyword; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_keyword
    ADD CONSTRAINT fk_project_search_keyword FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2311 (class 2606 OID 51288)
-- Name: fk_project_secondary_question; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY secondary_question
    ADD CONSTRAINT fk_project_secondary_question FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2312 (class 2606 OID 51293)
-- Name: fk_project_selection_criteria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_criteria
    ADD CONSTRAINT fk_project_selection_criteria FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2316 (class 2606 OID 51298)
-- Name: fk_project_selection_step; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_step
    ADD CONSTRAINT fk_project_selection_step FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2320 (class 2606 OID 51303)
-- Name: fk_project_standard_query; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY standard_query
    ADD CONSTRAINT fk_project_standard_query FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2321 (class 2606 OID 58119)
-- Name: fk_project_study; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study
    ADD CONSTRAINT fk_project_study FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2327 (class 2606 OID 51308)
-- Name: fk_project_study_language; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_language
    ADD CONSTRAINT fk_project_study_language FOREIGN KEY (id_project) REFERENCES project(id_project);


--
-- TOC entry 2317 (class 2606 OID 51313)
-- Name: fk_rated_content_selection_step; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_step
    ADD CONSTRAINT fk_rated_content_selection_step FOREIGN KEY (id_rated_content) REFERENCES rated_content(id_rated_content);


--
-- TOC entry 2323 (class 2606 OID 51318)
-- Name: fk_required_data_study_data; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_data
    ADD CONSTRAINT fk_required_data_study_data FOREIGN KEY (id_required_data) REFERENCES required_data(id_required_data);


--
-- TOC entry 2304 (class 2606 OID 51323)
-- Name: fk_reseacher_researcher_search_engine; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY researcher_search_engine
    ADD CONSTRAINT fk_reseacher_researcher_search_engine FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2294 (class 2606 OID 51328)
-- Name: fk_researcher_extraction_step; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY extraction_step_researcher
    ADD CONSTRAINT fk_researcher_extraction_step FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2335 (class 2606 OID 58306)
-- Name: fk_researcher_invitation; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitation
    ADD CONSTRAINT fk_researcher_invitation FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2301 (class 2606 OID 51333)
-- Name: fk_researcher_project_member; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY project_member
    ADD CONSTRAINT fk_researcher_project_member FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2306 (class 2606 OID 51338)
-- Name: fk_researcher_review; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY review
    ADD CONSTRAINT fk_researcher_review FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2313 (class 2606 OID 51343)
-- Name: fk_researcher_selection_result; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_result
    ADD CONSTRAINT fk_researcher_selection_result FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2318 (class 2606 OID 51348)
-- Name: fk_researcher_selection_step_researcher; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_step_researcher
    ADD CONSTRAINT fk_researcher_selection_step_researcher FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2324 (class 2606 OID 51353)
-- Name: fk_researcher_study_data; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_data
    ADD CONSTRAINT fk_researcher_study_data FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2328 (class 2606 OID 51358)
-- Name: fk_researcher_study_summary; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_summary
    ADD CONSTRAINT fk_researcher_study_summary FOREIGN KEY (id_researcher) REFERENCES researcher(id_researcher);


--
-- TOC entry 2288 (class 2606 OID 51363)
-- Name: fk_review_criteria_review_justification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY criteria_review_justification
    ADD CONSTRAINT fk_review_criteria_review_justification FOREIGN KEY (id_review) REFERENCES review(id_review);


--
-- TOC entry 2277 (class 2606 OID 51383)
-- Name: fk_search_engine_adapted_query; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY adapted_query
    ADD CONSTRAINT fk_search_engine_adapted_query FOREIGN KEY (id_search_engine) REFERENCES search_engine(id_search_engine);


--
-- TOC entry 2305 (class 2606 OID 51373)
-- Name: fk_search_engine_researcher_search_engine; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY researcher_search_engine
    ADD CONSTRAINT fk_search_engine_researcher_search_engine FOREIGN KEY (id_search_engine) REFERENCES search_engine(id_search_engine);


--
-- TOC entry 2279 (class 2606 OID 51378)
-- Name: fk_search_field_adapted_query; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY adapted_query_search_field
    ADD CONSTRAINT fk_search_field_adapted_query FOREIGN KEY (id_search_field) REFERENCES search_field(id_search_field);


--
-- TOC entry 2281 (class 2606 OID 51388)
-- Name: fk_search_machine_base_use_criteria; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_use_criteria
    ADD CONSTRAINT fk_search_machine_base_use_criteria FOREIGN KEY (id_search_engine) REFERENCES search_engine(id_search_engine);


--
-- TOC entry 2322 (class 2606 OID 58316)
-- Name: fk_search_study; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study
    ADD CONSTRAINT fk_search_study FOREIGN KEY (id_search) REFERENCES search(id_search);


--
-- TOC entry 2286 (class 2606 OID 51393)
-- Name: fk_selection_criteria_criteria_result_justification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY criteria_result_justification
    ADD CONSTRAINT fk_selection_criteria_criteria_result_justification FOREIGN KEY (id_selection_criteria) REFERENCES selection_criteria(id_selection_criteria);


--
-- TOC entry 2289 (class 2606 OID 51398)
-- Name: fk_selection_criteria_criteria_review_justification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY criteria_review_justification
    ADD CONSTRAINT fk_selection_criteria_criteria_review_justification FOREIGN KEY (id_selection_criteria) REFERENCES selection_criteria(id_selection_criteria);


--
-- TOC entry 2287 (class 2606 OID 51403)
-- Name: fk_selection_result_criteria_result_justification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY criteria_result_justification
    ADD CONSTRAINT fk_selection_result_criteria_result_justification FOREIGN KEY (id_selection_result) REFERENCES selection_result(id_selection_result);


--
-- TOC entry 2314 (class 2606 OID 51408)
-- Name: fk_selection_step_selection_result; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_result
    ADD CONSTRAINT fk_selection_step_selection_result FOREIGN KEY (id_selection_step) REFERENCES selection_step(id_selection_step);


--
-- TOC entry 2319 (class 2606 OID 51413)
-- Name: fk_selection_step_selection_step_researcher; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_step_researcher
    ADD CONSTRAINT fk_selection_step_selection_step_researcher FOREIGN KEY (id_selection_step) REFERENCES selection_step(id_selection_step);


--
-- TOC entry 2276 (class 2606 OID 51418)
-- Name: fk_standard_query_adapted_query; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY adapted_query
    ADD CONSTRAINT fk_standard_query_adapted_query FOREIGN KEY (id_standard_query) REFERENCES standard_query(id_standard_query);


--
-- TOC entry 2332 (class 2606 OID 58247)
-- Name: fk_study_author; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_author
    ADD CONSTRAINT fk_study_author FOREIGN KEY (id_study) REFERENCES study(id_study);


--
-- TOC entry 2284 (class 2606 OID 51423)
-- Name: fk_study_classification; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY classification
    ADD CONSTRAINT fk_study_classification FOREIGN KEY (id_study) REFERENCES study(id_study);


--
-- TOC entry 2291 (class 2606 OID 51428)
-- Name: fk_study_duplicate_study; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY duplicate_study
    ADD CONSTRAINT fk_study_duplicate_study FOREIGN KEY (id_duplicate_study) REFERENCES study(id_study);


--
-- TOC entry 2307 (class 2606 OID 51433)
-- Name: fk_study_review; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY review
    ADD CONSTRAINT fk_study_review FOREIGN KEY (id_study) REFERENCES study(id_study);


--
-- TOC entry 2315 (class 2606 OID 51443)
-- Name: fk_study_selection_result; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY selection_result
    ADD CONSTRAINT fk_study_selection_result FOREIGN KEY (id_study) REFERENCES study(id_study);


--
-- TOC entry 2325 (class 2606 OID 51448)
-- Name: fk_study_study_data; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_data
    ADD CONSTRAINT fk_study_study_data FOREIGN KEY (id_study) REFERENCES study(id_study);


--
-- TOC entry 2329 (class 2606 OID 51453)
-- Name: fk_study_study_summary; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY study_summary
    ADD CONSTRAINT fk_study_study_summary FOREIGN KEY (id_study) REFERENCES study(id_study);


--
-- TOC entry 2331 (class 2606 OID 58206)
-- Name: id_institution; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY author
    ADD CONSTRAINT id_institution FOREIGN KEY (id_institution) REFERENCES institution(id_institution);


--
-- TOC entry 2309 (class 2606 OID 60102)
-- Name: pk_project_search; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY search
    ADD CONSTRAINT pk_project_search FOREIGN KEY (id_project) REFERENCES project(id_project);


-- Completed on 2016-08-16 22:16:35

--
-- PostgreSQL database dump complete
--
--v.0.1.1--

-- Researcher --

-- Add column "cd_uuid". 
ALTER TABLE researcher
  ADD COLUMN cd_uuid text;
ALTER TABLE researcher
  ADD CONSTRAINT uq_cd_uuid UNIQUE (cd_uuid);
  
--Add column "tp_confirmed".
ALTER TABLE researcher
  ADD COLUMN tp_confirmed smallint NOT NULL DEFAULT 0;
ALTER TABLE researcher
  ADD CONSTRAINT ck_tp_confirmed CHECK (tp_confirmed in (0,1));
COMMENT ON CONSTRAINT ck_tp_confirmed ON researcher
  IS 'For ''tp_confirmed'' 0 is ''Account not confirmed'' and 1 is ''Confirmed Account''.';
COMMENT ON COLUMN researcher.tp_confirmed IS 'For ''tp_confirmed'' 0 is ''Account not confirmed'' and 1 is ''Confirmed Account''.';

-- Institution --

-- Add column "tp_confirmed".
ALTER TABLE institution
  ADD COLUMN ds_abbreviation character varying(10);
--ALTER TABLE institution
--  ADD CONSTRAINT uq_ds_abbreviation UNIQUE (ds_abbreviation);
  
  
--v.0.1.2--
ALTER TABLE project RENAME ds_slug  TO ds_key;

-- v.0.1.3 --

ALTER TABLE public.project_member
    ADD COLUMN tp_state character(1) COLLATE pg_catalog."default";
    
-- v.0.1.4 --
 SELECT foo3.id_study,
    foo3.ds_key
   FROM ( SELECT count(foo2.id_study) AS ce,
            foo2.id_study,
            foo2.ds_key
           FROM ( SELECT foo.id_study,
                    foo.tp_status,
                    foo.ds_key
                   FROM ( SELECT r.id_study,
                            r.tp_status,
                            project.ds_key
                           FROM review r
                             LEFT JOIN study USING (id_study)
                             LEFT JOIN project USING (id_project)
                          WHERE r.tp_status <> 0
                          GROUP BY r.id_study, r.tp_status, project.ds_key) foo) foo2
          GROUP BY foo2.id_study, foo2.ds_key) foo3
  WHERE foo3.ce > 1;


INSERT INTO public.search_engine(
	id_search_engine, nm_search_engine)
	VALUES (1, 'MANUAL INSERT');
