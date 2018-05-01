--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: consegne
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO consegne;

SET search_path = public, pg_catalog;

--
-- Name: check_unique_def_lang_delete(); Type: FUNCTION; Schema: public; Owner: consegne
--

CREATE FUNCTION check_unique_def_lang_delete() RETURNS trigger
    AS $$BEGIN
   IF OLD.defaultlanguage THEN
      RAISE EXCEPTION 'Necessario un linguaggio di default';
   END IF;
   RETURN OLD;
END;$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.check_unique_def_lang_delete() OWNER TO consegne;

--
-- Name: check_unique_def_lang_insert(); Type: FUNCTION; Schema: public; Owner: consegne
--

CREATE FUNCTION check_unique_def_lang_insert() RETURNS trigger
    AS $$BEGIN

  IF lang_count() = 0 AND NOT NEW.defaultlanguage THEN
      RAISE EXCEPTION 'Ling. di default necessario';
  END IF;
  RETURN NEW;
END;$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.check_unique_def_lang_insert() OWNER TO consegne;

--
-- Name: check_unique_def_lang_update(); Type: FUNCTION; Schema: public; Owner: consegne
--

CREATE FUNCTION check_unique_def_lang_update() RETURNS trigger
    AS $$BEGIN
   IF OLD.defaultlanguage AND NOT NEW.defaultlanguage THEN
      RAISE EXCEPTION 'Necessario un linguaggio di default';
   END IF;

   IF NOT OLD.defaultlanguage AND NEW.defaultlanguage THEN
      RAISE EXCEPTION 'Linguaggio di default gia presente';
   END IF;
   RETURN NEW;
END;$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.check_unique_def_lang_update() OWNER TO consegne;

--
-- Name: lang_count(); Type: FUNCTION; Schema: public; Owner: consegne
--

CREATE FUNCTION lang_count() RETURNS bigint
    AS $$SELECT COUNT(*) FROM languages$$
    LANGUAGE sql;


ALTER FUNCTION public.lang_count() OWNER TO consegne;

--
-- Name: protect_root_delete(); Type: FUNCTION; Schema: public; Owner: consegne
--

CREATE FUNCTION protect_root_delete() RETURNS trigger
    AS $$BEGIN
    IF OLD.login = 'root' THEN
        RAISE EXCEPTION 'Root non si tocca';
    END IF;
    RETURN OLD;
END;$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.protect_root_delete() OWNER TO consegne;

--
-- Name: protect_root_insert(); Type: FUNCTION; Schema: public; Owner: consegne
--

CREATE FUNCTION protect_root_insert() RETURNS trigger
    AS $$BEGIN
   IF ( NEW.login <> 'root' AND NEW.superuser ) THEN
      RAISE EXCEPTION 'esiste un solo root';
   END IF;
   RETURN NEW;
END;$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.protect_root_insert() OWNER TO consegne;

--
-- Name: protect_root_update(); Type: FUNCTION; Schema: public; Owner: consegne
--

CREATE FUNCTION protect_root_update() RETURNS trigger
    AS $$BEGIN
    IF OLD.login = 'root' AND NEW.login <> 'root' THEN
        RAISE EXCEPTION 'Root non si tocca';
    END IF;
    RETURN NEW;
END;$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.protect_root_update() OWNER TO consegne;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: academicyears; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE academicyears (
    id integer NOT NULL,
    firstyear integer NOT NULL,
    secondyear integer NOT NULL
);


ALTER TABLE public.academicyears OWNER TO consegne;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE admins (
    login character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    superuser boolean DEFAULT false NOT NULL,
    email character varying NOT NULL
);


ALTER TABLE public.admins OWNER TO consegne;

--
-- Name: adminscourses; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE adminscourses (
    login character varying(255) NOT NULL,
    course integer NOT NULL
);


ALTER TABLE public.adminscourses OWNER TO consegne;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: consegne
--

CREATE SEQUENCE hibernate_sequence
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO consegne;

--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: consegne
--

SELECT pg_catalog.setval('hibernate_sequence', 939, true);


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE assignments (
    id integer DEFAULT nextval('hibernate_sequence'::regclass) NOT NULL,
    title character varying(255) NOT NULL,
    starttime timestamp without time zone,
    deadline timestamp without time zone NOT NULL,
    course integer NOT NULL,
    corrected boolean DEFAULT false NOT NULL
);


ALTER TABLE public.assignments OWNER TO consegne;

--
-- Name: assignmentssubmissions; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE assignmentssubmissions (
    exercisenumber integer NOT NULL,
    exercisetext text,
    pseudotext text,
    assignment integer NOT NULL,
    login character varying(255) NOT NULL,
    sourcetoxml text,
    result integer
);


ALTER TABLE public.assignmentssubmissions OWNER TO consegne;

--
-- Name: assignmentstexts; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE assignmentstexts (
    ordinal integer NOT NULL,
    text text DEFAULT '<p></p>'::text NOT NULL,
    assignment integer NOT NULL,
    pseudocode boolean DEFAULT false,
    humanneeded boolean DEFAULT false NOT NULL,
    language integer,
    testcase text,
    submitfilename character varying,
    timeout integer NOT NULL,
    examplefile character varying,
    solution character varying
);


ALTER TABLE public.assignmentstexts OWNER TO consegne;

--
-- Name: auxiliarysourcefile; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE auxiliarysourcefile (
    id integer DEFAULT nextval('hibernate_sequence'::regclass) NOT NULL,
    filename character varying NOT NULL,
    code text NOT NULL,
    source boolean NOT NULL
);


ALTER TABLE public.auxiliarysourcefile OWNER TO consegne;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE courses (
    id integer DEFAULT nextval('hibernate_sequence'::regclass) NOT NULL,
    name character varying(255) NOT NULL,
    aa integer
);


ALTER TABLE public.courses OWNER TO consegne;

--
-- Name: languages; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE languages (
    id integer DEFAULT nextval('hibernate_sequence'::regclass) NOT NULL,
    ext character varying NOT NULL,
    formatter character varying NOT NULL,
    testcasefilename character varying NOT NULL,
    codeanalizer character varying NOT NULL,
    defaultlanguage boolean DEFAULT false NOT NULL,
    compoptions character varying,
    execoptions character varying,
    dir character varying NOT NULL
);


ALTER TABLE public.languages OWNER TO consegne;

--
-- Name: permissions; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE permissions (
    type integer NOT NULL,
    assignment integer NOT NULL,
    exercisenumber integer NOT NULL,
    enabled boolean,
    id integer DEFAULT nextval('hibernate_sequence'::regclass) NOT NULL
);


ALTER TABLE public.permissions OWNER TO consegne;

--
-- Name: results; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE results (
    returncode integer NOT NULL,
    teststdout text,
    seenbyuser boolean,
    pseudook boolean,
    extrainfo character varying,
    id integer DEFAULT nextval('hibernate_sequence'::regclass) NOT NULL
);


ALTER TABLE public.results OWNER TO consegne;

--
-- Name: students; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE students (
    login character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    cognome character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    matricola integer NOT NULL
);


ALTER TABLE public.students OWNER TO consegne;

--
-- Name: testerrors; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE testerrors (
    id integer DEFAULT nextval('hibernate_sequence'::regclass) NOT NULL,
    type integer,
    line integer,
    code character varying,
    error character varying,
    file character varying,
    result integer
);


ALTER TABLE public.testerrors OWNER TO consegne;

--
-- Name: texts_auxsrcs; Type: TABLE; Schema: public; Owner: consegne; Tablespace: 
--

CREATE TABLE texts_auxsrcs (
    assignment integer NOT NULL,
    ordinal integer NOT NULL,
    idsrc integer NOT NULL
);


ALTER TABLE public.texts_auxsrcs OWNER TO consegne;

--
-- Data for Name: academicyears; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY academicyears (id, firstyear, secondyear) FROM stdin;
567	2008	2009
684	2009	2010
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY admins (login, password, superuser, email) FROM stdin;
root	c5d989754021820cbcd813c96712e92b	t	root-consegne@dsi.unive.it
mdaddett	8b95680680889896ae0b2355eb806b02	f	mdaddett@dsi.unive.it
agaspare	777976047181fa36b4d5962bed72ed6c	f	kelendil87@gmail.com
gcostant	4648d8f717f64e8c9a7bef0dc1ecd3fe	f	malvoria@gmail.com
gmaggior	47d262e776cad5e371a028fd90ade663	f	giuseppemag@gmail.com
leonardi	09375e2ca8bcd02ec2290cc139a421af	f	leonardi@dsi.unive.it
\.


--
-- Data for Name: adminscourses; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY adminscourses (login, course) FROM stdin;
mdaddett	685
agaspare	685
gcostant	685
gmaggior	685
leonardi	743
leonardi	770
mdaddett	770
\.


--
-- Data for Name: assignments; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY assignments (id, title, starttime, deadline, course, corrected) FROM stdin;
571	ultima esercitazione dell'anno!!!	2008-12-23 13:31:00	2008-12-31 23:57:00	570	f
643	prova d'esame 1	\N	2009-03-27 08:00:00	584	t
593	esercitazione esempio	2009-01-29 11:38:52.624	2009-01-29 13:00:00	584	t
704	prova2	2009-10-08 10:48:14.681	2009-10-10 08:00:00	584	f
631	es test manuale	2009-03-24 22:44:48.411	2009-03-24 23:00:00	584	t
648	es test manuale 2	2009-03-28 10:56:16.878	2009-03-28 11:10:00	584	t
585	prima prova	2009-01-17 08:00:00	2009-01-24 08:00:00	584	t
656	nuova esercitazione	\N	2009-03-29 08:00:00	584	t
771	Prova 1 leo	2009-10-21 13:05:00	2009-10-21 13:07:00	770	f
780	Prova 2 leo	2009-10-21 18:29:06.849	2009-10-21 18:40:00	770	t
576	prima esercitazione dell'anno	2009-01-07 12:46:00	2009-01-07 13:15:00	570	t
744	Esercitazione 1	2009-10-21 14:00:00	2009-10-27 23:59:00	743	f
804	ASD 1 leonardi	2009-10-21 20:00:00	2009-10-23 18:00:00	770	f
691	Esercitazione 1	2009-10-22 00:50:10.491	2009-10-22 18:00:00	685	f
806	Esercitazione 2	2009-10-22 13:10:29.68	2009-10-29 18:00:00	685	f
811	Esercitazione 3	2009-10-22 13:12:16.278	2009-10-29 18:00:00	685	f
672	Provanuova	2009-04-07 20:00:11.27	2009-04-08 09:00:00	584	t
657	Nome (Titolo)	2009-04-07 10:26:10.437	2009-04-07 10:30:00	584	t
\.


--
-- Data for Name: assignmentssubmissions; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY assignmentssubmissions (exercisenumber, exercisetext, pseudotext, assignment, login, sourcetoxml, result) FROM stdin;
1	#include <stdio.h>\r\n#include <stdlib.h>\r\n#include "item.h"\r\n\r\nstruct stack{     /* tipo dello stack realizzato con array */\r\n  Item * contents;\r\n  int top;\r\n  int dim;             /* dimensione dell'array */\r\n};\r\n\r\ntypedef struct stack *Stack;\r\n\r\n/*post: costruisce uno stack vuoto */\r\nStack initstack(){\r\n\tStack s;\r\n\ts = (Stack) malloc(sizeof(struct stack));\r\n\ts->top = -1;\r\n\ts->dim = 0;\r\n\treturn s;\r\n}\r\n\r\n/*post: ritorna 1 se lo stack e' vuoto, 0 altrimenti */\r\nint emptystack(Stack s){\r\n\treturn s->top == -1;\r\n}\r\n\r\n/*post: inserisce elem in cima allo stack */\r\nvoid push(Stack s, Item elem){\r\n\tif (s->dim == 0){\r\n\t\ts->contents = (Item*) malloc(sizeof(Item) * s->dim);\r\n\t\ts->dim++;\r\n\t}\r\n\telse if (s->top + 2 > s->dim){\r\n\t\ts->dim *= 2;\r\n\t\ts->contents = (Item*) realloc(s->contents, (sizeof(Item) * s->dim ));\r\n\t\ts->contents[++(s->top)] = elem;\r\n\t\treturn;\r\n\t}\r\n\ts->contents[++(s->top)] = elem;\r\n\tprintf("h %d , n %d\\n", s->dim, s->top+1);\r\n}\r\n\r\n/*pre: stack non vuoto */\r\n/*post: ritorna e rimuove l'elemento in cima allo stack */\r\nItem pop(Stack s){\r\n\tif ( (s->top + 1) <= (s->dim / 4) ){\r\n\t\ts->dim /= 2;\r\n\t\ts->contents = (Item*) realloc(s->contents, sizeof(Item) * s->dim);\r\n\t\treturn s->contents[(s->top)--];\r\n\t}\t\r\n \treturn s->contents[(s->top)--];\r\n}\r\n\r\n/*pre: stack non vuoto */\r\n/*post: ritorna l'elemento in cima allo stack */\r\nItem top(Stack s){\r\n\treturn s->contents[s->top];\r\n}\r\n\r\n/*post: ritorna il numero di elementi nello stack */\r\nint size(Stack s){\r\n\treturn s->top + 1;  \r\n}\r\n		744	msoprano	\N	\N
2	void inverti(Stack s){\r\n\tStack temp1, temp2;\r\n\ttemp1 = initstack();\r\n\ttemp2 = initstack();\r\n\twhile (!emptystack(s)){\r\n\t\tpush(temp1, pop(s));\r\n\t}\r\n\twhile (!emptystack(temp1)){\r\n\t\tpush(temp2, pop(temp1));\r\n\t}\r\n\twhile (!emptystack(temp2)){\r\n\t\tpush(s, pop(temp2));\r\n\t}\r\n\tfree(temp1);\r\n\tfree(temp2);\r\n}		744	msoprano	\N	\N
1	let f = fun x -> if x < 0 then 0 else 2*x		691	agaspare	\N	\N
2	let media x y z = float(x + y + z) /. 3		691	agaspare	\N	\N
3	#include <stdio.h>\r\n\r\nvoid main() {}		691	agaspare	\N	\N
1	package test.test0;public class Prova {\n    \n    public int metodo(int i){\n        return i++;\n    }\n\n}\n		657	dseno	\N	681
1	#include <stdlib.h>\r\n#include <stdio.h>\r\n#include "../Item/item.h"\r\n#include "stack.h"\r\n\r\nstruct stack{     /* tipo dello stack realizzato con array */\r\n  Item * contents;\r\n  int top;\r\n  int dim;             /* dimensione dell'array */\r\n};\r\n\r\n/*post: costruisce uno stack vuoto */\r\nStack initstack(){\r\n  Stack tempstack;\r\n  tempstack=(Stack)malloc(sizeof(struct stack));\r\n  tempstack->contents= (Item*)malloc(sizeof(Item));\r\n  tempstack->top=-1;\r\n  tempstack->dim=1;\r\n  return tempstack;\r\n}\r\n\r\n/*post: ritorna 1 se lo stack e' vuoto, 0 altrimenti */\r\nint emptystack(Stack s){\r\n  if ((s->top)==-1)\r\n    return 1;\r\n  else\r\n    return 0;\r\n}\r\n\r\n/*post: inserisce elem in cima allo stack */\r\nvoid push(Stack s, Item elem){\r\n  ++(s->top);\r\n  if ((s->top)>=(s->dim)){\r\n    s->dim*=2;\r\n    s->contents=realloc((s->contents),(s->dim)*sizeof(Item));\r\n  }\r\n  (s->contents)[(s->top)]=elem;\r\n\r\n}\r\n\r\n/*pre: stack non vuoto */\r\n/*post: ritorna e rimuove l'elemento in cima allo stack */\r\nItem pop(Stack s){\r\n  --(s->top);\r\n  if ((s->top)<=(((s->dim)/4)-1)){\r\n    s->dim/=2;\r\n    s->contents=realloc((s->contents),(s->dim)*sizeof(Item));\r\n  }\r\n}\r\n\r\n/*pre: stack non vuoto */\r\n/*post: ritorna l'elemento in cima allo stack */\r\nItem top(Stack s){\r\n  return (s->contents)[(s->top)];\r\n}\r\n\r\n/*post: ritorna il numero di elementi nello stack */\r\nint size(Stack s){\r\n  return (s->top)+1;\r\n}\r\n\r\n		744	mparpagi	\N	\N
1	#define SIZEOCC 7 - (-3) + 1\r\nint maxoccorrenza(int v[], int dim) {\r\n  int occ[SIZEOCC], i, max;\r\n  \r\n  for(i = 0; i < SIZEOCC; i++) {\r\n    occ[i] = 0;\r\n  }\r\n\r\n  for(i = 0; i < dim; i++) {\r\n    occ[v[i] - (-3)]++;\r\n  }\r\n\r\n  max = 0;\r\n  for(i = 1; i < SIZEOCC; i++)\r\n    if (occ[max] < occ[i])\r\n      max = i;\r\n\r\n  return max - 3;\r\n}		771	lleonard	\N	\N
1	#define SIZEOCC 7 - (-3) + 1\r\nint maxoccorrenza(int v[], int dim) {\r\n  int occ[SIZEOCC], i, max;\r\n  \r\n  for(i = 0; i < SIZEOCC; i++) {\r\n    occ[i] = 0;\r\n  }\r\n\r\n  for(i = 0; i < dim; i++) {\r\n    occ[v[i] - (-3)]++;\r\n  }\r\n\r\n  max = 0;\r\n  for(i = 1; i < SIZEOCC; i++)\r\n    if (occ[max] < occ[i])\r\n      max = i;\r\n\r\n  return max - 3;\r\n}	Questo Ã¨ dello pseudocodice!	780	lleonard	\N	931
2	#define SIZEOCC 7 - (-3) + 1\r\nint maxoccorrenza(int v[], int dim) {\r\n  int occ[SIZEOCC], i, max;\r\n  \r\n  for(i = 0; i < SIZEOCC; i++) {\r\n    occ[i] = 0;\r\n  }\r\n\r\n  for(i = 0; i < dim; i++) {\r\n    occ[v[i] - (-3)]++;\r\n  }\r\n\r\n  max = 0;\r\n  for(i = 1; i < SIZEOCC; i++)\r\n    if (occ[max] > occ[i])\r\n      max = i;\r\n\r\n  return max - 3;\r\n}	Questo Ã¨ dello pseudocodice!	780	lleonard	\N	932
3	int maxoccorrenza(int a, int b) {\r\nreturn a+b;\r\n}	Questo Ã¨ dello pseudocodice!	780	lleonard	\N	936
2	wsdasdasdas123132123		691	mdaddett	\N	\N
1	asdadasdaslhlkklklh		691	mdaddett	\N	\N
\.


--
-- Data for Name: assignmentstexts; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY assignmentstexts (ordinal, text, assignment, pseudocode, humanneeded, language, testcase, submitfilename, timeout, examplefile, solution) FROM stdin;
1	<p>esercitazione di esempio.</p>\r\n<p>implementare l'interfaccia Pert (inserita come file ausiliario), definendo il metodo</p>\r\n<p><span style="color: rgb(255, 255, 255);"><span style="background-color: rgb(255, 0, 0);"><strong>public int fact(&nbsp;int n ) </strong></span></span></p>\r\n<p>che ritorna il fattoriale di un numero n &gt;= 0</p>	593	f	f	586	public class Test extends test.ClassicTestCase {\r\n\r\n\r\n\t/*\r\n\tmetodo 'trusted' utilizzato per generare i testcase\r\n\t*/\r\n\tpublic static int myfact( int n ) { return n <= 1 ? 1 : n * myfact(n-1);  }\r\n\r\n\tpublic void test() {\r\n\r\n\t\tPert c = new Consegna();\r\n\r\n\t\tfor ( int i = 0; i < 20; i++ ) {\r\n\r\n\t\t\tif ( c.fact( i ) != myfact( i ) ) {\r\n\r\n\t\t\t\t/*\r\n\t\t\t\tprimo parametro: fact --> nome metodo\r\n\t\t\t\tsecondo parametro: test1 failed --> codice errore, non ha un grande significato.. quindi si puo' mettere anche una stringa vuota ( avevo cmq pensato a toglierlo.. )\r\n\t\t\t\tterzo parametro: descrizione errore\r\n\t\t\t\tquarto parametro ( puo' essere piu' di uno ) int --> tipo dei parametri del metodo indicato (fact)\r\n\t\t\t\tNOTA BENE: raiseError non interrompe l'esecuzione del programma, ma indica solo la presenza di un errore.\r\n\t\t\t\tse si vuole terminare questo ciclo e' necessario quindi usare un break o introdurre una variabile..\r\n\t\t\t\t*/\r\n\t\t\t\tthis.raiseError( "fact", "test1 failed", "fact fallisce con input " + i, "int" );\r\n\t\t\t\t// break;\r\n\t\t\t}\r\n\r\n\t\t}\r\n\r\n\t}\r\n\r\n}	Consegna.java	20	public class Consegna implements Pert {\r\n\r\n\tpublic int fact( int n ) { return 1000000; }\r\n\r\n}	public class Consegna implements Pert {\r\n\r\n\tpublic int fact( int n ) { return n <= 1 ? 1 : n * fact(n-1); }\r\n\r\n}
1	<p>ultimo sotto-esercizio dell'anno!! EVVIVA, BUON 2009!!</p>\r\n<p><img alt="" src="https://consegne.dsi.unive.it/consegne/fckeditor/editor/images/smiley/msn/shades_smile.gif" /></p>\r\n<p>dovete implementare la funzione</p>\r\n<p><strong>int fattoriale( int n )</strong> che restituisca il fattoriale di un numero n &gt;= 0</p>\r\n<p><strong><span style="background-color: rgb(255, 255, 0);"><span style="color: rgb(255, 0, 0);">BUON LAVORO!!</span></span></strong></p>\r\n<p>&nbsp;</p>	571	f	f	569	/* includere il file test_api.h situato durante il test in ../../test_api.h */\n#include "../test_api.h"\n#include "consegna.c"\n#include <string.h>\n\nint mioFattoriale( int n ) {\n    if ( n == 0 || n == 1 ) return 1;\n    return n * mioFattoriale( n - 1 );\n}\n\nint main() {\n    int i = 0;\n    for ( ; i < 30; i++ ) {\n        int corretto = fattoriale( i );\n        int bo = mioFattoriale( i );\n        if ( corretto != bo ) { \n           test_error( "fattoriale","wrong","fattoriale fallisce con input %d ( %d anziche' %d )", i, corretto, bo );\n        }\n    }\n  return no_errors();\n}\n	consegna.c	200	int fattoriale( int n ) {\n    if ( n == 0 || n == 1 ) return 1;\n    return n * fattoriale( n - 1 );\n}\n\n	
1	<p>primo sotto-esercizio dell'anno!!!</p>\r\n<p>ENJOY!!!</p>\r\n<p>WE ROCK!</p>\r\n<p>&nbsp;</p>\r\n<p>scrivere una funzione int fattoriale( int n ) che calcola il fattoriale di un intero n &gt;= 0</p>	576	f	f	569	/* includere il file test_api.h situato durante il test in ../../test_api.h */\n#include "../test_api.h"\n#include "consegna.c"\n#include <string.h>\n\nint mioFattoriale( int n ) {\n    if ( n == 0 || n == 1 ) return 1;\n    return n * mioFattoriale( n - 1 );\n}\n\nint main() {\n    int i = 0;\n    for ( ; i < 30; i++ ) {\n        int corretto = fattoriale( i );\n        int bo = mioFattoriale( i );\n        if ( corretto != bo ) { \n           test_error( "fattoriale","wrong","fattoriale fallisce con input %d ( %d anziche' %d )", i, corretto, bo );\n        }\n    }\n  return no_errors();\n}\n	consegna.c	20		
2	<p></p>	585	f	f	569			20		
1	<p>Scrivere la classe Port.java che implementa l'interfaccia Pert.java.</p>	585	f	f	586		Port.java	20		/*\n * To change this template, choose Tools | Templates\n * and open the template in the editor.\n */\n\n\n/**\n *\n * @author roncato\n */\npublic class Port implements Pert {\n\n    public int fact(int n) {\n        return n * fact(n - 1);\n    }\n}\n
2	<p>Scrivere una procedura per il calcolo della media di tre numeri.<br />\r\n<br />\r\nNota: Se usate OCaML, fate attenzione perch&egrave; l&rsquo;operatore che effettua la divisione intera &egrave; (/), mentre quello per la divisione tra numeri decimali &egrave; (/.). In F# invece usate / sia per la divisione intera che per quella decimale.<br />\r\n<br />\r\nNota2: la funzione float converte un intero in numero decimale: (float 3) ritorna 3.0.<br />\r\n<br />\r\nFIRMA: la firma della funzione deve essere fun int -&gt; int -&gt; int -&gt; float.</p>	691	f	t	569		test.c	0	 let esercizio2 = \r\n            fun x1 x2 x3 -> 0.0\r\n	
3	<p>Scrivere una procedura che dato un prezzo (in forma di numero decimale) e una percentuale (un numero decimale tra 0.0 e 1.0) ritorna il prezzo scontato della percentuale se il prezzo &egrave; inferiore a 10000.0, altrimenti ritorna il prezzo originale.<br />\r\n<br />\r\nFIRMA: la firma della funzione deve essere fun float -&gt; float -&gt; float.</p>	691	f	t	569		test.c	0	let esercizio3 = \r\n            fun prezzo percentuale -> 0.0\r\n	
1	<p>Scrivere una procedura <em>figure</em> che visualizzi separatamente l''uno sotto l''altro le seguenti figure la cui altezza e larghezza e` n &gt; 1 (<strong>dispari</strong>), che e` un parametro di input della procedura.</p>\r\n<p>Il prototipo della procedura e`:<br />\r\n<br />\r\n<strong>void figure(int n)</strong><br />\r\n&nbsp;</p>\r\n<pre>\r\n*******\r\n     *\r\n    *\r\n   *\r\n  *\r\n********</pre>\r\n<pre>\r\n&nbsp;</pre>\r\n<pre>\r\n0&nbsp;&nbsp;&nbsp;&nbsp; 001&nbsp;&nbsp; 10010 0100101010010 01001&nbsp;  100&nbsp;&nbsp;&nbsp;&nbsp; 0</pre>\r\n<p><br />\r\nSi possono usare <strong>solo</strong> le seguenti istruzioni di stampa:<br />\r\nprintf(&quot; &quot;)<br />\r\nprintf(&quot;*&quot;)<br />\r\nprintf(&quot;0&quot;)<br />\r\nprintf(&quot;1&quot;)<br />\r\nprintf(&quot;\\\\n&quot;)<br />\r\n<br />\r\n[Nota: La stampa di ogni figura puo` essere eseguita con<br />\r\n2 soli cicli for annidati].</p>\r\n<p>&nbsp;<strong><u>Consegnare SOLO la procedura <em>figure</em> ed eventuali funzioni ausiliarie utilizzate al suo interno.</u></strong></p>\r\n<p>&nbsp;</p>	631	f	t	569		figure.c	20		
2	<p>Esercizio 1 di <a href="http://www.dsi.unive.it/~mp/Homeworks/01.pdf">http://www.dsi.unive.it/~mp/Homeworks/01.pdf</a></p>	631	f	t	586	package test;\n\npublic class Test extends test.JAppletTestCase {\n\n    @Override\n    public void test() {\n        EmptyFrameViewer.main( null );\n    }\n    \n}\n\n	EmptyFrameViewer.java	20		
1	<p></p>	643	f	f	569			20		
1	<p>disegnare una faccina su schermo usando la libreria awt o, alternativamente, la libreria javax.swing.</p>	648	f	t	586	package test;\n\npublic class Test extends test.JAppletTestCase {\n\n    @Override\n    public void test() {\n        EmptyFrameViewer.main( null );\n    }\n    \n    \n}\n\n	EmptyFrameViewer.java	20		
1	<p></p>	656	f	f	569			20		
2	<p></p>	656	f	f	569			20		
1	<p>Prova a fare al classe di Prova.</p>	657	f	f	586	/*\n * To change this template, choose Tools | Templates\n * and open the template in the editor.\n */\n\npackage provajassignement;\n\n/**\n *\n * @author Roncato\n */\npublic class Test extends test.ClassicTestCase{\n    \n    public void test(){\n        Prova p = new Prova();\n        if (p.metodo(2)!=3)\n            this.raiseMethodError("metodo","4","causa","int");\n    }\n\n}\n	Prova.java	20	/*\n * To change this template, choose Tools | Templates\n * and open the template in the editor.\n */\n\npackage provajassignement;\n\n/**\n *\n * @author Roncato\n */\npublic class Prova {\n    \n    public int metodo(int i){\n        return ++i;\n    }\n\n}\n	/*\n * To change this template, choose Tools | Templates\n * and open the template in the editor.\n */\n\npackage provajassignement;\n\n/**\n *\n * @author Roncato\n */\npublic class Prova {\n    \n    public int metodo(int i){\n        return ++i;\n    }\n\n}\n
1	<p></p>	672	f	f	569			20		
1	<p>&nbsp;</p>	704	f	f	586		a	20		
1	<p>Scrivere una procedura che prenda in input un numero intero x e restituisca:<br />\r\n&nbsp;</p>\r\n<p>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; se x &lt; 0<br />\r\n2*x&nbsp;&nbsp; se 0 &lt;= x &lt; 10<br />\r\n20&nbsp;&nbsp;&nbsp;&nbsp; se x &gt;= 10<br />\r\n<br />\r\nNota: usare il costrutto if-then-else &egrave; utile ma non strettamente indispensabile. Potete pensare ad una soluzione ottenuta tramite l&rsquo;uso di due funzioni gi&agrave; presenti nel linguaggio: min e max, che dati due valori ritornano rispettivamente il minimo e il massimo fra i due.<br />\r\n<br />\r\nFIRMA: la firma della funzione deve essere fun int -&gt; int</p>	691	f	t	569		test.c	0	 let esercizio1 = \r\n            fun x -> 0\r\n	
3	<p>Scrivere una procedura per invertire il contenuto di una coda usando solo le operazioni del tipo di dato Coda definite in queue.h. Quale&nbsp;&egrave; la complessit&agrave; della procedura?</p>\r\n<p>Il prototipo della procedura &egrave;:</p>\r\n<p>void inverti(Queue q)</p>	744	t	t	569		es1_3	20		
1	<p>Progettare una realizzazione del tipo di dato Pila che utilizza un array dinamico. Deve essere implementata la seguente tecnica di raddoppiamento e&nbsp; dimezzamento. Sia n il numero di elementi nella pila e h la dimensione dell'array dinamico.</p>\r\n<ul>\r\n    <li>Inizialmente, quando n = 0, poniamo h = 1.</li>\r\n    <li>Ogni qualvolta n supera h, l'array viene riallocato raddoppiando la dimensione.</li>\r\n    <li>Ogni qualvolta n scende a h/4, l'array viene riallocato dimezzandone la dimensione.</li>\r\n</ul>\r\n<p>Completare il file implStackArrayDinamicoesercizio.c</p>	744	f	t	569		es1_1.c	20	﻿#include <stdlib.h>\n#include <stdio.h>\n#include "../Item/item.h"\n#include "stack.h"\n\nstruct stack{     /* tipo dello stack realizzato con array */\n  Item * contents;\n  int top;\n  int dim;             /* dimensione dell'array */\n};\n\n/*post: costruisce uno stack vuoto */\nStack initstack(){\n...\n}\n\n/*post: ritorna 1 se lo stack e' vuoto, 0 altrimenti */\nint emptystack(Stack s){\n...\n}\n\n/*post: inserisce elem in cima allo stack */\nvoid push(Stack s, Item elem){\n...  \n}\n\n/*pre: stack non vuoto */\n/*post: ritorna e rimuove l'elemento in cima allo stack */\nItem pop(Stack s){\n...  \n}\n\n/*pre: stack non vuoto */\n/*post: ritorna l'elemento in cima allo stack */\nItem top(Stack s){\n...  \n}\n\n/*post: ritorna il numero di elementi nello stack */\nint size(Stack s){\n...  \n}\n	
2	<p>Scrivere una procedura per invertire il contenuto di una pila usando solo le operazioni del tipo di dato Pila definite in stack.h. Quale&nbsp;&egrave; la complessit&agrave; della procedura?</p>\r\n<p>Il prototipo della procedura &egrave;:</p>\r\n<p>void inverti(Stack s)</p>	744	t	t	569		es1_2.c	20		
4	<p>Scrivere una funzione iterativa con tempo O(n) che inverte una lista semplice di n elementi. La funzione deve utilizzare non pi&ugrave; di una quantit&agrave; costante di memoria oltre a quella richiesta per la lista stessa.</p>	744	f	t	569		es1_4.c	20		
1	<p>Scrivere un programma che chiede all'utente un numero<br />\r\nintero dim, positivo, quindi invoca una procedura caricamento che dato<br />\r\nun vettore di interi di dimensione dim carica tale vettore con numeri<br />\r\ninteri nell'intervallo [-3, 7] forniti dall'utente. Poi il programma<br />\r\nprincipale invoca la funzione maxoccorrenza che restituisce un<br />\r\nelemento nel vettore che occorre il massimo numero di volte e infine<br />\r\nil risultato di tale funzione viene stampato.&nbsp; [Nota: Il vettore e`<br />\r\nstatico].</p>\r\n<p>Il prototipo della procedura e della funzione sono:<br />\r\nvoid caricamento(int v[], int dim)</p>\r\n<p>int maxoccorrenza(int v[], int dim)</p>\r\n<p>Il vettore v puo` essere scorso una sola volta per calcolare un<br />\r\nelemento nel vettore che occorre il massimo numero di volte.</p>	771	f	f	569	#include "../test_api.h"\r\n#include "es1_1.c"\r\n#include <stdio.h>\r\n#include <stdlib.h>\r\n#define MAXDIM 30\r\n\r\n\r\nint main() {\r\n\tint v[] = {3, -2, 5, 7, 6, -1};\r\n\tint dim = 6;\r\n\tint res;\r\n\tint i;\r\n\tint div = 0;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tfor(i = 0; i < dim; i++) {\r\n\t\tif(res != v[i]) div++;\r\n\t}\r\n\t\r\n\tif(div != 5) {\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{3,-2,5,7,6,-1}", dim );\r\n\t}\r\n\t\t\r\n\tv[2] = -2;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tif(res != -2)\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{3,-2,-2,7,6,-1}", dim );\r\n\t\t\r\n\tv[0] = -3;\r\n\tv[3] = -2;\r\n\tv[4] = -2;\r\n\tv[5] = -3;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tif(res != -2) {\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{-3,-2,-2,-2,-2,-3}", dim );\r\n\t}\r\n\r\n    return no_errors();\r\n}\r\n	es1_1.c	20	#define SIZEOCC 7 - (-3) + 1\r\n\r\nint maxoccorrenza(int v[], int dim) {\r\n  int occ[SIZEOCC], i, max;\r\n  \r\n  for(i = 0; i < SIZEOCC; i++) {\r\n    occ[i] = 0;\r\n  }\r\n\r\n  for(i = 0; i < dim; i++) {\r\n    occ[v[i] - (-3)]++;\r\n  }\r\n\r\n  max = 0;\r\n  for(i = 1; i < SIZEOCC; i++)\r\n    if (occ[max] < occ[i])\r\n      max = i;\r\n\r\n  return max - 3;\r\n}	/* Questa � la soluzione */\r\n\r\nint maxoccorrenza(int v[], int dim) {\r\n  int occ[SIZEOCC], i, max;\r\n  \r\n  for(i = 0; i &lt; SIZEOCC; i++) {\r\n    occ[i] = 0;\r\n  }\r\n\r\n  for(i = 0; i &lt; dim; i++) {\r\n    occ[v[i] - (-3)]++;\r\n  }\r\n\r\n  max = 0;\r\n  for(i = 1; i &lt; SIZEOCC; i++)\r\n    if (occ[max] &lt; occ[i])\r\n      max = i;\r\n\r\n  return max - 3;\r\n}
5	<p>Realizzare il tipo lista con liste semplici i cui elementi sono ordinati e gli elementi sono tutti distinti.</p>\r\n<p>Completare il file implListOrdesercizio.c.</p>	744	f	f	569		es1_5.c	20	﻿#include <stdlib.h>\n#include "../Item/item.h"\n#include "list.h"\n\nstruct node{\n  Item info;\n  struct node * next;\n};\n\nstruct list{\n  Node head;\n  int size;\n};\n\n\n/*post: restituisce una lista vuota */\nList crealista(){\n...\n}\n\n/*post: restituisce 1 se l e' vuota, 0 altrimenti. */\nint isemptylist(List l){\n...\n}\n\n/*post: restituisce il primo nodo con chiave k, se esiste, NULL altrimenti */\nNode search(List l, Item k){\n...\n}\n\n\n/*post: inserisce un nodo con chiave k nella lista */\nvoid insert(List l, Item k){\n...\n}\n\n/*post: cancella la prima occorrenza di un nodo con chiave k nella lista */\nvoid delete(List l, Item k){\n...\n}\n\n/*pre: n e' un nodo della lista */\n/*post: restituisce il valore contenuto nel nodo della lista */\nItem leggiLista(List l, Node n){\n...\n}\n\n/*post: restituisce il primo nodo della lista*/\nNode primolista(List l){\n...\n}\n\n/*pre: n e' un nodo della lista */\n/*post: restituisce il nodo successivo al nodo n */\n  Node succlista(List l, Node n){\n...\n}\n\n/*pre: n e' un nodo della lista */\n/*post: restituisce il nodo predecessore al nodo n */\n  Node predlista(List l, Node n){\n...\n}\n\n/*pre: n e' un nodo della lista */\n/*post: se il nodo n e' la finelista (NULL in questa implementazione)\n  allora 1, altrimenti 0*/\nint finelista(List l, Node n){\n...\n}\n\n/*post: restituisce una nuova lista che e' formata da tutti gli elementi di l1 e di l2. Le liste l1 e l2 sono distrutte dall'operazione. */\nList merge(List l1, List l2){\n...\n}\n\n/*post: ritorna il numero di elementi nella lista */\nint size(List l){\n...\n}\n	
1	<p>Solito dell'altra!!!</p>	780	t	f	569	#include "../test_api.h"\r\n#include "es1_1.c"\r\n#include <stdio.h>\r\n#include <stdlib.h>\r\n#define MAXDIM 30\r\n\r\n/*\r\nScrivere un programma che chiede all'utente un numero intero dim, positivo, \r\nquindi invoca una procedura caricamento che dato un vettore di interi di dimensione \r\ndim carica tale vettore con numeri interi nell'intervallo [-3, 7] forniti dall'utente.\r\nPoi il programma principale invoca la funzione maxoccorrenza che restituisce un \r\nelemento nel vettore che occorre il massimo numero di volte e infine il risultato\r\ndi tale funzione viene stampato.\r\n\r\n[Nota: Il vettore � statico].\r\nIl prototipo della procedura e della funzione sono:\r\nvoid caricamento(int v[], int dim)\r\nint maxoccorrenza(int v[], int dim)\r\nNOTA: Il vettore v puo` essere scorso una sola volta per calcolare un elemento \r\nnel vettore che occorre il massimo numero di volte.\r\n*/\r\n\r\n\r\nint main() {\r\n\tint v[] = {3, -2, 5, 7, 6, -1};\r\n\tint dim = 6;\r\n\tint res;\r\n\tint i;\r\n\tint div = 0;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tfor(i = 0; i < dim; i++) {\r\n\t\tif(res != v[i]) div++;\r\n\t}\r\n\t\r\n\tif(div != 5) {\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{3,-2,5,7,6,-1}", dim );\r\n\t}\r\n\t\t\r\n\tv[2] = -2;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tif(res != -2)\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{3,-2,-2,7,6,-1}", dim );\r\n\t\t\r\n\tv[0] = -3;\r\n\tv[3] = -2;\r\n\tv[4] = -2;\r\n\tv[5] = -3;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tif(res != -2) {\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{-3,-2,-2,-2,-2,-3}", dim );\r\n\t}\r\n\r\n    return no_errors();\r\n}\r\n	es1_1.c	20	#define SIZEOCC 7 - (-3) + 1\r\n\r\nint maxoccorrenza(int v[], int dim) {\r\n  int occ[SIZEOCC], i, max;\r\n  \r\n  for(i = 0; i < SIZEOCC; i++) {\r\n    occ[i] = 0;\r\n  }\r\n\r\n  for(i = 0; i < dim; i++) {\r\n    occ[v[i] - (-3)]++;\r\n  }\r\n\r\n  max = 0;\r\n  for(i = 1; i < SIZEOCC; i++)\r\n    if (occ[max] < occ[i])\r\n      max = i;\r\n\r\n  return max - 3;\r\n}	/* Questa � la soluzione */\r\n\r\nint maxoccorrenza(int v[], int dim) {\r\n  int occ[SIZEOCC], i, max;\r\n  \r\n  for(i = 0; i &lt; SIZEOCC; i++) {\r\n    occ[i] = 0;\r\n  }\r\n\r\n  for(i = 0; i &lt; dim; i++) {\r\n    occ[v[i] - (-3)]++;\r\n  }\r\n\r\n  max = 0;\r\n  for(i = 1; i &lt; SIZEOCC; i++)\r\n    if (occ[max] &lt; occ[i])\r\n      max = i;\r\n\r\n  return max - 3;\r\n}
2	<p>Solito!</p>	780	f	f	569	#include "../test_api.h"\r\n#include "es1_1.c"\r\n#include <stdio.h>\r\n#include <stdlib.h>\r\n#define MAXDIM 30\r\n\r\n/*\r\nScrivere un programma che chiede all'utente un numero intero dim, positivo, \r\nquindi invoca una procedura caricamento che dato un vettore di interi di dimensione \r\ndim carica tale vettore con numeri interi nell'intervallo [-3, 7] forniti dall'utente.\r\nPoi il programma principale invoca la funzione maxoccorrenza che restituisce un \r\nelemento nel vettore che occorre il massimo numero di volte e infine il risultato\r\ndi tale funzione viene stampato.\r\n\r\n[Nota: Il vettore � statico].\r\nIl prototipo della procedura e della funzione sono:\r\nvoid caricamento(int v[], int dim)\r\nint maxoccorrenza(int v[], int dim)\r\nNOTA: Il vettore v puo` essere scorso una sola volta per calcolare un elemento \r\nnel vettore che occorre il massimo numero di volte.\r\n*/\r\n\r\n\r\nint main() {\r\n\tint v[] = {3, -2, 5, 7, 6, -1};\r\n\tint dim = 6;\r\n\tint res;\r\n\tint i;\r\n\tint div = 0;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tfor(i = 0; i < dim; i++) {\r\n\t\tif(res != v[i]) div++;\r\n\t}\r\n\t\r\n\tif(div != 5) {\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{3,-2,5,7,6,-1}", dim );\r\n\t}\r\n\t\t\r\n\tv[2] = -2;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tif(res != -2)\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{3,-2,-2,7,6,-1}", dim );\r\n\t\t\r\n\tv[0] = -3;\r\n\tv[3] = -2;\r\n\tv[4] = -2;\r\n\tv[5] = -3;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tif(res != -2) {\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{-3,-2,-2,-2,-2,-3}", dim );\r\n\t}\r\n\r\n    return no_errors();\r\n}\r\n	es1_1.c	20		
3	<p>Solito!!!</p>	780	f	f	569	#include "../test_api.h"\r\n#include "es1_1.c"\r\n#include <stdio.h>\r\n#include <stdlib.h>\r\n#define MAXDIM 30\r\n\r\n/*\r\nScrivere un programma che chiede all'utente un numero intero dim, positivo, \r\nquindi invoca una procedura caricamento che dato un vettore di interi di dimensione \r\ndim carica tale vettore con numeri interi nell'intervallo [-3, 7] forniti dall'utente.\r\nPoi il programma principale invoca la funzione maxoccorrenza che restituisce un \r\nelemento nel vettore che occorre il massimo numero di volte e infine il risultato\r\ndi tale funzione viene stampato.\r\n\r\n[Nota: Il vettore � statico].\r\nIl prototipo della procedura e della funzione sono:\r\nvoid caricamento(int v[], int dim)\r\nint maxoccorrenza(int v[], int dim)\r\nNOTA: Il vettore v puo` essere scorso una sola volta per calcolare un elemento \r\nnel vettore che occorre il massimo numero di volte.\r\n*/\r\n\r\n\r\nint main() {\r\n\tint v[] = {3, -2, 5, 7, 6, -1};\r\n\tint dim = 6;\r\n\tint res;\r\n\tint i;\r\n\tint div = 0;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tfor(i = 0; i < dim; i++) {\r\n\t\tif(res != v[i]) div++;\r\n\t}\r\n\t\r\n\tif(div != 5) {\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{3,-2,5,7,6,-1}", dim );\r\n\t}\r\n\t\t\r\n\tv[2] = -2;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tif(res != -2)\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{3,-2,-2,7,6,-1}", dim );\r\n\t\t\r\n\tv[0] = -3;\r\n\tv[3] = -2;\r\n\tv[4] = -2;\r\n\tv[5] = -3;\r\n\t\r\n\tres = maxoccorrenza(v, dim);\r\n\t\r\n\tif(res != -2) {\r\n\t\ttest_error( "maxoccorrenza","maxocc_errata","maxoccorrenza fallisce con input (%s,%d)", "{-3,-2,-2,-2,-2,-3}", dim );\r\n\t}\r\n\r\n    return no_errors();\r\n}\r\n	es1_1.c	20		
2	<p></p>	804	f	f	569			20		
3	<p></p>	804	f	f	569			20		
4	<p></p>	804	f	f	569			20		
5	<p></p>	804	f	f	569			20		
1	<p>\r\n<p class="MsoNormal" style="margin: 24pt 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145); font-size: 14pt;">Esercizio 1</span></b></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><span class="apple-style-span"><span style="line-height: 115%; color: black;"><font size="3"><font face="Calibri">Scrivere una funzione <i>min3</i> che, presi 3 numeri interi in ingresso, restituisca il minore.</font></font></span></span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Firma della funzione:</span></u></b><span style="color: rgb(51, 51, 51);">&nbsp;</span> </font><span style="font-family: 'Courier New'; color: rgb(31, 73, 125);">int -&gt; int -&gt; int -&gt; int</span></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><font face="Calibri"><b><u><span style="line-height: 115%; color: rgb(192, 80, 77);">Nota:</span></u></b><span style="line-height: 115%; color: rgb(51, 51, 51);">&nbsp; </span><span style="line-height: 115%; color: rgb(51, 51, 51);">Non usare la funzione di sistema <i>min</i>, ma solo il costrutto <i>if-then-else</i>.</span></font></font></p>\r\n<p class="MsoNormal" style="margin: 24pt 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145); font-size: 14pt;">Esercizio 2</span></b></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><span><font size="3"><font face="Calibri">Scrivere una funzione <i>arrotonda</i> che, dato un <i>float</i> in ingresso, ne esegua l&rsquo;arrotondamento e ne restituisca il valore.</font></font></span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><strong><u><span style="font-family: 'Calibri','sans-serif'; color: rgb(192, 80, 77);">Firma </span></u></strong><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">della funzione</span></u></b><b><u><span style="color: rgb(192, 80, 77);">:</span></u></b><span> <span>&nbsp;</span></span></font><span style="font-family: 'Courier New'; color: rgb(31, 73, 125);">float -&gt; int</span></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><font face="Calibri"><b><u><span style="line-height: 115%; color: rgb(192, 80, 77);">Nota1:</span></u></b><span style="line-height: 115%; color: rgb(51, 51, 51);">&nbsp;</span></font></font><span class="apple-style-span"><span style="line-height: 115%; font-family: 'Arial','sans-serif'; color: black; font-size: 10pt;"> <span class="apple-style-span"><span style="line-height: 115%; font-family: 'Arial','sans-serif'; color: black;"><font size="3"><font face="Calibri"><span class="apple-style-span"><span style="line-height: 115%; color: black;">la funnzione </span></span><em><span style="line-height: 115%; font-family: 'Calibri','sans-serif'; color: black;">truncate </span></em><span class="apple-style-span"><span style="line-height: 115%; color: black;">tronca un valore </span></span><em><span style="line-height: 115%; font-family: 'Calibri','sans-serif'; color: black;">float </span></em><span class="apple-style-span"><span style="line-height: 115%; color: black;">e ne restituisce la parte intera.&nbsp;In F# la funzione </span></span><em><span style="line-height: 115%; font-family: 'Calibri','sans-serif'; color: black;">truncate </span></em><span class="apple-style-span"><span style="line-height: 115%; color: black;">ha firma </span></span><span class="apple-style-span"><span style="line-height: 115%; color: rgb(31, 73, 125);">a' -&gt; a'</span></span><span class="apple-style-span"><span style="line-height: 115%; color: black;">, ossia se gli viene dato in ingresso un float, vi ritorner&agrave; un float. In CaML (e in OCaML), la funzione ha firma </span></span><span class="apple-style-span"><span style="line-height: 115%; color: rgb(31, 73, 125);">float -&gt; int</span></span></font></font></span></span></span></span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><strong><u><span style="font-family: 'Calibri','sans-serif'; color: rgb(192, 80, 77);">Nota2</span></u></strong><font face="Calibri"><b><u><span style="line-height: 115%; color: rgb(192, 80, 77);">:</span></u></b><span> l&rsquo;approssimazione di un <i>float</i> ad intero dipende dal valore della prima cifra dopo la virgola. Si effettuer&agrave; un arrotondamento <u>per eccesso</u> se la prima cifra dopo la virgola </span>&egrave;<span> maggiore o uguale a 5, <u>per difetto</u> altrimenti.</span></font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><strong><u><span style="font-family: 'Calibri','sans-serif'; color: rgb(192, 80, 77);">Esempi</span></u></strong><font face="Calibri"><b><u><span style="line-height: 115%; color: rgb(192, 80, 77);">:</span></u></b></font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt 35.4pt;"><font size="3"><font face="Calibri"><i>arrotonda 1.6</i><span>&nbsp;&nbsp; </span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>deve restituire 2</font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt 35.4pt;"><font size="3"><font face="Calibri"><i>arrotonda 5.3</i> <span>&nbsp; </span><span>&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>deve restituire 5</font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt 35.4pt;"><font size="3"><font face="Calibri"><i>arrotonda -14.5</i> <span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>deve restituire -15</font></font></p>\r\n<p class="MsoNormal" style="margin: 24pt 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145); font-size: 12pt;">Esercizio 3</span></b></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><font face="Calibri"><span class="apple-style-span"><span style="line-height: 115%; color: black;">Scrivere una funzione <i>bisestile</i> che, dato un intero rappresentante l&rsquo;anno, controlla se si tratta di un anno bisestile o meno.</span></span></font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Firma della funzione:</span></u></b><span style="color: rgb(51, 51, 51);">&nbsp;</span> </font><span style="font-family: 'Courier New'; color: rgb(31, 73, 125);">int -&gt; bool</span></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><font face="Calibri"><b><u><span style="line-height: 115%; color: rgb(192, 80, 77);">Nota1:</span></u></b><span style="line-height: 115%; color: rgb(51, 51, 51);">&nbsp;</span>Un anno &egrave; bisestile se il suo numero &egrave; divisibile per 4, con l'eccezione che gli anni secolari (quelli divisibili per 100) sono bisestili solo se divisibili per 400.</font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 10pt;"><font size="3"><font face="Calibri"><b><u><span style="line-height: 115%; color: rgb(192, 80, 77);">Nota2:</span></u></b><span style="line-height: 115%; color: rgb(51, 51, 51);">&nbsp;</span>In <i>CaML</i> per calcolare il modulo dovete usare la procedura <b><i>mod</i></b> (5 mod 2 = 1) mentre in <i>F#</i> <span>&nbsp;</span>dovete usare il simbolo <b><i>%</i></b> (5 % 2 = 1).</font></font></p>\r\n</p>	806	f	t	569		test.c	20		
1	<p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145); font-size: 14pt;">Esercizio 1</span></b></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145); font-size: 12pt;"><br />\r\n</span></b><span style="color: rgb(51, 51, 51);"><font size="3"><font face="Calibri">Scrivere una funzione&nbsp;&nbsp;che, dati 5 caratteri in ingresso, restituisca <i>true</i> se la parola che formano &egrave; palindroma, <i>false</i> altrimenti.</font></font></span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Nota:</span></u></b><span style="color: rgb(51, 51, 51);">&nbsp;Il palindromo &egrave; una sequenza di caratteri che, letta a rovescio, rimane identica. La parola <i>ANNA</i> &egrave; un palindromo.</span></font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Firma:</span></u></b><span style="color: rgb(51, 51, 51);">&nbsp;la firma della funzione deve essere&nbsp;</span></font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p align="center" class="MsoNormal" style="margin: 0cm 0cm 0pt; text-align: center;"><font size="3"><span lang="EN-US" style="font-family: 'Courier New'; color: rgb(79, 129, 189);">fun char -&gt; char -&gt; char -&gt; char -&gt; char -&gt; bool</span><span lang="EN-US" style="color: rgb(51, 51, 51);"><font face="Calibri">.</font></span></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt; text-align: justify;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Domanda:</span></u></b><span style="color: rgb(51, 51, 51);">&nbsp;una funzione con firma </span></font><span style="font-family: 'Courier New'; color: rgb(79, 129, 189);">fun a&rsquo; -&gt; b&rsquo; -&gt; c&rsquo; -&gt; b&rsquo; -&gt; a&rsquo; -&gt; bool</span><font face="Calibri"><span style="color: rgb(51, 51, 51);"> pu&ograve; essere utilizzata per raggiungere lo stesso scopo? Scrivete la risposta in un commento subito dopo la definizione della funzione data.</span></font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145); font-size: 14pt;">Esercizio 2</span></b></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145);"><br />\r\n</span></b><span><font size="3"><font face="Calibri">Il voto finale dell&rsquo;esame di Programmazione verr&agrave; calcolato nel seguente modo: prima verr&agrave; calcolata la media (arrotondata per difetto) dei voti ottenuti nelle prove scritta e pratica; poi tale media verr&agrave; incrementata del bonus ottenuto per le esercitazioni.<br />\r\nSi scriva una funzione che dati i voti delle prove scritta e pratica e il bonus per le esercitazioni restituisce il voto finale dell'esame di programmazione. La funzione dovr&agrave;:</font></font></span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNoSpacing" style="margin: 0cm 0cm 0pt 36pt; text-indent: -18pt;"><span style="font-family: Wingdings;"><span><font size="3">&uuml;</font><span style="font-family: 'Times New Roman'; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp; </span></span></span><font size="3"><font face="Calibri">controllare che i voti della prova pratica e di quella teorica siano compresi tra 18 e 30</font></font></p>\r\n<p class="MsoNoSpacing" style="margin: 0cm 0cm 0pt 36pt; text-indent: -18pt;"><span style="font-family: Wingdings;"><span><font size="3">&uuml;</font><span style="font-family: 'Times New Roman'; font-style: normal; font-variant: normal; font-weight: normal; font-size: 7pt; line-height: normal; font-size-adjust: none; font-stretch: normal;">&nbsp; </span></span></span><font size="3"><font face="Calibri">controllare che il bonus per le esercitazioni sia un numero compreso tra 0 e 2</font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Nota:</span></u></b><span>&nbsp;Se una delle due condizioni sopra non si verifica, restituire&nbsp;</span></font><span style="font-family: 'Courier New'; color: rgb(79, 129, 189);">failwith &ldquo;nome errore&rdquo;</span><span><font face="Calibri">, dove la stringa&nbsp;</font></span></font><span style="line-height: 115%; font-family: 'Courier New'; color: rgb(79, 129, 189); font-size: 10pt;">nome errore</span><span><font size="3" face="Calibri">&nbsp;deve descrivere il tipo di errore verificatosi (ad esempio:&nbsp;</font></span><span style="line-height: 115%; font-family: 'Courier New'; color: rgb(79, 129, 189); font-size: 10pt;">&ldquo;il bonus delle esercitazioni deve essere tra 0 e 2&rdquo;</span><font size="3"><font face="Calibri"><span>.</span></font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Firma:</span></u></b><span>&nbsp;la firma della funzione deve essere&nbsp;</span></font></font><span style="line-height: 115%; font-family: 'Courier New'; color: rgb(79, 129, 189); font-size: 10pt;">fun int -&gt; int -&gt; int -&gt; int</span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145); font-size: 14pt;">Esercizio 3</span></b></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><b><span style="font-family: 'Cambria','serif'; color: rgb(54, 95, 145);"><br />\r\n</span></b><span><font size="3"><font face="Calibri">Scrivere una funzione&nbsp;&nbsp;che, dati in ingresso i 3 coefficienti di un&rsquo;equazione di secondo grado del tipo:</font></font></span></p>\r\n<p align="center" class="MsoNormal" style="margin: 0cm 0cm 0pt; text-align: center;">&nbsp;</p>\r\n<p align="center" class="MsoNormal" style="margin: 0cm 0cm 0pt; text-align: center;"><span><font size="3"><font face="Calibri">ax<sup>2 </sup>+ bx + c = 0</font></font></span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><span><font size="3"><font face="Calibri">restituisca la tupla rappresentate i suoi risultati se &egrave; possibile calcolarla, un messaggio d&rsquo;errore altrimenti.</font></font></span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Nota:</span></u></b><span>&nbsp;una tupla &egrave; una coppia di valori. I valori di una tupla vengono racchiusi tra una coppia di parentesi rotonde e divisi tra loro da una virgola.</span></font></font></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><i><span><font size="3"><font face="Calibri">Esempio:</font></font></span></i></p>\r\n<p align="center" class="MsoNormal" style="margin: 0cm 0cm 0pt; text-align: center;"><span><font size="3"><font face="Calibri">( <i>valore1</i> , <i>valore2</i> )</font></font></span></p>\r\n<p align="center" class="MsoNormal" style="margin: 0cm 0cm 0pt; text-align: center;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Nota<sub>2</sub>:</span></u></b><span>&nbsp;Se il coefficiente del primo monomio &egrave; pari a 0, l&rsquo;equazione risultante &egrave; un&rsquo;equazione di primo grado. In questo caso, la funzione restituir&agrave; una tupla con il primo valore che &egrave; il risultato dell&rsquo;equazione e con il secondo valore a 0.</span></font></font></p>\r\n<p align="center" class="MsoNormal" style="margin: 0cm 0cm 0pt; text-align: center;"><span><font size="3"><font face="Calibri">( <i>risultato_equazione</i> , <i>0</i> )</font></font></span></p>\r\n<p align="center" class="MsoNormal" style="margin: 0cm 0cm 0pt; text-align: center;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Nota<sub>3</sub>:</span></u></b><span>&nbsp;per calcolare la radice quadrata di un <i>float</i> esiste la funzione <i>sqrt</i>, la cui firma &egrave; </span></font></font><span style="line-height: 115%; font-family: 'Courier New'; color: rgb(79, 129, 189); font-size: 10pt;">fun float -&gt; float</span><span><font size="3"><font face="Calibri">.</font></font></span></p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;">&nbsp;</p>\r\n<p class="MsoNormal" style="margin: 0cm 0cm 0pt;"><font size="3"><font face="Calibri"><b><u><span style="color: rgb(192, 80, 77);">Firma:</span></u></b><span>&nbsp;la firma della funzione deve essere&nbsp;</span></font></font><span style="line-height: 115%; font-family: 'Courier New'; color: rgb(79, 129, 189); font-size: 10pt;">fun float -&gt; float -&gt; float -&gt; float *&nbsp;float</span></p>\r\n</p>	811	f	t	569		test.c	20		
1	<p>Progettare una realizzazione del tipo di dato Pila che utilizza un array dinamico. Deve essere implementata la seguente tecnica di raddoppiamento e&nbsp; imezzamento. Sia n il numero di elementi nella pila e h la dimensione dell'array dinamico.</p>\r\n<ul>\r\n    <li>Inizialmente, quando n = 0, poniamo h = 1.</li>\r\n    <li>Ogni qualvolta n supera h, l'array viene riallocato raddoppiandone la dimensione.</li>\r\n    <li>Ogni qualvolta n scende a h/4, l'array viene riallocato dimezzandone&nbsp;la dimensione.</li>\r\n</ul>\r\n<p>Completare il file implStackArrayDinamicoesercizio.c</p>	804	f	f	569	#include <stdio.h>\r\n#include <stdlib.h>\r\n#include "../test_api.h"\r\n#include "implStackArrayDinamico.c"\r\n\r\n#define MAX 15\r\n\r\nint main() {\r\n    Stack s = initstack();\r\n    Item i;\r\n    int j;\r\n    Item items[MAX];\r\n    int stop = 0;\r\n    \r\n    int res = emptystack(s);\r\n    if(!res) {\r\n        test_error("emptystack","stack_vuoto","emptystack restituisce %d", res);\r\n    }\r\n    \r\n    res = size(s);\r\n    if(res != 0) {\r\n        test_error("size","stack_vuoto","size restituisce %d", res);\r\n    }\r\n    \r\n    for(j = 0; j < MAX; j++) {\r\n        i = getRandomItem(MAX);\r\n        items[j] = i;\r\n        push(s, i);\r\n        \r\n        res = emptystack(s);\r\n        if(res) {\r\n            test_error("emptystack","stack_non_vuoto_push","emptystack restituisce %d all'iterazione %d", res, j);\r\n            stop = 1;\r\n        }\r\n        res = size(s);\r\n        if(res != j + 1) {\r\n            test_error("size","stack_non_vuoto_push","size restituisce %d invece di %d", res, (j + 1));\r\n            stop = 1;\r\n        }\r\n        i = top(s);\r\n        if(!compare(i, items[j])) {\r\n            test_error("top","top_errato","top restituisce un valore errato");\r\n            stop = 1;\r\n        }\r\n        if(stop) {\r\n            j++;\r\n            break;\r\n        }\r\n    }\r\n    j--;\r\n    stop = 0;\r\n    while(!emptystack(s)) {\r\n        i = pop(s);\r\n        res = emptystack(s);\r\n        if((res && j > 0) || (!res && j == 0)) {\r\n            test_error("emptystack","stack_non_vuoto_pop","emptystack restituisce %d all'iterazione %d", res, MAX - j - 1);\r\n            stop = 1;\r\n        }\r\n        res = size(s);\r\n        if(res != j) {\r\n            test_error("size","stack_non_vuoto_pop","size restituisce %d invece di %d", res, j);\r\n            stop = 1;\r\n        }\r\n        if(!compare(i, items[j])) {\r\n            test_error("pop","pop_errata","pop restituisce un valore errato");\r\n            stop = 1;\r\n        }\r\n        j--;\r\n        if(stop)\r\n            break;\r\n    }\r\n    \r\n    return no_errors();\r\n}	implStackArrayDinamico.c	20		
\.


--
-- Data for Name: auxiliarysourcefile; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY auxiliarysourcefile (id, filename, code, source) FROM stdin;
587	Pert.java	/*\n * To change this template, choose Tools | Templates\n * and open the template in the editor.\n */\n\npackage prova;\n\n/**\n *\n * @author roncato\n */\npublic interface Pert {\n\n    public int fact(int n);\n\n}\n	t
588	Pert.java	/*\n * To change this template, choose Tools | Templates\n * and open the template in the editor.\n */\n\n\n\n/**\n *\n * @author roncato\n */\npublic interface Pert {\n\n    public int fact(int n);\n\n}\n	f
594	Pert.java	public interface Pert {\r\n\r\n\tpublic int fact( int n );\r\n\r\n}	t
747	implItemInt.c	#include <stdlib.h>\n#include <stdio.h>\n#include "item.h"\n\nstruct item{\n  int info;\n};\n\nItem leggi(){\n  \n  Item x = (Item) malloc(sizeof(struct item));\n\n  scanf("%d", &x->info);\n  return x;\n}\n\nvoid stampa(Item x){\n  \n  printf("%d\\n", x->info);\n\n}\n\nint compare(Item x, Item y){\n  \n  return x->info == y-> info;\n}\n	t
748	implItemstringhe.c	#include <stdlib.h>\n#include <stdio.h>\n#include <string.h>\n#include "item.h"\n#define STRLUNG 30\n\nstruct item{\n  char * info;\n};\n\nItem leggi(){\n  \n  char temp[STRLUNG];\n\n  Item ris = (Item) malloc(sizeof(struct item));\n  scanf("%s", temp);\n  ris -> info = (char *) malloc(sizeof(char) * (strlen(temp)+1));\n  strcpy(ris->info, temp);\n  return ris;\n}\n\nvoid stampa(Item x){\n  \n  printf("%s\\n", x->info);\n\n}\n\nint compare(Item x, Item y){\n  \n  return strcmp(x->info, y->info) == 0;\n}\n	t
749	item.h	typedef struct item * Item;\n\nItem leggi();\n\nvoid stampa(Item x);\n\nint compare(Item x, Item y);\n\n	t
772	Aux1.txt	Questo e' un file ausiliario!	f
773	Aux2.c	﻿/* Questo è lun file ausiliario!!! */\n\nint maxoccorrenza(int v[], int dim) {\n  int occ[SIZEOCC], i, max;\n  \n  for(i = 0; i &lt; SIZEOCC; i++) {\n    occ[i] = 0;\n  }\n\n  for(i = 0; i &lt; dim; i++) {\n    occ[v[i] - (-3)]++;\n  }\n\n  max = 0;\n  for(i = 1; i &lt; SIZEOCC; i++)\n    if (occ[max] &lt; occ[i])\n      max = i;\n\n  return max - 3;\n}	t
781	Aux1.txt	Questo � un file ausiliario!	f
782	Aux2.c	/* Questo � lun file ausiliario!!! */\r\n\r\nint maxoccorrenza(int v[], int dim) {\r\n  int occ[SIZEOCC], i, max;\r\n  \r\n  for(i = 0; i &lt; SIZEOCC; i++) {\r\n    occ[i] = 0;\r\n  }\r\n\r\n  for(i = 0; i &lt; dim; i++) {\r\n    occ[v[i] - (-3)]++;\r\n  }\r\n\r\n  max = 0;\r\n  for(i = 1; i &lt; SIZEOCC; i++)\r\n    if (occ[max] &lt; occ[i])\r\n      max = i;\r\n\r\n  return max - 3;\r\n}	t
819	item.h	typedef struct item * Item;\n\nItem leggi();\nItem getRandomItem(int max);\n\nvoid stampa(Item x);\n\nint compare(Item x, Item y);\n\n\n	t
820	implItemInt.c	#include <stdlib.h>\n#include <stdio.h>\n#include "item.h"\n\nstruct item{\n  int info;\n};\n\nItem leggi(){\n  \n  Item x = (Item) malloc(sizeof(struct item));\n\n  scanf("%d", &x->info);\n  return x;\n}\n\nItem getRandomItem(int max) {\n    Item x = (Item) malloc(sizeof(struct item));\n    \n    randomize();\n    x->info = random(max);\n    return x;\n}\n\nvoid stampa(Item x){\n  \n  printf("%d\\n", x->info);\n\n}\n\nint compare(Item x, Item y){\n  \n  return x->info == y-> info;\n}\n	t
821	stack.h	typedef struct stack *Stack;\n\nStack initstack();\nint emptystack(Stack s);\nvoid push(Stack s, Item elem);\nItem pop(Stack s);\nItem top(Stack s);\nint size(Stack s);\n\n	t
826	implStackArrayDinamicoesercizio.c	﻿#include <stdlib.h>\n#include <stdio.h>\n#include "../Item/item.h"\n#include "stack.h"\n\nstruct stack{     /* tipo dello stack realizzato con array */\n  Item * contents;\n  int top;\n  int dim;             /* dimensione dell'array */\n};\n\n/*post: costruisce uno stack vuoto */\nStack initstack(){\n...\n}\n\n/*post: ritorna 1 se lo stack e' vuoto, 0 altrimenti */\nint emptystack(Stack s){\n...\n}\n\n/*post: inserisce elem in cima allo stack */\nvoid push(Stack s, Item elem){\n...  \n}\n\n/*pre: stack non vuoto */\n/*post: ritorna e rimuove l'elemento in cima allo stack */\nItem pop(Stack s){\n...  \n}\n\n/*pre: stack non vuoto */\n/*post: ritorna l'elemento in cima allo stack */\nItem top(Stack s){\n...  \n}\n\n/*post: ritorna il numero di elementi nello stack */\nint size(Stack s){\n...  \n}\n	f
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY courses (id, name, aa) FROM stdin;
570	labasd	567
584	Lab. Reti	567
685	Programmazione	684
743	Algoritmi e Strutture Dati	684
770	Prove varie ed eventuali	684
\.


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY languages (id, ext, formatter, testcasefilename, codeanalizer, defaultlanguage, compoptions, execoptions, dir) FROM stdin;
586	java	model.JavaFormatter	Test.java	model.JavaCodeAnalizer	f			test
569	c	model.CeeFormatter	Test.c	model.CeeCodeAnalizer	t			ctests
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY permissions (type, assignment, exercisenumber, enabled, id) FROM stdin;
0	571	1	f	572
1	571	1	f	573
2	571	1	f	574
3	571	1	t	575
0	576	1	f	577
1	576	1	f	578
2	576	1	f	579
3	576	1	t	580
0	585	1	f	589
1	585	1	f	590
2	585	1	f	591
3	585	1	t	592
0	593	1	f	595
1	593	1	f	596
2	593	1	f	597
3	593	1	t	598
0	744	3	f	758
1	744	3	f	759
2	744	3	f	760
3	744	3	t	761
0	744	4	f	762
1	744	4	f	763
2	744	4	f	764
3	744	4	t	765
0	744	5	f	766
1	744	5	f	767
2	744	5	f	768
3	744	5	t	769
0	631	1	f	632
1	631	1	f	633
2	631	1	f	634
3	631	1	t	635
0	631	2	f	636
1	631	2	f	637
2	631	2	f	638
3	631	2	t	639
0	648	1	f	649
1	648	1	f	650
2	648	1	f	651
3	648	1	t	652
0	657	1	f	658
1	657	1	f	659
2	657	1	f	660
3	657	1	t	661
0	691	1	f	692
1	691	1	f	693
2	691	1	f	694
3	691	1	t	695
0	691	2	f	696
1	691	2	f	697
2	691	2	f	698
3	691	2	t	699
0	691	3	f	700
1	691	3	f	701
2	691	3	f	702
3	691	3	t	703
0	704	1	f	705
1	704	1	f	706
2	704	1	f	707
3	704	1	t	708
0	771	1	f	774
1	771	1	f	775
2	771	1	f	776
3	771	1	t	777
0	780	1	f	783
1	780	1	f	784
2	780	1	f	785
3	780	1	t	786
0	744	1	f	750
1	744	1	f	751
2	744	1	f	752
3	744	1	t	753
0	744	2	f	754
1	744	2	f	755
2	744	2	f	756
3	744	2	t	757
0	780	2	f	787
1	780	2	f	788
2	780	2	f	789
3	780	2	t	790
0	780	3	f	791
1	780	3	f	792
2	780	3	f	793
3	780	3	t	794
0	806	1	f	807
1	806	1	f	808
2	806	1	f	809
3	806	1	t	810
0	811	1	f	812
1	811	1	f	813
2	811	1	f	814
3	811	1	t	815
0	804	1	f	822
1	804	1	f	823
2	804	1	f	824
3	804	1	t	825
\.


--
-- Data for Name: results; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY results (returncode, teststdout, seenbyuser, pseudook, extrainfo, id) FROM stdin;
4	\N	f	\N	\N	846
4	\N	t	\N	\N	604
4	\N	f	\N	\N	856
5	\N	f	\N	\N	857
5	\N	f	\N	\N	861
4	\N	f	\N	\N	910
5	\N	f	\N	\N	911
5	\N	f	\N	\N	915
4	\N	f	\N	\N	919
2	<div class="code"><pre>**********\\n &nbsp; &nbsp; &nbsp; &nbsp;* \\n &nbsp; &nbsp; &nbsp; * &nbsp;\\n &nbsp; &nbsp; &nbsp;* &nbsp; \\n &nbsp; &nbsp; * &nbsp; &nbsp;\\n &nbsp; &nbsp;* &nbsp; &nbsp; \\n &nbsp; * &nbsp; &nbsp; &nbsp;\\n &nbsp;* &nbsp; &nbsp; &nbsp; \\n * &nbsp; &nbsp; &nbsp; &nbsp;\\n**********\\n\\n\\n\\n0101010101\\n 10101010 \\n &nbsp;010101 &nbsp;\\n &nbsp; 1010 &nbsp; \\n &nbsp; &nbsp;01 &nbsp; &nbsp;\\n &nbsp; &nbsp;01 &nbsp; &nbsp;\\n &nbsp; 1 &nbsp;0 &nbsp; \\n &nbsp;0 &nbsp; &nbsp;1 &nbsp;\\n 1 &nbsp; &nbsp; &nbsp;0 \\n0 &nbsp; &nbsp; &nbsp; &nbsp;1\\n<br/></pre></div>	t	\N	\N	653
2	<applet code="test.test0.Test.class" archive="../applets/Signed_1238234312165.jar"width="300" height="50" ></applet>	t	\N	Signed_1238234312165.jar;key_1238234312165	654
2	<applet code="test.test0.Test.class" archive="../applets/Signed_1238235437889.jar"width="300" height="50" ></applet>	t	\N	Signed_1238235437889.jar;key_1238235437889	655
5	\N	t	\N	\N	681
4	\N	f	\N	\N	778
4	\N	f	\N	\N	931
5	\N	f	\N	\N	932
5	\N	f	\N	\N	936
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY students (login, password, nome, cognome, email, matricola) FROM stdin;
dseno		Damiano	Seno	dseno@dsi.unive.it	805412
mzanioli		Matteo	Zanioli	mzanioli@dsi.unive.it	810417
mdaddett		Maurizio	D' Addetta	mdaddett@dsi.unive.it	819849
agaspare		Andrea	Gasparetto	agaspare@dsi.unive.it	812882
gmaggior		Giuseppe	Maggiore	gmaggior@dsi.unive.it	819050
lleonard		Luca	Leonardi	lleonard@dsi.unive.it	810086
ldonati		Lorenzo 	Donati	ldonati@dsi.unive.it	817622
sgatto		Stefano	Gatto	sgatto@dsi.unive.it	823215
mlavazza		Marco	Lavazza Seranto	mlavazza@dsi.unive.it	823162
gdario		Gianluca	Dario	gdario@dsi.unive.it	823314
psalvado		Paolo	Salvador	psalvado@dsi.unive.it	818054
ddambros		Davide	D Ambros	ddambros@dsi.unive.it	812926
gvivian		Giulio	Vivian	gvivian@dsi.unive.it	823447
pbaruffa		Paolo	Baruffa	pbaruffa@dsi.unive.it	820757
eravagna		Elisa	Ravagnan	eravagna@dsi.unive.it	822592
mparpagi		Matteo	Parpagiola	mparpagi@dsi.unive.it	826486
mzuccoli		Marta	Zuccolin	mzuccoli@dsi.unive.it	822898
sfavaret		Simone	Favaretto	sfavaret@dsi.unive.it	824195
msoravia		Mattia	Soravia Mosson	msoravia@dsi.unive.it	825103
mabbadi		Mohamed	Abbadi	mabbadi@dsi.unive.it	823145
msoprano		Mario	Soprano	msoprano@dsi.unive.it	823469
siboscol		Simone	Boscolo Berto	siboscol@dsi.unive.it	815716
andestro		Andrea	Destro	andestro@dsi.unive.it	818658
mfoschin		Marco	Foschini	mfoschin@dsi.unive.it	815719
apretott		Andrea	Pretotto	apretott@dsi.unive.it	820955
ykadjaha		Yvette	Kadjahalla Ballet	ykadjaha@dsi.unive.it	793799
\.


--
-- Data for Name: testerrors; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY testerrors (id, type, line, code, error, file, result) FROM stdin;
682	2	3	4	causa	\N	681
912	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,5,7,6,-1},6)	\N	911
913	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,-2,7,6,-1},6)	\N	911
914	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({-3,-2,-2,-2,-2,-3},6)	\N	911
916	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,5,7,6,-1},6)	\N	915
917	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,-2,7,6,-1},6)	\N	915
918	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({-3,-2,-2,-2,-2,-3},6)	\N	915
858	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,5,7,6,-1},6)	\N	857
859	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,-2,7,6,-1},6)	\N	857
860	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({-3,-2,-2,-2,-2,-3},6)	\N	857
862	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,5,7,6,-1},6)	\N	861
863	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,-2,7,6,-1},6)	\N	861
864	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({-3,-2,-2,-2,-2,-3},6)	\N	861
933	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,5,7,6,-1},6)	\N	932
934	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,-2,7,6,-1},6)	\N	932
935	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({-3,-2,-2,-2,-2,-3},6)	\N	932
937	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,5,7,6,-1},6)	\N	936
938	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({3,-2,-2,7,6,-1},6)	\N	936
939	2	-1	maxocc_errata	maxoccorrenza fallisce con input ({-3,-2,-2,-2,-2,-3},6)	\N	936
\.


--
-- Data for Name: texts_auxsrcs; Type: TABLE DATA; Schema: public; Owner: consegne
--

COPY texts_auxsrcs (assignment, ordinal, idsrc) FROM stdin;
585	1	587
585	1	588
593	1	594
744	1	747
744	1	748
744	1	749
771	1	772
771	1	773
780	1	781
780	1	782
804	1	819
804	1	820
804	1	821
804	1	826
\.


--
-- Name: academicyears_firstYear_key; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY academicyears
    ADD CONSTRAINT "academicyears_firstYear_key" UNIQUE (firstyear);


--
-- Name: academicyears_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY academicyears
    ADD CONSTRAINT academicyears_pkey PRIMARY KEY (id);


--
-- Name: academicyears_secondYear_key; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY academicyears
    ADD CONSTRAINT "academicyears_secondYear_key" UNIQUE (secondyear);


--
-- Name: admins_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (login);


--
-- Name: adminscourses_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY adminscourses
    ADD CONSTRAINT adminscourses_pkey PRIMARY KEY (login, course);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: assignmentssubmissions_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY assignmentssubmissions
    ADD CONSTRAINT assignmentssubmissions_pkey PRIMARY KEY (login, assignment, exercisenumber);


--
-- Name: assignmentstexts_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY assignmentstexts
    ADD CONSTRAINT assignmentstexts_pkey PRIMARY KEY (assignment, ordinal);


--
-- Name: auxiliarysourcefile_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY auxiliarysourcefile
    ADD CONSTRAINT auxiliarysourcefile_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: language_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY languages
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);


--
-- Name: languages_name_key; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY languages
    ADD CONSTRAINT languages_name_key UNIQUE (ext);


--
-- Name: permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: results_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);


--
-- Name: students_matricola_key; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY students
    ADD CONSTRAINT students_matricola_key UNIQUE (matricola);


--
-- Name: students_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY students
    ADD CONSTRAINT students_pkey PRIMARY KEY (login);


--
-- Name: testerrors_id_key; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY testerrors
    ADD CONSTRAINT testerrors_id_key UNIQUE (id, result);


--
-- Name: testerrors_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY testerrors
    ADD CONSTRAINT testerrors_pkey PRIMARY KEY (id);


--
-- Name: texts_auxsrcs_pkey; Type: CONSTRAINT; Schema: public; Owner: consegne; Tablespace: 
--

ALTER TABLE ONLY texts_auxsrcs
    ADD CONSTRAINT texts_auxsrcs_pkey PRIMARY KEY (assignment, ordinal, idsrc);


--
-- Name: fki_; Type: INDEX; Schema: public; Owner: consegne; Tablespace: 
--

CREATE INDEX fki_ ON assignmentstexts USING btree (language);


--
-- Name: persist_root_delete; Type: TRIGGER; Schema: public; Owner: consegne
--

CREATE TRIGGER persist_root_delete
    BEFORE DELETE ON admins
    FOR EACH ROW
    EXECUTE PROCEDURE protect_root_delete();


--
-- Name: persist_root_update; Type: TRIGGER; Schema: public; Owner: consegne
--

CREATE TRIGGER persist_root_update
    BEFORE UPDATE ON admins
    FOR EACH ROW
    EXECUTE PROCEDURE protect_root_update();


--
-- Name: trigger_def_lang_delete; Type: TRIGGER; Schema: public; Owner: consegne
--

CREATE TRIGGER trigger_def_lang_delete
    BEFORE DELETE ON languages
    FOR EACH ROW
    EXECUTE PROCEDURE check_unique_def_lang_delete();


--
-- Name: trigger_def_lang_insert; Type: TRIGGER; Schema: public; Owner: consegne
--

CREATE TRIGGER trigger_def_lang_insert
    BEFORE INSERT ON languages
    FOR EACH ROW
    EXECUTE PROCEDURE check_unique_def_lang_insert();


--
-- Name: unique_root; Type: TRIGGER; Schema: public; Owner: consegne
--

CREATE TRIGGER unique_root
    BEFORE INSERT ON admins
    FOR EACH ROW
    EXECUTE PROCEDURE protect_root_insert();


--
-- Name: adminscourses_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY adminscourses
    ADD CONSTRAINT adminscourses_course_fkey FOREIGN KEY (course) REFERENCES courses(id) ON DELETE CASCADE;


--
-- Name: adminscourses_login_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY adminscourses
    ADD CONSTRAINT adminscourses_login_fkey FOREIGN KEY (login) REFERENCES admins(login) ON DELETE CASCADE;


--
-- Name: assignments_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY assignments
    ADD CONSTRAINT assignments_course_fkey FOREIGN KEY (course) REFERENCES courses(id) ON DELETE CASCADE;


--
-- Name: assignmentssubmissions_assignment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY assignmentssubmissions
    ADD CONSTRAINT assignmentssubmissions_assignment_fkey FOREIGN KEY (assignment, exercisenumber) REFERENCES assignmentstexts(assignment, ordinal) ON DELETE CASCADE;


--
-- Name: assignmentssubmissions_login_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY assignmentssubmissions
    ADD CONSTRAINT assignmentssubmissions_login_fkey FOREIGN KEY (login) REFERENCES students(login) ON DELETE CASCADE;


--
-- Name: assignmentssubmissions_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY assignmentssubmissions
    ADD CONSTRAINT assignmentssubmissions_result_fkey FOREIGN KEY (result) REFERENCES results(id);


--
-- Name: assignmentstexts_assignment_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY assignmentstexts
    ADD CONSTRAINT assignmentstexts_assignment_fkey1 FOREIGN KEY (assignment) REFERENCES assignments(id) ON DELETE CASCADE;


--
-- Name: assignmentstexts_language_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY assignmentstexts
    ADD CONSTRAINT assignmentstexts_language_fkey FOREIGN KEY (language) REFERENCES languages(id) ON DELETE CASCADE;


--
-- Name: courses_aa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_aa_fkey FOREIGN KEY (aa) REFERENCES academicyears(id) ON DELETE CASCADE;


--
-- Name: permissions_assignment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_assignment_fkey FOREIGN KEY (assignment, exercisenumber) REFERENCES assignmentstexts(assignment, ordinal) ON DELETE CASCADE;


--
-- Name: testerrors_result_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY testerrors
    ADD CONSTRAINT testerrors_result_fkey FOREIGN KEY (result) REFERENCES results(id) ON DELETE CASCADE;


--
-- Name: texts_auxsrcs_assignment_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY texts_auxsrcs
    ADD CONSTRAINT texts_auxsrcs_assignment_fkey FOREIGN KEY (assignment, ordinal) REFERENCES assignmentstexts(assignment, ordinal) ON DELETE CASCADE;


--
-- Name: texts_auxsrcs_idsrc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: consegne
--

ALTER TABLE ONLY texts_auxsrcs
    ADD CONSTRAINT texts_auxsrcs_idsrc_fkey FOREIGN KEY (idsrc) REFERENCES auxiliarysourcefile(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: academicyears; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE academicyears FROM PUBLIC;
REVOKE ALL ON TABLE academicyears FROM consegne;
GRANT ALL ON TABLE academicyears TO consegne;


--
-- Name: admins; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE admins FROM PUBLIC;
REVOKE ALL ON TABLE admins FROM consegne;
GRANT ALL ON TABLE admins TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE admins TO PUBLIC;


--
-- Name: adminscourses; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE adminscourses FROM PUBLIC;
REVOKE ALL ON TABLE adminscourses FROM consegne;
GRANT ALL ON TABLE adminscourses TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE adminscourses TO PUBLIC;


--
-- Name: hibernate_sequence; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON SEQUENCE hibernate_sequence FROM PUBLIC;
REVOKE ALL ON SEQUENCE hibernate_sequence FROM consegne;
GRANT ALL ON SEQUENCE hibernate_sequence TO consegne;
GRANT SELECT,UPDATE ON SEQUENCE hibernate_sequence TO PUBLIC;


--
-- Name: assignments; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE assignments FROM PUBLIC;
REVOKE ALL ON TABLE assignments FROM consegne;
GRANT ALL ON TABLE assignments TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE assignments TO PUBLIC;


--
-- Name: assignmentssubmissions; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE assignmentssubmissions FROM PUBLIC;
REVOKE ALL ON TABLE assignmentssubmissions FROM consegne;
GRANT ALL ON TABLE assignmentssubmissions TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE assignmentssubmissions TO PUBLIC;


--
-- Name: assignmentstexts; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE assignmentstexts FROM PUBLIC;
REVOKE ALL ON TABLE assignmentstexts FROM consegne;
GRANT ALL ON TABLE assignmentstexts TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE assignmentstexts TO PUBLIC;


--
-- Name: auxiliarysourcefile; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE auxiliarysourcefile FROM PUBLIC;
REVOKE ALL ON TABLE auxiliarysourcefile FROM consegne;
GRANT ALL ON TABLE auxiliarysourcefile TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE auxiliarysourcefile TO PUBLIC;


--
-- Name: courses; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE courses FROM PUBLIC;
REVOKE ALL ON TABLE courses FROM consegne;
GRANT ALL ON TABLE courses TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE courses TO PUBLIC;


--
-- Name: languages; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE languages FROM PUBLIC;
REVOKE ALL ON TABLE languages FROM consegne;
GRANT ALL ON TABLE languages TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE languages TO PUBLIC;


--
-- Name: permissions; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE permissions FROM PUBLIC;
REVOKE ALL ON TABLE permissions FROM consegne;
GRANT ALL ON TABLE permissions TO consegne;
GRANT ALL ON TABLE permissions TO PUBLIC;


--
-- Name: results; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE results FROM PUBLIC;
REVOKE ALL ON TABLE results FROM consegne;
GRANT ALL ON TABLE results TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE results TO PUBLIC;


--
-- Name: students; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE students FROM PUBLIC;
REVOKE ALL ON TABLE students FROM consegne;
GRANT ALL ON TABLE students TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE students TO PUBLIC;


--
-- Name: testerrors; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE testerrors FROM PUBLIC;
REVOKE ALL ON TABLE testerrors FROM consegne;
GRANT ALL ON TABLE testerrors TO consegne;
GRANT ALL ON TABLE testerrors TO PUBLIC;


--
-- Name: texts_auxsrcs; Type: ACL; Schema: public; Owner: consegne
--

REVOKE ALL ON TABLE texts_auxsrcs FROM PUBLIC;
REVOKE ALL ON TABLE texts_auxsrcs FROM consegne;
GRANT ALL ON TABLE texts_auxsrcs TO consegne;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE texts_auxsrcs TO PUBLIC;


--
-- PostgreSQL database dump complete
--

