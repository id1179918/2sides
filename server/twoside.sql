--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3
-- Dumped by pg_dump version 14.3

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
-- Name: asset_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.asset_role AS ENUM (
    'primary',
    'secondary',
    'background',
    'gallery',
    'presskit'
);


ALTER TYPE public.asset_role OWNER TO postgres;

--
-- Name: entity_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.entity_type AS ENUM (
    'artist',
    'event',
    'roster'
);


ALTER TYPE public.entity_type OWNER TO postgres;

--
-- Name: hex_color; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.hex_color AS text
	CONSTRAINT hex_color_check CHECK ((VALUE ~* '^#([0-9a-f]{6}|[0-9a-f]{3})$'::text));


ALTER DOMAIN public.hex_color OWNER TO postgres;

--
-- Name: link_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.link_type AS ENUM (
    'website',
    'merch',
    'instagram',
    'facebook',
    'youtube',
    'soundcloud',
    'bandcamp',
    'mixcloud',
    'ticketing',
    'ra',
    'live',
    'release'
);


ALTER TYPE public.link_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    last_login_at timestamp without time zone
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_id_seq OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;


--
-- Name: artist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist (
    id integer NOT NULL,
    name text,
    location text,
    style text,
    description text
);


ALTER TABLE public.artist OWNER TO postgres;

--
-- Name: artist_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist_event (
    artist_id integer NOT NULL,
    event_id integer NOT NULL
);


ALTER TABLE public.artist_event OWNER TO postgres;

--
-- Name: artist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.artist_id_seq OWNER TO postgres;

--
-- Name: artist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artist_id_seq OWNED BY public.artist.id;


--
-- Name: artist_roster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artist_roster (
    artist_id integer NOT NULL,
    roster_id integer NOT NULL
);


ALTER TABLE public.artist_roster OWNER TO postgres;

--
-- Name: asset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset (
    id integer NOT NULL,
    original_name text NOT NULL,
    storage_key text NOT NULL,
    mime_type text NOT NULL,
    size_bytes bigint NOT NULL,
    checksum text,
    extension text,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.asset OWNER TO postgres;

--
-- Name: asset_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.asset_id_seq OWNER TO postgres;

--
-- Name: asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_id_seq OWNED BY public.asset.id;


--
-- Name: entity_asset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_asset (
    id integer NOT NULL,
    entity_type public.entity_type NOT NULL,
    entity_id integer NOT NULL,
    asset_id integer NOT NULL,
    role public.asset_role NOT NULL,
    "position" integer
);


ALTER TABLE public.entity_asset OWNER TO postgres;

--
-- Name: entity_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entity_asset_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_asset_id_seq OWNER TO postgres;

--
-- Name: entity_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entity_asset_id_seq OWNED BY public.entity_asset.id;


--
-- Name: entity_link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_link (
    id integer NOT NULL,
    entity_type public.entity_type NOT NULL,
    entity_id integer NOT NULL,
    link_id integer NOT NULL
);


ALTER TABLE public.entity_link OWNER TO postgres;

--
-- Name: entity_link_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entity_link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_link_id_seq OWNER TO postgres;

--
-- Name: entity_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entity_link_id_seq OWNED BY public.entity_link.id;


--
-- Name: entity_palette; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entity_palette (
    id integer NOT NULL,
    entity_type public.entity_type NOT NULL,
    entity_id integer NOT NULL,
    primary_color public.hex_color DEFAULT '#ffffff'::text NOT NULL,
    secondary_color public.hex_color DEFAULT '#ffffff'::text NOT NULL,
    text_color public.hex_color DEFAULT '#ffffff'::text NOT NULL,
    title_color public.hex_color DEFAULT '#ffffff'::text NOT NULL,
    link_color public.hex_color DEFAULT '#ffffff'::text NOT NULL,
    price_color public.hex_color DEFAULT '#ffffff'::text NOT NULL
);


ALTER TABLE public.entity_palette OWNER TO postgres;

--
-- Name: entity_palette_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entity_palette_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entity_palette_id_seq OWNER TO postgres;

--
-- Name: entity_palette_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entity_palette_id_seq OWNED BY public.entity_palette.id;


--
-- Name: event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event (
    id integer NOT NULL,
    name text,
    location text,
    description text,
    style text,
    price integer,
    date date,
    is_sold_out boolean DEFAULT false NOT NULL
);


ALTER TABLE public.event OWNER TO postgres;

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_id_seq OWNER TO postgres;

--
-- Name: event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_id_seq OWNED BY public.event.id;


--
-- Name: link; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.link (
    id integer NOT NULL,
    type public.link_type NOT NULL,
    url text NOT NULL,
    label text
);


ALTER TABLE public.link OWNER TO postgres;

--
-- Name: link_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.link_id_seq OWNER TO postgres;

--
-- Name: link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.link_id_seq OWNED BY public.link.id;


--
-- Name: roster; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roster (
    id integer NOT NULL,
    name text,
    year integer,
    style text,
    description text
);


ALTER TABLE public.roster OWNER TO postgres;

--
-- Name: roster_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roster_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roster_id_seq OWNER TO postgres;

--
-- Name: roster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roster_id_seq OWNED BY public.roster.id;


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: artist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist ALTER COLUMN id SET DEFAULT nextval('public.artist_id_seq'::regclass);


--
-- Name: asset id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset ALTER COLUMN id SET DEFAULT nextval('public.asset_id_seq'::regclass);


--
-- Name: entity_asset id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_asset ALTER COLUMN id SET DEFAULT nextval('public.entity_asset_id_seq'::regclass);


--
-- Name: entity_link id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_link ALTER COLUMN id SET DEFAULT nextval('public.entity_link_id_seq'::regclass);


--
-- Name: entity_palette id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_palette ALTER COLUMN id SET DEFAULT nextval('public.entity_palette_id_seq'::regclass);


--
-- Name: event id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event ALTER COLUMN id SET DEFAULT nextval('public.event_id_seq'::regclass);


--
-- Name: link id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link ALTER COLUMN id SET DEFAULT nextval('public.link_id_seq'::regclass);


--
-- Name: roster id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roster ALTER COLUMN id SET DEFAULT nextval('public.roster_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, email, password_hash, is_active, created_at, last_login_at) FROM stdin;
1	lea2sides@gmail.com	$2b$12$fRBdOK9jBXSXqLS5uWuVZOb9qeg2io1v.68wXBxmDxduwMIGQjtA6	t	2026-01-15 13:29:48.409874	\N
2	exyleprod@gmail.com	$2b$12$DJIJVlSQsB.neq1TaaM.r.iy.LTyElpUWYQBCGeWRociBp8NKJlUa	t	2026-01-15 13:32:43.800863	2026-03-03 14:39:13.088327
\.


--
-- Data for Name: artist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artist (id, name, location, style, description) FROM stdin;
10	Koffi	Lyon, FR	Electro	Did anyone ask for a Koffi ? À l’instar de cette boisson envoûtante et profonde, il réchauffe les cœurs de celles et ceux qui prennent le temps de l’écouter, en dévoilant ses états d’âme en rythme. Influencé par la musique classique en passant par le jazz, le rock, la pop 90-2000, le RnB et les sons de teuf, Koffi commence à mixer en 2018, ajoutant rapidement à ses sets des sons plus sombres et breakés. Il commence la production en 2020 avec Funktroid et rejoint le collectif lyonnais BMK en 2023, porté par ses amis Aladdin, Lazerman et Sweely. En 2024, il introduit des sonorités électro et disco, réalise son premier live et sort sa première track sur UnderGroove. Il agrandit son univers musical vers la minimal, la deep et la techno en 2025, sublimant ce mélange de dynamisme chaleureux et de mystère qu’il impose sur scène. En juin, il sort son premier EP, “LGVG003”, sur le label Legram VG. Tel un bon expresso, Koffi tonifie la foule et l’embarque dans son univers : complexe mais accessible, mental mais sexy, terre à terre mais hors cadre. Bref, votre Koffi est prêt.
7	Blinkduus Dischetto	Corse, FR	Electro	Il se fait appeler Blinkduus Dischetto. Entendez par là « golden record ». Bien inspiré par les énergies de sa corse natale, le prodige se consacre entièrement à son art et sa musique. Celle-ci se veut belle, colorée, extravagante, touchante. Bien qu’il flirte avec la French Touch, l’IDM ou encore l'expérimental, son style est bien inclassable et tend à explorer un large spectre d’émotions. Ses morceaux sont peu conventionnels, parfois en marge de ce qui se fait par ailleurs, un peu comme son île avec le continent.
4	Highbudub	Lyon, FR	Dub	Highbudub, collectif influent de la scène dub à Lyon et en France. Ce carré d’as formé de dub makers, de MC's et de personnes à tout faire s’est forgé une solide réputation depuis 2016. Leur sélection mais surtout leurs productions musicales naviguent des racines du reggae aux explorations électroniques et alternatives.\nL'une des signatures du collectif est le Highbudub Soundsystem : un sound moins traditionnel, qui mêle la technologie vintage des scoops à la modernité des Paraflex pour offrir une expérience sonore puissante et immersive. Adapté aussi bien au dub qu’aux sonorités électroniques, ce sound system reflète l’essence d’un collectif tout terrain, novateur et accessible, aussi bien pour les oreilles averties que pour les amateurs.\nHighbudub et son sound incarnent un engagement artistique original et généreux, qui continue de résonner à chaque performance.
5	Roots I-Vories	Montpellier, FR	Dub	Impossible de savoir combien de festivals il a traversés avant même de savoir marcher. Depuis tout petit, il vibre au son du reggae roots et du Dub UK, trimballé de festival en festival par des parents passionnés. À 16 ans, il plonge dans la collection de vinyles, à 20, il mixe déjà pour plusieurs crews et enregistre ses premières dubplates avec des légendes comme Don Carlos, Horace Andy ou Queen Omega.\n D’abord aventure à deux, aujourd’hui menée en solo, Roots-I-Vories poursuit son chemin sans perdre l’essence de son histoire. Selecta, opérateur, MC, il manie la musique comme un langage, construit ses sets comme des manifestes, où chaque track résonne d’un message clair : unité, respect, égalité. Armé d’une sélection affûtée et d’un projet sound system en gestation, il continue d’écrire son histoire, une basse après l’autre.
9	IMA:R	Lyon, FR	Electro	Et que ça groove ! C’est le mot d’ordre d’IMA:R, et le premier critère qui lui fait repérer un bon morceau. Depuis ses 10 ans, elle développe une véritable frénésie autour du dig : des heures à chercher des sonorités funk, avant même de savoir que cette quête avait un nom. Elle grandit entre bossa nova, soul et classique, avec un père fan de Saint Germain et des CD d’Hôtel Costes, qu’elle connaît encore par cœur aujourd’hui. À l’adolescence, la deep house entre dans sa vie; les années affinent ensuite son oreille jusqu’à une vraie révélation : la minimal house. Après une claque prise au festival Nostromo, se glisser derrière les platines s’impose comme une évidence. Sur scène, IMA:R raconte des histoires à travers ses sélections. Cela lui permet aussi de partager avec le public ses dernières trouvailles. Pour y parvenir, elle aborde la musique comme une véritable science qu’elle applique avec précision, toujours complétée par les émotions qui l’habitent. Elle les délivre alors à doux coups de disques, tirés de son répertoire aussi acéré qu’éclectique.
50	Loctop	Lyon, FR	Electro	Loctop, ce sélectionneur membre du collectif Mad Gone est un pur produit lyonnais. Élevé et influencé par la scène de sa ville, il a su se faire un nom parmi les artistes les plus talentueux de Lyon grâce à sa touche personnelle. Avec sa palette de styles variés, Loctop est considéré par ses pairs comme un des DJ les plus tout terrain, fort d'une sélection aussi diversifiée que pointue. \nDoté d'une sensibilité certaine, Loctop aime profondément la musique qu'il joue et veille toujours, à travers ses sets, à transmettre tout le spectre d'émotions qu'elle lui procure. \n
52	Pastel	Marseille, FR	Electro	Discrète, mais toujours envoûtante, Pastel aime surprendre sans hausser la voix. Entre Paris et Marseille, downtempo ou minimal, elle joue des récits sonores à savourer lentement, embrassant, une fois la nuit tombée, des rythmes sexy et breakés. Le reste, elle le tisse dans l’ombre : une atmosphère que l’on ne comprend qu’en la vivant.
56	Radikal Vibration	Genève, CH	Dub	En 2015, de la rencontre des deux jeunes crews genevois High Skank et Youth Solidarity, naît une nouvelle entité musicale : Radikal Vibration.\nLe collectif s’impose rapidement comme une force tranquille de la scène genevoise, portée par une passion commune : le dub et le reggae dans leur essence la plus authentique. Leur ancrage se situe dans l’école anglaise : Aba Shanti, Iration Steppas, Russ Disciples et une large partie de la lignée UK dub.\nRésidents du mythique Corner25 jusqu’à sa fermeture en 2019, ils ont forgé leur identité à travers les sessions sound system, des caves de squats aux lieux culturels comme l’Usine, en passant par les festivals et les free parties. Après avoir conçu leur propre sound system artisanal, le crew choisit de concentrer son énergie sur la production musicale.\nEn 2017, leur collaboration avec Evidence Music donne naissance à une série de projets marquants notamment la production d’une grande partie des albums “Code Name” et “Twelve Lights” de Brother Culture (Jump Up Pon It), Nello B, ainsi que  le single “Give them Strength” sur Jackaya Records. En parallèle, le crew multiplie les productions et albums autoproduits (Dub Mechanisms, Ministry of Truth), consolidant son identité sonore.\nAujourd’hui, leurs dubplates et productions sont jouées par Channel One, O.B.F, Cultural Warrior et bien d’autres sur la scène européenne. Leur diversité musicale leur permet d'imposer sur scène une sorte d’ambiance aussi catégorique que conciliante : souvent joués en last tune, leur versatilité n’est plus à prouver.\n
60	High Salute	\N	Dub	\N
51	Zegaz	Lyon, FR	Electro	The Gas dit Zegaz est un personnage bien singulier. Son visage juvénile et sa personnalité réservée contrastent bien souvent avec l'expression engagée de son univers musical derrière les decks. \nDans son enfance, le "gone" a été influencé par bon nombre de styles musicaux comme le jazz ou le rock qui ont fait naître chez lui un amour pour le son brut et les notes psychédéliques. On retrouve cette marque bien à lui dans sa sélection \nrichement nourrie à coup de minimal, de techno ou encore d'électro. \n
55	Soul Vibes	Thoiry, FR	Dub	Ils s’appellent Soul Vibes, un nom qui résume déjà leur intention : rendre à la culture ce qu’elle leur a offert.\nNé en 2020 dans un home studio bricolé avec patience, le duo formé par Hugo (le freestyler, la voix) et Vass (le constructeur, l’alchimiste du son) a peu à peu bâti son propre écosystème. Tout est fait maison : de la musique, en passant par la sono, la production, les sessions, jusqu’au label.\nEn quelques années, Soul Vibes a multiplié les expériences : des scènes partagées avec des artistes internationaux, des collaborations avec une bonne partie des crews Genevois, faire vivre un label actif et lancer leur propre festival, Dub Kingdom, co-organisé avec D47.\nLeur son puise dans la tradition UK sans jamais s’y enfermer : un mélange vivant de chaleur analogique, de dub industriel et expérimental, et d’impulsions robotiques, posé sur un solide tapis de fondations roots, reggae et rubadub. Chaque session ressemble à un décollage : la sono en moteur, le public en équipage, la destination quelque part entre le corps et l’âme, là où la musique touche vraiment. \nSoul Vibes est né d’un besoin vital. La culture sound system les a portés, et maintenant ils restituent cette énergie : le public repart le cœur léger et les batteries pleines.\n
47	SELA	Valence, FR	Electro	Fer de lance de la scène lyonnaise, ce DJ/producteur a commencé à user des tourne-disques il y a près de 10 ans, du côté de Londres. Il fait partie de ces artistes à la collection ultra diversifiée, balayant tous les styles, de l'ambient/downtempo à l'electro/techno en passant par la trance.\nMais il ne joue pas que la musique des autres et cuisine lui-même ses propres morceaux, avec des sorties sur Ya.r, Dürüm Record, Parallel Connection ou bientôt dans sa propre maison : Secret Feta\n
48	Baptiste Coppel	Lyon, FR	Electro	Baptiste Coppel, de son vrai nom, Baptiste Coppel est un DJ français basé à Lyon. Originaire de Haute-Savoie, il a posé ses valises dans la troisième ville française il y a quelques années et y a construit sa réputation de diggeur infatigable et de fin sélectionneur. Maîtrisant parfaitement sa technique, il est sans cesse à la recherche de gemmes à la fois efficaces et sophistiquées, toujours avec une touche très singulière. \nQue ce soit en warm-up, peak-time, closing ou même after, Baptiste Coppel est capable de distiller le meilleur des styles tech house/minimal, electro/techno ou encore dark disco, qu'il sait habilement assembler selon le lieu et le moment. 
49	Gogo Gadgeto	Lyon, FR	Electro	Voici notre inspecteur. \nSon travail : faire danser.\n\nPour ça, il collectionne toutes sortes de gadgets. Parfois effrayants, parfois loufoques, parfois oniriques. Comme tout bon collectionneur, il n'en a jamais assez alors il en fabrique lui-même en donnant aux pistes un look rétro, futuriste ou même farfelu toujours avec le but de mener à bien sa mission.
53	Nins OHM Sound	Lyon, FR	Dub	Tout commence par une claque.\n\n2016, devant Pilah, Fabasstone, Roots Raid et Dub Shepherds : la révélation, le besoin de live, d’immédiat, d’analogique… et d’une claque, une autre avec les expériences Dubquake, puis ses premières sessions studio, jusqu’aux dubplates avec Bambow’one et Earl 16 ! \n\nProducteur et performer, Nins avance entre machines, faders et émotions. Il puise sa force dans une approche ouverte, mêlant les codes de la nouvelle génération et l’héritage des pionniers, studios des années 90 et Dub Uk, piochant dans chaque sous-style du dub pour en révéler l’essence. Ses passages en Open Air Lyon, à la Mahkno, au Sucre ou au Subside Festival lui ont permis d’affiner et d’affirmer sa signature live.\n\nSur scène, Nins ne se contente pas de jouer : il habite l’espace. Ses gestes, précis et habités, traduisent une passion qui attire naturellement le regard. Son live est un atelier vivant, un labo, une cuisine où l’on expérimente en direct, goûtant à l’intuition et à l’improvisation, guidés par sa rigueur et son intensité scénique.\n
54	Dubfact	Lyon, FR	Dub	Dubfact est un projet issu de la culture sound system et d’un long parcours collectif. À 15 ans, il découvre le sound system à la Tannerie à Bourg (Dub Invaders). Le stack, les artistes en régie, le public face au son. Une culture où il se sent naturellement à l’aise. Le déclic est là.\n\nFormé à la musique dès l’enfance, il débute la batterie à 9 ans, passe par l’école de musique et le conservatoire, puis joue dans plusieurs groupes. À 17 ans, il cofonde Subtroopers, expérience fondatrice. Plus tard, il découvre la production sur Logic Pro. Quelques nuits blanches suffiront à changer sa manière de créer : la composition prend alors une nouvelle place.\n\nEn 2016, le sound meeting Dub Echo au Transbordeur (OBF, Blackboard, Legal Shot) ancre une certitude : le sound system est un moyen de diffusion à part, avec ses propres codes et sa propre force. \nAvec le projet Dubfact, il prolonge cette trajectoire et considère son projet personnel comme intrinsèquement collectif, de par la nature de la musique.\nSon univers navigue entre dub, bass music, dubstep, nourri par des influences larges. De Flume à Ivy Lab, de Kendrick Lamar à Vulfpeck, sans hiérarchie.\n\nEngagé, Dubfact voit toujours dans les sessions sound system une occasion de faire une piqûre de rappel sur les valeurs de ce milieu. Aujourd’hui, rappeler l’histoire et l’ancrage politique de la culture sound system lui paraît nécessaire. Dépolitiser les lieux fragilise des espaces culturels déjà précaires et laisse circuler des idées qui n’ont jamais soutenu cette culture. Pour lui, cela passe aussi par une musique portée avec engagement.\n
57	Leruja	Bourg-en-Bresse, FR	Dub	Leruja découvre le dub en 2017 ou plutôt, le dub le trouve. La musique s’impose à lui de manière instinctive et l’amène à la production dès 2019.\nÀ partir de 2020, il sort ses premiers morceaux. En 2022, il publie Sky Attack, son premier EP, et entame une collaboration avec Mysticwood, label sur lequel il sortira ensuite Dubwise Attraction.\nÀ ses débuts, Leruja joue en France et à l’étranger, avec des dates en Belgique, en Espagne et en Allemagne, et rencontre différents crews, producteurs et sound systems.\nOriginaire de Bourg-en-Bresse, il se construit au contact de sa scène régionale, avec des références comme B-Side Crew, KPC ou OBF, et d’autres influences telles qu’Iration Steppas ou Mungo’s Hi Fi. Il est également membre actif du collectif Subtroopers depuis 2021.\nSon style oscille entre intensité, énergie et introspection. En session, son envie de lâcher prise prend le dessus : Leruja joue à l’instinct, dans un échange direct avec le public, en captant son énergie pour la lui renvoyer aussitôt.\n
58	MAG-D	Lyon, FR	Dub	On parle d'un touche à tout, un explorateur sans limite. Ses productions balayant le large spectre des musiques électroniques prouvent que le Dub n'est pour lui qu'une des pages de son encyclopédie musicale. Il s'agit néanmoins de son coup de foudre le plus fort, lequel l'a poussé à fonder High Budub et d'y tracer son chemin de manière complètement autodidacte
59	SubTroopers	Bourg-en-Bresse, FR	Dub	Créateurs des célèbres soirées Bass Segment à "BB Town" (Bourg-en-Bresse), Subtroopers sound system est un collectif activiste de la culture dub en France depuis 2016. En plus de sonoriser et d'organiser des événements, le collectif produit sa propre musique et s'attèle à l'émergence d'une nouvelle scène dub originale. Les producteurs Dubfact et Leruja arborent une identité marquée par une formule live oscillant entre le dub, la techno et la bass music.
1	Chaka Chaka	Jura, FR	Dub	'We are not the best, we don’t play the loudest, but we are one thing, we are the smiliest'. Telle est la devise de Chaka Chaka. Amoureux de musique et du reggae, le Jurassien s’efforce ,avec beaucoup de sincérité, de faire vivre la musique avec le cœur et de porter haut les valeurs du dub.\nOn ne vous servira pas le classique 'sélection variée du roots au stepper'. À la place, on vous laissera le soin de venir découvrir l'énergie qui l’anime en session.\nChaka Chaka, c’est aussi un clin d'œil au patois jamaïcain: quelque chose de bancal, de désorganisé. Une façon d’assumer l’imperfection et de cultiver l’authenticité.\nUne volonté de rappeler les valeurs fondamentales du mouvement reggae et de se les réapproprier : Amour, Respect etUnité.
\.


--
-- Data for Name: artist_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artist_event (artist_id, event_id) FROM stdin;
1	1
4	1
5	1
7	1
1	2
5	2
\.


--
-- Data for Name: artist_roster; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artist_roster (artist_id, roster_id) FROM stdin;
\.


--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset (id, original_name, storage_key, mime_type, size_bytes, checksum, extension, created_at) FROM stdin;
109	CV-ThomasRoustan-A.pdf	16c1cabc-503a-4266-b60d-cb9e29b69f5d.pdf	application/pdf	867895	\N	.pdf	2026-03-05 11:04:40.275701
55	07f1a99f-7906-47e6-a8ea-97eb40bcefa3	c3a5f62a-312c-4cbe-b87e-e60970f312ba	application/octet-stream	459577	\N		2026-02-03 14:16:31.145564
57	2f409a21-eeb4-42a9-a783-c48af732dae6	367a1d2d-a8da-4aaa-9fe3-08416b606a61	application/octet-stream	289566	\N		2026-02-03 14:18:42.182912
66	e02821c9-6fe6-4b7f-8177-73ba21580ed0	07e677ab-a40b-4103-9d00-6932083c29cb	application/octet-stream	388077	\N		2026-02-03 14:23:40.625822
71	d350036d-a760-4649-948d-8cc12806f5b4	1163dfac-2f45-49d3-be6e-ed48d25bea46	application/octet-stream	508442	\N		2026-02-03 14:26:27.573334
75	068bab77-86dd-41a4-a355-6d5e8bae4abb	478d6dfc-c017-4146-9c00-2a5884bcebfd	application/octet-stream	769056	\N		2026-02-03 14:29:03.551862
76	e8c63448-aad7-4da1-a6e9-d8e48f2862c9	ce6d2772-8517-431f-a21a-70b3a7237703	application/octet-stream	1823655	\N		2026-02-03 14:50:08.946593
77	bf0fb852-401c-4d43-a21f-6b9c060f2234	39eec2be-e961-441a-969b-3f6dc1cf7b7e	application/octet-stream	1823655	\N		2026-02-03 15:15:55.884433
78	6a6eaf49-66e5-4498-bc7d-bca081245b0c	0ba77300-09f8-458b-900f-f74f4d82ece9	application/octet-stream	1823655	\N		2026-02-03 15:16:25.440839
79	adc0cc59-ac37-4b8f-8e24-30d35e67080e	8fd9cc11-e6b4-4368-9719-9a32bac80e27	application/octet-stream	1823655	\N		2026-02-03 15:27:55.42803
80	d5b94545-9922-493b-a79a-55ccbc245570	539edfd0-5db1-4f95-af66-03b2abdbea48	application/octet-stream	1823655	\N		2026-02-03 15:28:09.880087
85	b6df4719-9f8b-4be7-84c5-e177cc18a77e	8a3d2f3c-8bd8-4ebc-9fe1-ff510bb5dc93	application/octet-stream	926903	\N		2026-03-02 11:58:58.659794
86	5585ce91-8a9a-4b98-bf33-00f8f441423b	23883eda-a7b2-49ec-9678-dfc57097bd99	application/octet-stream	926903	\N		2026-03-02 12:28:34.416963
87	68d80275-9cab-4358-b54f-7ffc894101f2	65e9674c-5cc1-4013-b4b1-ac87cfa1838b	application/octet-stream	926903	\N		2026-03-02 12:29:41.482462
88	505430c2-d590-4bdd-8dc2-8864496b3226	399fb437-9f91-4107-bdcb-37bc5415cb03	application/octet-stream	926903	\N		2026-03-02 12:34:30.009447
89	7f809cfd-2170-4fa3-ae84-90c191c84549	1fc1aedd-1804-4d11-84cf-4fee8dc3f21b	application/octet-stream	926903	\N		2026-03-02 12:34:55.909301
91	7f9b901f-0b01-4619-8f72-3cfe3e06c049	4cf525b3-55bd-4c8d-82eb-1ec2ae09c30f	application/octet-stream	926903	\N		2026-03-02 13:44:10.447936
92	1636fab1-a5d4-40c1-b357-f66a7ea736a4	4b6c561b-2d5a-46a7-a2a8-5c78b01ab37b	application/octet-stream	918980	\N		2026-03-02 13:45:40.20324
93	201c6381-6c5d-4cba-802e-a0c2288a33f9	ff8323f7-4fe8-497c-bee0-2b094a580a24	application/octet-stream	1024519	\N		2026-03-02 13:47:19.489326
94	0276b5b8-2677-4e24-909a-a308e9b302b1	8f3fb6c7-f27d-4d5e-9566-b2eab65604d2	application/octet-stream	1030352	\N		2026-03-02 13:48:07.463326
95	68495274-0b87-4a01-9633-eddf679539e5	0f0da00d-4308-4495-b688-38ae5303462d	application/octet-stream	900118	\N		2026-03-02 13:49:02.286643
96	da058f48-a17c-419a-b2b9-1ff78489d72d	70717c4b-6681-443f-9a43-9b7e37ce9dba	application/octet-stream	965191	\N		2026-03-02 13:49:48.767623
97	f16f3f46-50ab-4704-b81d-ae5b08ff44fc	029475c7-7e9f-4754-a3bb-94b646540c86	application/octet-stream	912682	\N		2026-03-02 13:50:45.294409
98	ebfa18d7-558d-4697-9ac4-b8c2bbc05840	0044ef87-9040-41f1-bcb9-103a412da315	application/octet-stream	903938	\N		2026-03-02 13:51:37.632831
99	886adf95-be41-44b4-89f2-850086098e62	c64d6629-a3f9-4188-be08-7cccfced1e6e	application/octet-stream	886748	\N		2026-03-02 13:52:33.632254
100	18ec6e19-19ac-4be4-b52b-b9e4694a4b47	3c299702-83a4-42ae-b2a3-2fcc5d0d933d	application/octet-stream	1000672	\N		2026-03-02 13:53:26.333719
101	4ae0cbb4-e5df-455e-a51f-03556fd89d40	230c89f3-b331-4e6a-b635-c14ed3e9a5fe	application/octet-stream	521356	\N		2026-03-02 13:54:16.065363
103	98ff7de3-e4c5-4b72-9e8d-144012f79d19	b3bb82ef-c7a2-4099-b95a-e2b344127a00	application/octet-stream	1030930	\N		2026-03-02 13:56:08.556821
104	c30e0a75-9f2c-465b-b5bd-fd24bc35774d	69c46641-1224-4050-b5bc-48c2e20a3577	application/octet-stream	474833	\N		2026-03-02 13:56:55.5883
105	194d0deb-8e02-4d1a-ac94-4cc7d63f776a	ccc0fe45-85c1-4b0a-b796-46ce6e33eb98	application/octet-stream	636730	\N		2026-03-02 13:57:39.380218
106	a30851af-3f68-42cf-aba0-993cfc1f3c59	1813c8da-6374-45b9-a191-0c73faf33ab4	application/octet-stream	1004611	\N		2026-03-02 13:59:22.966746
107	bd0f4128-989a-48d4-a9a8-096a0400ec1f	b35af6f0-e0fe-47eb-b731-6b20d683a8a8	application/octet-stream	1108283	\N		2026-03-02 14:00:47.447669
108	bca87b3a-bcd8-4697-bc3f-3c9ee0af45a1	968ab3bb-24b7-430b-9d5b-39663015a317	application/octet-stream	603386	\N		2026-03-02 14:01:41.198798
\.


--
-- Data for Name: entity_asset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_asset (id, entity_type, entity_id, asset_id, role, "position") FROM stdin;
32	artist	4	55	primary	\N
46	artist	56	71	primary	\N
50	artist	60	75	primary	\N
52	artist	1	91	primary	\N
53	artist	5	92	primary	\N
54	artist	7	93	primary	\N
55	artist	9	94	primary	\N
56	artist	10	95	primary	\N
57	artist	47	96	primary	\N
58	artist	48	97	primary	\N
59	artist	49	98	primary	\N
60	artist	50	99	primary	\N
61	artist	51	100	primary	\N
62	artist	52	101	primary	\N
64	artist	54	103	primary	\N
65	artist	53	104	primary	\N
66	artist	55	105	primary	\N
67	artist	57	106	primary	\N
68	artist	58	107	primary	\N
69	artist	59	108	primary	\N
70	artist	47	109	presskit	\N
\.


--
-- Data for Name: entity_link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_link (id, entity_type, entity_id, link_id) FROM stdin;
3	artist	1	3
6	artist	1	6
7	artist	1	7
8	artist	5	8
9	artist	5	9
10	artist	47	10
11	artist	47	11
12	artist	47	12
13	artist	7	13
14	artist	7	14
15	artist	7	15
16	artist	48	16
17	artist	48	17
18	artist	48	18
19	artist	49	19
20	artist	49	20
21	artist	49	21
22	artist	50	22
23	artist	50	23
24	artist	50	24
25	artist	51	25
26	artist	51	26
27	artist	51	27
28	artist	52	28
29	artist	52	29
30	artist	52	30
31	artist	59	31
32	artist	59	32
33	artist	59	33
34	artist	58	34
35	artist	58	35
36	artist	58	36
37	artist	57	37
38	artist	57	38
39	artist	57	39
40	artist	56	40
41	artist	56	41
42	artist	55	42
43	artist	55	43
44	artist	9	44
45	artist	9	45
46	artist	9	46
47	artist	10	47
48	artist	10	48
49	artist	53	49
50	artist	53	50
51	artist	54	51
52	artist	54	52
60	artist	47	61
62	artist	47	63
63	artist	47	64
64	artist	10	65
65	artist	10	66
67	artist	54	68
68	artist	54	69
70	artist	47	71
71	artist	47	72
72	artist	47	73
74	artist	47	75
\.


--
-- Data for Name: entity_palette; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entity_palette (id, entity_type, entity_id, primary_color, secondary_color, text_color, title_color, link_color, price_color) FROM stdin;
1	artist	8	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
3	event	5	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
2	event	4	#fff001	#f0f0f0	#f0f0f0	#f0f0f0	#f0f0f0	#f0f0f0
4	artist	9	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
5	artist	10	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
6	artist	11	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
39	artist	44	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
40	artist	45	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
41	artist	46	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
42	artist	47	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
43	artist	48	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
44	artist	49	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
45	artist	50	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
46	artist	51	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
47	artist	52	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
48	artist	53	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
49	artist	54	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
50	artist	55	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
51	artist	56	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
52	artist	57	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
53	artist	58	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
54	artist	59	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
55	artist	60	#000000	#ffffff	#ffffff	#ffffff	#1e90ff	#ff6600
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event (id, name, location, description, style, price, date, is_sold_out) FROM stdin;
1	Party 1	\N	\N	\N	\N	\N	f
2	Party 2	\N	\N	\N	\N	\N	f
4	Party 3	\N	\N	\N	\N	\N	f
5	Big Party	\N	\N	\N	\N	\N	f
\.


--
-- Data for Name: link; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.link (id, type, url, label) FROM stdin;
3	instagram	https://www.instagram.com/chaka_chaka_sound_system/	
6	facebook	https://www.facebook.com/soundtimex	
7	ra	https://ra.co/dj/chakachaka	
8	instagram	https://www.instagram.com/rootsivories/	
9	ra	https://fr.ra.co/dj/rootsivories	
10	instagram	https://www.instagram.com/sssela_music/	
11	soundcloud	https://soundcloud.com/mr-sela	
12	ra	https://ra.co/dj/sela-fr	
13	instagram	https://www.instagram.com/lenylouislabbe/	
14	soundcloud	https://soundcloud.com/blinkdisc	
15	bandcamp	https://blinkdisc.bandcamp.com/music	
16	instagram	https://www.instagram.com/baptiste.coppel/	
17	soundcloud	https://soundcloud.com/user-286069714	
18	ra	https://ra.co/dj/baptistecoppel	
19	instagram	https://www.instagram.com/gogogadgeto.music/	
20	soundcloud	https://soundcloud.com/gogogadgetomusic	
21	ra	https://ra.co/dj/gogogadgeto	
22	instagram	https://www.instagram.com/___loctop___/	
23	youtube	https://soundcloud.com/barda_lyon/bardacast-005-loctop	
24	soundcloud	https://soundcloud.com/loctop	
25	instagram	https://www.instagram.com/maxence.lyonnet/	
26	soundcloud	https://soundcloud.com/maxence-lionnet-752310919	
27	ra	https://ra.co/dj/zegaz	
28	instagram	https://www.instagram.com/pastel____/	
29	soundcloud	https://soundcloud.com/ppaasstteell	
30	ra	https://ra.co/dj/pastel	
31	instagram	https://www.instagram.com/subtroopers_/	
32	facebook	https://www.facebook.com/Subtroopers/?locale=fr_FR	
33	soundcloud	https://soundcloud.com/subtroopers	
34	instagram	https://www.instagram.com/mag.d__highbudub/?hl=en	
35	soundcloud	https://soundcloud.com/high-budub-sound	
36	bandcamp	https://highbudubsound.bandcamp.com/music	
37	instagram	https://www.instagram.com/leruja_/	
38	facebook	https://www.facebook.com/LerujaOfficial	
39	youtube	https://www.youtube.com/channel/UCwBTlNz48I5Twlpa1JkpoXQ	
40	instagram	https://www.instagram.com/radikal_vibration/?hl=en	
41	facebook	https://www.facebook.com/Radikalvibration#	
42	instagram	https://www.instagram.com/soulvibessound	
43	facebook	https://www.facebook.com/soulvibessound/	
44	instagram	https://www.instagram.com/ima_rrrrrr/	
45	facebook	https://www.facebook.com/lola.burquier.1/	
46	soundcloud	https://soundcloud.com/lola-burquier	
47	facebook	https://www.facebook.com/koffi613/	
48	soundcloud	https://soundcloud.com/user-550037144/tracks	
49	instagram	https://www.instagram.com/nins_ohm_sound/?hl=en	
50	soundcloud	https://soundcloud.com/nins-ohm-sound	
51	instagram	https://www.instagram.com/dubfact_/?hl=en	
52	facebook	https://www.facebook.com/Dubfact/	
64	release	<iframe width="560" height="315" src="https://www.youtube.com/embed/NwYID7cfyeM?si=antEjgA8KbVNrBYP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>	
61	live	<iframe width="560" height="315" src="https://www.youtube.com/embed/iviLmgcDSfc?si=4Np7_37JHGNC-2GH" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>	
63	release	<iframe style="border: 0; width: 350px; height: 470px;" src="https://bandcamp.com/EmbeddedPlayer/album=2547029194/size=large/bgcol=333333/linkcol=0f91ff/tracklist=false/track=351022035/transparent=true/" seamless><a href="https://drmrecords.bandcamp.com/album/sauvez-wheelie-vol-02">Sauvez Wheelie Vol.02 by Sela</a></iframe>	
65	live	<iframe width="100%" height="300" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/soundcloud%253Atracks%253A2057893252&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true&visual=true"></iframe><div style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;"><a href="https://soundcloud.com/yarrecords" title="YA.R Records" target="_blank" style="color: #cccccc; text-decoration: none;">YA.R Records</a> · <a href="https://soundcloud.com/yarrecords/yar-dj-set-le-gram2" title="PODCAST YA.R 021 - KOFFI" target="_blank" style="color: #cccccc; text-decoration: none;">PODCAST YA.R 021 - KOFFI</a></div>	
66	live	<iframe style="border: 0; width: 350px; height: 470px;" src="https://bandcamp.com/EmbeddedPlayer/album=3553344418/size=large/bgcol=ffffff/linkcol=0687f5/tracklist=false/transparent=true/" seamless><a href="https://legramvg.bandcamp.com/album/lgvg003">LGVG003 by Koffi</a></iframe>	
68	live	<iframe width="560" height="315" src="https://www.youtube.com/embed/V50w2F_mYUw?si=dMZVBMKQJVxH7n6P" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>	
69	release	<iframe style="border: 0; width: 350px; height: 470px;" src="https://bandcamp.com/EmbeddedPlayer/album=2031167349/size=large/bgcol=ffffff/linkcol=0687f5/tracklist=false/transparent=true/" seamless><a href="https://dubfact.bandcamp.com/album/louder-than-louder">Louder Than Louder by DUBFACT</a></iframe>	
71	release	<iframe width="560" height="315" src="https://www.youtube.com/embed/OCY0cMe3zMA?si=pDafD2SAlX_AZrkB" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>	
72	release	<iframe width="560" height="315" src="https://www.youtube.com/embed/WGx9CEx1HTw?si=k4mXqbFwJo4EzbHB" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>	
73	release	<iframe width="560" height="315" src="https://www.youtube.com/embed/UtVY8PX8yHU?si=NGy_a-xKzdxhqbC-" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>	
75	live	<iframe width="100%" height="300" scrolling="no" frameborder="no" allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/soundcloud%253Atracks%253A1148229568&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true&visual=true"></iframe><div style="font-size: 10px; color: #cccccc;line-break: anywhere;word-break: normal;overflow: hidden;white-space: nowrap;text-overflow: ellipsis; font-family: Interstate,Lucida Grande,Lucida Sans Unicode,Lucida Sans,Garuda,Verdana,Tahoma,sans-serif;font-weight: 100;"><a href="https://soundcloud.com/atomasso" title="ATOM" target="_blank" style="color: #cccccc; text-decoration: none;">ATOM</a> · <a href="https://soundcloud.com/atomasso/sela-69-archives" title="SELA ✺ 69 ARCHIVES" target="_blank" style="color: #cccccc; text-decoration: none;">SELA ✺ 69 ARCHIVES</a></div>	
\.


--
-- Data for Name: roster; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roster (id, name, year, style, description) FROM stdin;
\.


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 33, true);


--
-- Name: artist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artist_id_seq', 60, true);


--
-- Name: asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_id_seq', 109, true);


--
-- Name: entity_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entity_asset_id_seq', 70, true);


--
-- Name: entity_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entity_link_id_seq', 74, true);


--
-- Name: entity_palette_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.entity_palette_id_seq', 55, true);


--
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_id_seq', 5, true);


--
-- Name: link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.link_id_seq', 75, true);


--
-- Name: roster_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roster_id_seq', 1, false);


--
-- Name: admin admin_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_email_key UNIQUE (email);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: artist_event artist_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_event
    ADD CONSTRAINT artist_event_pkey PRIMARY KEY (artist_id, event_id);


--
-- Name: artist artist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (id);


--
-- Name: artist_roster artist_roster_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_roster
    ADD CONSTRAINT artist_roster_pkey PRIMARY KEY (artist_id, roster_id);


--
-- Name: asset asset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset
    ADD CONSTRAINT asset_pkey PRIMARY KEY (id);


--
-- Name: entity_asset entity_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_asset
    ADD CONSTRAINT entity_asset_pkey PRIMARY KEY (id);


--
-- Name: entity_link entity_link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_link
    ADD CONSTRAINT entity_link_pkey PRIMARY KEY (id);


--
-- Name: entity_palette entity_palette_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_palette
    ADD CONSTRAINT entity_palette_pkey PRIMARY KEY (id);


--
-- Name: event event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);


--
-- Name: link link_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.link
    ADD CONSTRAINT link_pkey PRIMARY KEY (id);


--
-- Name: roster roster_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roster
    ADD CONSTRAINT roster_pkey PRIMARY KEY (id);


--
-- Name: entity_palette uniq_entity_palette; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_palette
    ADD CONSTRAINT uniq_entity_palette UNIQUE (entity_type, entity_id);


--
-- Name: entity_asset_unique_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX entity_asset_unique_role ON public.entity_asset USING btree (entity_type, entity_id, role) WHERE (role = ANY (ARRAY['primary'::public.asset_role, 'secondary'::public.asset_role]));


--
-- Name: entity_asset_unique_single_roles; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX entity_asset_unique_single_roles ON public.entity_asset USING btree (entity_type, entity_id, role) WHERE (role <> 'gallery'::public.asset_role);


--
-- Name: uniq_background_asset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_background_asset ON public.entity_asset USING btree (entity_type, entity_id) WHERE (role = 'background'::public.asset_role);


--
-- Name: uniq_entity_link; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_entity_link ON public.entity_link USING btree (entity_type, entity_id, link_id);


--
-- Name: uniq_entity_link_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_entity_link_type ON public.entity_link USING btree (entity_type, entity_id, link_id);


--
-- Name: uniq_link_type_url; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_link_type_url ON public.link USING btree (type, url);


--
-- Name: uniq_primary_asset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_primary_asset ON public.entity_asset USING btree (entity_type, entity_id) WHERE (role = 'primary'::public.asset_role);


--
-- Name: uniq_secondary_asset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uniq_secondary_asset ON public.entity_asset USING btree (entity_type, entity_id) WHERE (role = 'secondary'::public.asset_role);


--
-- Name: artist_event artist_event_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_event
    ADD CONSTRAINT artist_event_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id) ON DELETE CASCADE;


--
-- Name: artist_event artist_event_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_event
    ADD CONSTRAINT artist_event_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.event(id) ON DELETE CASCADE;


--
-- Name: artist_roster artist_roster_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_roster
    ADD CONSTRAINT artist_roster_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(id) ON DELETE CASCADE;


--
-- Name: artist_roster artist_roster_roster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artist_roster
    ADD CONSTRAINT artist_roster_roster_id_fkey FOREIGN KEY (roster_id) REFERENCES public.roster(id) ON DELETE CASCADE;


--
-- Name: entity_asset entity_asset_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_asset
    ADD CONSTRAINT entity_asset_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES public.asset(id) ON DELETE CASCADE;


--
-- Name: entity_link entity_link_link_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entity_link
    ADD CONSTRAINT entity_link_link_id_fkey FOREIGN KEY (link_id) REFERENCES public.link(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

