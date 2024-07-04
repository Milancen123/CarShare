--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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

--
-- Name: insert_into_driver(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_into_driver() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if admitted is updated to true
    IF NEW.admited = true THEN
        -- Insert into driver table
        INSERT INTO driver (first_name, last_name, car_model, car_image, bank_acc, plate_number, email, password)
        VALUES (NEW.first_name, NEW.last_name, NEW.car_model, NEW.car_image, NEW.bank_acc, NEW.plate_number, NEW.email, NEW.password);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.insert_into_driver() OWNER TO postgres;

--
-- Name: reduce_num_seats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.reduce_num_seats() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update the num_seats in the ride table
    UPDATE ride
    SET num_seats = num_seats - 1
    WHERE id = NEW.ride_id;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.reduce_num_seats() OWNER TO postgres;

--
-- Name: update_num_seats(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_num_seats() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    available_seats INTEGER;
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Get the current available seats for the ride
        SELECT num_seats INTO available_seats
        FROM ride
        WHERE id = NEW.ride_id;

        -- Check if there are available seats
        IF available_seats > 0 THEN
            -- Decrease num_seats by one
            UPDATE ride
            SET num_seats = num_seats - 1
            WHERE id = NEW.ride_id;
            RETURN NEW;
        ELSE
            -- Raise an exception to prevent insertion
            RAISE EXCEPTION 'No seats available for this ride';
        END IF;
    
    ELSIF TG_OP = 'DELETE' THEN
        -- Increase num_seats by one
        UPDATE ride
        SET num_seats = num_seats + 1
        WHERE id = OLD.ride_id;
        RETURN OLD;
    
    END IF;
END;
$$;


ALTER FUNCTION public.update_num_seats() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: driver; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.driver (
    id bigint NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    car_model character varying(40) NOT NULL,
    car_image bytea DEFAULT '\x4e554c4c'::bytea,
    bank_acc character varying(50) NOT NULL,
    plate_number character varying(20) NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(200) NOT NULL,
    acc_picture bytea
);


ALTER TABLE public.driver OWNER TO postgres;

--
-- Name: driver_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.driver_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.driver_id_seq OWNER TO postgres;

--
-- Name: driver_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.driver_id_seq OWNED BY public.driver.id;


--
-- Name: passenger; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.passenger (
    id bigint NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(200) NOT NULL,
    acc_picture bytea
);


ALTER TABLE public.passenger OWNER TO postgres;

--
-- Name: passenger_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.passenger_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passenger_id_seq OWNER TO postgres;

--
-- Name: passenger_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.passenger_id_seq OWNED BY public.passenger.id;


--
-- Name: registrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registrations (
    id bigint NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    car_model character varying(40) NOT NULL,
    car_image bytea,
    bank_acc character varying(50) NOT NULL,
    plate_number character varying(20) NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(200) NOT NULL,
    admited boolean DEFAULT false NOT NULL
);


ALTER TABLE public.registrations OWNER TO postgres;

--
-- Name: registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.registrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.registrations_id_seq OWNER TO postgres;

--
-- Name: registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.registrations_id_seq OWNED BY public.registrations.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservations (
    ride_id integer NOT NULL,
    passenger_id integer NOT NULL
);


ALTER TABLE public.reservations OWNER TO postgres;

--
-- Name: ride; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ride (
    id bigint NOT NULL,
    driver_id integer NOT NULL,
    num_seats integer NOT NULL,
    price_in_cents integer NOT NULL,
    start_dest character varying(50) NOT NULL,
    end_dest character varying(50) NOT NULL,
    start_time time without time zone NOT NULL,
    date_of_depart date NOT NULL,
    estimated_time time without time zone NOT NULL
);


ALTER TABLE public.ride OWNER TO postgres;

--
-- Name: ride_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ride_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ride_id_seq OWNER TO postgres;

--
-- Name: ride_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ride_id_seq OWNED BY public.ride.id;


--
-- Name: driver id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver ALTER COLUMN id SET DEFAULT nextval('public.driver_id_seq'::regclass);


--
-- Name: passenger id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger ALTER COLUMN id SET DEFAULT nextval('public.passenger_id_seq'::regclass);


--
-- Name: registrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrations ALTER COLUMN id SET DEFAULT nextval('public.registrations_id_seq'::regclass);


--
-- Name: ride id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ride ALTER COLUMN id SET DEFAULT nextval('public.ride_id_seq'::regclass);


--
-- Data for Name: driver; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.driver (id, first_name, last_name, car_model, car_image, bank_acc, plate_number, email, password, acc_picture) FROM stdin;
98	Aleksandra	Stamenkovic	vectra	\\x73646667646667	5269 2340 2340 2034	VR090UB	aleksandra.stamenkovic12345@gmail.com	password1	\N
100	Milan	Nikolic	vectra B	\\x73616173646673	342523452354235	VR090UB	milan.milancen12345@gmail.com	asffs	\N
102	sadfas	asfgasdf	pass	\\x61736661736466	123124141251	sdafasf	lasjfalskjfklasjf	asdlkjfasl	\N
106	Kevin	Nguyen	Toyota Corolla	\N	1234567890	XYZ123	kevin.nguyen@example.com	password123	\N
108	Kimberly	Perez	Audi Q5	\N	2345678901	MNO345	kimberly.perez@example.com	letmein123	\N
113	sadf	sdfasd	sdafsd	\N	sdafs	asdfsdf	sdfasdf@adfasdf	fsafdfasf	\N
116	dsfgdfg	dfsgsdfg	dsfgsdfg	\N	dfgsd	dsfgdfg	nbvmvbmbn@nnbvmbm	cbncvbncvbcvn	\N
122	Justin	Sanchez	Mercedes-Benz E-Class	\N	4567890123	PQR678	justin.sanchez@example.com	p@ssw0rd	\N
123	Olivia	Lopez	Ford F-150	\N	0123456789	WXY890	olivia.lopez@example.com	pass123!	\N
124	Nicholas	Reyes	Chevrolet Silverado	\N	8901234567	HIJ345	nicholas.reyes@example.com	hello123!	\N
125	Laura	Gomez	Ford Explorer	\N	6789012345	EFG012	laura.gomez@example.com	password1!	\N
127	Marko	Petrovi─ç	Fiat 500	\N	RS35231001234567890123	BG123AB	marko.petrovic@example.com	password123	\N
129	Ana	Nikoli─ç	Volkswagen Golf	\N	RS35231001234567890125	NI789EF	ana.nikolic@example.com	password789	\N
131	Jovan	Stojanovi─ç	Ford Fiesta	\N	RS35231001234567890127	SU345IJ	jovan.stojanovic@example.com	password345	\N
133	Andrew	Torres	Kia Optima	\N	8901234567	VWX234	andrew.torres@example.com	password123!	\N
135	Jelena	Luki─ç	Peugeot 208	\N	RS35231001234567890129	NI901MN	jelena.lukic@example.com	password901	\N
137	Vladimir	Filipovi─ç	Mercedes-Benz A-Class	\N	RS35231001234567890136	NS012AB	vladimir.filipovic@example.com	password012	\N
138	Stefan	Risti─ç	Mazda 3	\N	RS35231001234567890130	ZA234OP	stefan.ristic@example.com	password234	\N
139	Milica	Mati─ç	Skoda Octavia	\N	RS35231001234567890133	KG123UV	milica.matic@example.com	password123	\N
141	Aleksandar	─Éor─æevi─ç	Hyundai i30	\N	RS35231001234567890132	KV890ST	aleksandar.djordjevic@example.com	password890	\N
189	a	a	a	\N	a	a	neki@neki.com	$2b$10$REI2a96tN.14C5xzjGbnDuzaiu3zA/.2BwjIm1VjlJ1EBo0XfHB1i	\N
193	Filip	Stula	yugo45	\N	asdfasf	asdfas	alsjfnlksadjfasldkjf	NIJE NISTA	\N
194	Mihajlo	Vidosavljevic	skoda	\N	asdkjfla	asdlkfj	asdlkfjasf	dsaklfjsf	\N
195	Aleksandra	Stamenkovic	toyota	\N	alksdfjask	asdflksj	asdlkjfskl	klfjaslkfsjakl	\N
201	Milan	Nikoli─ç	Range Rover	\N	aslkdflksaflk	sdklfsadlkfsalkj	lkasdflkasdmasdf@lksdmflaskfmsoi.com	$2b$10$2aAn7X2Llahtleu5fnCbzOIKxMNn/N14ZoqZ/hxrI2OxLjuLg9Fm2	\N
206	Milan	Nikolic	Range Rover	\\x4e554c4c	134352135235214	VR090IB	milan@gmail.com	$2b$10$zqADZtlLv0LvXJsoI5iLa.6/L7.QL7Y2GGfPDe6RoMnnDwgitguZC	\N
208	Milan	Nikolic	kldaflkmfsdlkmf	\N	akfmslkfmsal	VR090IB	mnikolic@gmail.com	sdlkfaslkf	\N
209	Milab	Nikolic	lskadjfalksfj	\N	lkdsajflkadjf	klsvklsdfjkl	lkasdjfkljsdfklsajd	alksdjfaslkdj	\N
211	Milan	nikolic	aklsdjalksdfj	\N	sfdaklfjasdlkf	lkasdjflkd	alksdjfklsd	sakdlfjasd	\N
214	Dragana	Nikoli─ç	vec	\N	dsakfask	kslfajks	lkasjfskld@gmalskfmd.comlkajs	$2b$10$NSpb86kPnYKSNup5aqKHteqlVvAFeirg.L14IQtVe0o6suoOW8p0m	\N
99	Aleksandra	Stamenkovic	vectra	\\x73646667646667	5269 2340 2340 2034	VR090UB	aleksandra1.stamenkovic212345@gmail.com	password1	\N
101	Aleks	Stamenkovic	passat	\\x61647366617366	324252151241234	BG020IB	aleks.stamenkovic@gmail.com	Krt213	\N
103	John	Doe	Toyota Camry	\N	1234567890	ABC123	john.doe@example.com	password123	\N
104	Jane	Smith	Honda Accord	\N	0987654321	XYZ987	jane.smith@example.com	securepass	\N
105	Michael	Johnson	Ford Mustang	\N	5678901234	DEF456	michael.johnson@example.com	mysecretpw	\N
107	Michelle	Liu	Chevrolet Equinox	\N	3456789012	GHI789	michelle.liu@example.com	qwerty123	\N
112	PROBA	jdasfkljfslk	laksjflkasjdf	\N	aksdlfjasdlkfj	sdlkfjaslkdf	lkasjflkas@alksfjflk	KLJADLKJFLDKA	\N
114	fkjasdflk	slkdafjslkf	sladkfjsalkf	\N	12321i1900182	lksadjfaslk	lsdakfjsl@sdkljfalkf	Mkokjafsef	\N
120	sdafsadf	fasfasdf	asdfasdf	\N	sadfasdf	asdfasdf	milan.milancen12345@gmail.com343543	sfgsdgsfdg	\N
126	Samantha	Gonzalez	Hyundai Elantra	\N	6789012345	STU901	samantha.gonzalez@example.com	secure1!	\N
128	Nikola	Jovanovi─ç	Renault Clio	\N	RS35231001234567890124	NS456CD	nikola.jovanovic@example.com	password456	\N
130	Ivana	Markovi─ç	Toyota Corolla	\N	RS35231001234567890126	KG012GH	ivana.markovic@example.com	password012	\N
132	Milan	Milo┼íevi─ç	Opel Astra	\N	RS35231001234567890128	PA678KL	milan.milosevic@example.com	password678	\N
134	Stephanie	Rivera	Toyota RAV4	\N	0123456789	YZA567	stephanie.rivera@example.com	passw0rd!	\N
136	Patrick	Nguyen	Honda Pilot	\N	5432109876	BCD789	patrick.nguyen@example.com	123456789	\N
140	Dragana	Kosti─ç	Honda Civic	\N	RS35231001234567890131	UE567QR	dragana.kostic@example.com	password567	\N
142	Filip	Vukovi─ç	Audi A3	\N	RS35231001234567890134	VA456WX	filip.vukovic@example.com	password456	\N
87	Marko	Jovanovi─ç	Ford Focus	\\x756e646566696e6564	123456789	BG123AB	marko@example.com	hashed_password1	\N
88	Jovana	Petrovi─ç	Volkswagen Golf	\\x756e646566696e6564	987654321	NS456CD	jovana@example.com	hashed_password2	\N
89	Stefan	Nikoli─ç	Renault Clio	\\x756e646566696e6564	456789123	NI789EF	stefan@example.com	hashed_password3	\N
90	Ana	Stojanovi─ç	Toyota Corolla	\\x756e646566696e6564	654321987	BG987XY	ana@example.com	hashed_password4	\N
91	Nikola	Popovi─ç	BMW 3 Series	\\x756e646566696e6564	789123456	NS654FG	nikola@example.com	hashed_password5	\N
92	Milica	─Éor─æevi─ç	Mercedes-Benz A-Class	\\x756e646566696e6564	321987654	BG456UV	milica@example.com	hashed_password6	\N
93	Dragan	Kova─ìevi─ç	Audi A4	\\x756e646566696e6564	456123789	NS789IJ	dragan@example.com	hashed_password7	\N
94	Ivana	Markovi─ç	Hyundai i30	\\x756e646566696e6564	987456321	BG654OP	ivana@example.com	hashed_password8	\N
95	Bojan	Simi─ç	Peugeot 308	\\x756e646566696e6564	321789654	NS852KL	bojan@example.com	hashed_password9	\N
96	Jelena	Stankovi─ç	┼ákoda Octavia	\\x756e646566696e6564	654987321	BG789MN	jelena@example.com	hashed_password10	\N
186	a	a	a	\N	a	a	a@a	sadfsdf	\N
192	Mateja	Nikolic	porsche 911	\N	askldjfaslkfjkalsjdf	dflkgsjd	ksajfaklsjfklsjfkl	ksdaljfkasjf	\N
200	Filip	Stula	aslkfjd	\N	sdafklasdfj	alkdsjfk	asldkjf	lksajflksf	\N
207	FILIP	Stula	lasmfdsfkm	\N	kmaslfkakslf	VR090IB	filipficastula@gmail.com	slkjasd;of	\N
210	Milan	Nikolic	a;sdkfsdaklfj	\N	adlskfslkjfd	lksdafaslkd	asdfasdklf	kldafalskf	\N
212	Dragana	Nikoli─ç	vec	\N	dsakfask	kslfajks	lkasjfskld@gmalskfmd.com	$2b$10$0BVOb1xzykuoKWi3IlRiJ.AlU.L2rdOm3gxxq554p8kXDN8cHnTcW	\N
\.


--
-- Data for Name: passenger; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.passenger (id, first_name, last_name, email, password, acc_picture) FROM stdin;
2	Milica	Popovi─ç	milica@example.com	hashed_password2	\N
3	Nikola	Markovi─ç	nikola@example.com	hashed_password3	\N
4	Jovana	Stojanovi─ç	jovana@example.com	hashed_password4	\N
5	Dragan	Petrovi─ç	dragan@example.com	hashed_password5	\N
6	Ana	Simi─ç	ana@example.com	hashed_password6	\N
7	Ivana	─Éor─æevi─ç	ivana@example.com	hashed_password7	\N
8	Bojan	Nikoli─ç	bojan@example.com	hashed_password8	\N
9	Marko	Kova─ìevi─ç	marko@example.com	hashed_password9	\N
10	Jelena	Stankovi─ç	jelena@example.com	hashed_password10	\N
14	Aleksandra	Stamenkovic	aleksandra.stamenkovic12345@gmail.com	password1	\N
15	Mateja	Nikolic	mateja.nikolic12345@gmail.com	$2b$10$6NKGHRq1t0rx0X5Wpf4BHeJKW2obD5GP.JPyDVIghvrjp2vOXhI9W	\N
19	Milan	Nikolic	milan.milancen123456789@gmail.com	$2b$10$A2x2PiP4wvTwtNc2YExZVO3p7wOkdHqBdAHyHz6MfPl9ZaI/5OnhW	\N
21	Milan	Nikolic	milan.milancen1234567810@gmail.com	$2b$10$hchVev7ex5YB2la2tfQGxeVFroEtXu1fntEHN9G4ZPZzF3FeJ7z/C	\N
22	Milan	Nikoli	milan.milancen1@gmail.com	$2b$10$tF13PsdM9K68H7R4zQbXJuMwS0/InFDEw1G2NZ6MpENphgKAROP62	\N
23	Milan	Nikoli	milan.milancen19@gmail.com	$2b$10$zqADZtlLv0LvXJsoI5iLa.6/L7.QL7Y2GGfPDe6RoMnnDwgitguZC	\N
17	Milan	Nikolic	milan.milancen12345678@gmail.com	$2b$10$CI4pcVqsedthgf.nq0qGVezLJfGxykkmbSXe98KhnflhI1zlaBZuO	\N
11	Aleksandra	Stamenkovic	aleksandra.stamenkovic888@gmail.com	$2b$10$CI4pcVqsedthgf.nq0qGVezLJfGxykkmbSXe98KhnflhI1zlaBZuO	\N
24	Filip	Stula	filipfica@gmail.com	$2b$10$zqADZtlLv0LvXJsoI5iLa.6/L7.QL7Y2GGfPDe6RoMnnDwgitguZC	\N
1	Milan	Nikolic NIkolic	stefan@example.com	Nije nista2	\N
13	Milan	Nikolic	milan.milancen12345@gmail.com	{}	\N
\.


--
-- Data for Name: registrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registrations (id, first_name, last_name, car_model, car_image, bank_acc, plate_number, email, password, admited) FROM stdin;
26	Samantha	Gonzalez	Hyundai Elantra	\N	6789012345	STU901	samantha.gonzalez@example.com	secure1!	t
19	Kevin	Nguyen	Toyota Corolla	\N	1234567890	XYZ123	kevin.nguyen@example.com	password123	t
22	Michelle	Liu	Chevrolet Equinox	\N	3456789012	GHI789	michelle.liu@example.com	qwerty123	t
24	Kimberly	Perez	Audi Q5	\N	2345678901	MNO345	kimberly.perez@example.com	letmein123	t
25	Justin	Sanchez	Mercedes-Benz E-Class	\N	4567890123	PQR678	justin.sanchez@example.com	p@ssw0rd	t
36	Olivia	Lopez	Ford F-150	\N	0123456789	WXY890	olivia.lopez@example.com	pass123!	t
31	Nicholas	Reyes	Chevrolet Silverado	\N	8901234567	HIJ345	nicholas.reyes@example.com	hello123!	t
30	Laura	Gomez	Ford Explorer	\N	6789012345	EFG012	laura.gomez@example.com	password1!	t
39	Marko	Petrovi─ç	Fiat 500	\N	RS35231001234567890123	BG123AB	marko.petrovic@example.com	password123	t
40	Nikola	Jovanovi─ç	Renault Clio	\N	RS35231001234567890124	NS456CD	nikola.jovanovic@example.com	password456	t
41	Ana	Nikoli─ç	Volkswagen Golf	\N	RS35231001234567890125	NI789EF	ana.nikolic@example.com	password789	t
42	Ivana	Markovi─ç	Toyota Corolla	\N	RS35231001234567890126	KG012GH	ivana.markovic@example.com	password012	t
43	Jovan	Stojanovi─ç	Ford Fiesta	\N	RS35231001234567890127	SU345IJ	jovan.stojanovic@example.com	password345	t
44	Milan	Milo┼íevi─ç	Opel Astra	\N	RS35231001234567890128	PA678KL	milan.milosevic@example.com	password678	t
27	Andrew	Torres	Kia Optima	\N	8901234567	VWX234	andrew.torres@example.com	password123!	t
28	Stephanie	Rivera	Toyota RAV4	\N	0123456789	YZA567	stephanie.rivera@example.com	passw0rd!	t
45	Jelena	Luki─ç	Peugeot 208	\N	RS35231001234567890129	NI901MN	jelena.lukic@example.com	password901	t
29	Patrick	Nguyen	Honda Pilot	\N	5432109876	BCD789	patrick.nguyen@example.com	123456789	t
52	Vladimir	Filipovi─ç	Mercedes-Benz A-Class	\N	RS35231001234567890136	NS012AB	vladimir.filipovic@example.com	password012	t
46	Stefan	Risti─ç	Mazda 3	\N	RS35231001234567890130	ZA234OP	stefan.ristic@example.com	password234	t
49	Milica	Mati─ç	Skoda Octavia	\N	RS35231001234567890133	KG123UV	milica.matic@example.com	password123	t
47	Dragana	Kosti─ç	Honda Civic	\N	RS35231001234567890131	UE567QR	dragana.kostic@example.com	password567	t
48	Aleksandar	─Éor─æevi─ç	Hyundai i30	\N	RS35231001234567890132	KV890ST	aleksandar.djordjevic@example.com	password890	t
50	Filip	Vukovi─ç	Audi A3	\N	RS35231001234567890134	VA456WX	filip.vukovic@example.com	password456	t
54	Mateja	Nikolic	porsche 911	\N	askldjfaslkfjkalsjdf	dflkgsjd	ksajfaklsjfklsjfkl	ksdaljfkasjf	t
59	Aleksandra	Stamenkovic	toyota	\N	alksdfjask	asdflksj	asdlkjfskl	klfjaslkfsjakl	t
60	Filip	Stula	aslkfjd	\N	sdafklasdfj	alkdsjfk	asldkjf	lksajflksf	t
65	FILIP	Stula	lasmfdsfkm	\N	kmaslfkakslf	VR090IB	filipficastula@gmail.com	slkjasd;of	t
66	Milan	Nikolic	kldaflkmfsdlkmf	\N	akfmslkfmsal	VR090IB	mnikolic@gmail.com	sdlkfaslkf	t
67	Milab	Nikolic	lskadjfalksfj	\N	lkdsajflkadjf	klsvklsdfjkl	lkasdjfkljsdfklsajd	alksdjfaslkdj	t
69	Milan	Nikolic	a;sdkfsdaklfj	\N	adlskfslkjfd	lksdafaslkd	asdfasdklf	kldafalskf	t
70	Milan	nikolic	aklsdjalksdfj	\N	sfdaklfjasdlkf	lkasdjflkd	alksdjfklsd	sakdlfjasd	t
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservations (ride_id, passenger_id) FROM stdin;
97	14
97	9
83	6
84	3
96	13
95	13
91	11
83	5
90	5
90	3
90	4
91	6
85	1
91	13
100	13
83	11
84	11
88	11
86	11
89	11
87	11
91	15
95	15
84	15
88	15
97	13
100	11
96	11
\.


--
-- Data for Name: ride; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ride (id, driver_id, num_seats, price_in_cents, start_dest, end_dest, start_time, date_of_depart, estimated_time) FROM stdin;
85	91	2	2000	─îa─ìak	Kraljevo	12:10:00	2024-06-24	01:00:00
98	91	2	1500	Gnjilane	Kragujevac	14:00:00	2024-06-28	03:00:00
90	96	1	3200	Be─ìej	Senta	17:20:00	2024-06-29	01:30:00
88	94	1	1900	Leskovac	Vranje	15:30:00	2024-06-27	01:45:00
86	92	1	1200	U┼╛ice	Valjevo	13:00:00	2024-06-25	01:30:00
87	93	3	2800	Sombor	Sremska Mitrovica	14:15:00	2024-06-26	02:00:00
84	90	1	3000	Zrenjanin	Pan─ìevo	11:20:00	2024-06-23	01:45:00
89	95	1	1600	┼áabac	Loznica	16:45:00	2024-06-28	01:15:00
91	87	0	1500	Gnjilane	Beograd	08:00:00	2024-06-29	04:00:00
83	89	1	1500	Ni┼í	Kragujevac	10:45:00	2024-06-22	01:00:00
100	91	1	1200	Beograd	Nis	17:00:00	2024-07-05	02:00:00
99	91	4	1500	Kragujevac	Beograd	14:00:00	2024-06-30	01:30:00
96	94	2	1500	Gnjilane	Beograd	12:00:00	2024-06-29	04:00:00
95	96	2	1000	Gnjilane	Beograd	10:00:00	2024-06-29	03:50:00
125	206	1	1139	Kikinde	Beograd	15:41:00	2024-06-29	01:30:00
97	93	0	1200	Gnjilane	Beograd	08:00:00	2024-06-29	03:50:00
120	206	1	1234	Beograd	Vranje	12:49:00	2024-07-11	01:30:00
123	206	1	1234	Beograd	Vranje	12:49:00	2024-07-11	01:30:00
\.


--
-- Name: driver_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.driver_id_seq', 215, true);


--
-- Name: passenger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.passenger_id_seq', 24, true);


--
-- Name: registrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registrations_id_seq', 70, true);


--
-- Name: ride_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ride_id_seq', 125, true);


--
-- Name: driver driver_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver
    ADD CONSTRAINT driver_email_key UNIQUE (email);


--
-- Name: driver driver_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.driver
    ADD CONSTRAINT driver_pkey PRIMARY KEY (id);


--
-- Name: passenger passenger_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_email_key UNIQUE (email);


--
-- Name: passenger passenger_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.passenger
    ADD CONSTRAINT passenger_pkey PRIMARY KEY (id);


--
-- Name: registrations registrations_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT registrations_email_key UNIQUE (email);


--
-- Name: registrations registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registrations
    ADD CONSTRAINT registrations_pkey PRIMARY KEY (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (ride_id, passenger_id);


--
-- Name: ride ride_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ride
    ADD CONSTRAINT ride_pkey PRIMARY KEY (id);


--
-- Name: registrations insert_driver_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_driver_trigger AFTER UPDATE OF admited ON public.registrations FOR EACH ROW EXECUTE FUNCTION public.insert_into_driver();


--
-- Name: reservations reservations_delete_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER reservations_delete_trigger AFTER DELETE ON public.reservations FOR EACH ROW EXECUTE FUNCTION public.update_num_seats();


--
-- Name: reservations reservations_insert_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER reservations_insert_trigger AFTER INSERT ON public.reservations FOR EACH ROW EXECUTE FUNCTION public.update_num_seats();


--
-- Name: reservations reservations_passenger_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_passenger_id_fkey FOREIGN KEY (passenger_id) REFERENCES public.passenger(id) ON DELETE CASCADE;


--
-- Name: reservations reservations_ride_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_ride_id_fkey FOREIGN KEY (ride_id) REFERENCES public.ride(id) ON DELETE CASCADE;


--
-- Name: ride ride_driver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ride
    ADD CONSTRAINT ride_driver_id_fkey FOREIGN KEY (driver_id) REFERENCES public.driver(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

