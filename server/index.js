// ESM imports
import path from 'path';
import express from 'express';
import bodyParser from 'body-parser';
import axios from 'axios';
import cors from 'cors';
import multer from 'multer';
import { v4 as uuidv4 } from 'uuid'; // ES Module syntax for uuid
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import jwt from 'jsonwebtoken';
import cookieParser from 'cookie-parser';
import Mailjet from 'node-mailjet';

// Convert __dirname for ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables
dotenv.config({
  override: true,
  path: path.join(__dirname, 'dev.env')
});

// Import local modules (ESM)
import queries from './queries.js';

const mailjet_app = new Mailjet({
  apiKey: process.env.MJ_APIKEY_PUBLIC,
  apiSecret: process.env.MJ_APIKEY_PRIVATE
});

const mailjet = Mailjet.apiConnect(
  process.env.MJ_APIKEY_PUBLIC,
  process.env.MJ_APIKEY_PRIVATE,
  {
    config: {},
    options: {}
  }
);

const express_app = express()
const express_port = 3000

express_app.use(bodyParser.json())
express_app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

express_app.use(cors({
  origin: 'http://localhost:42939',
  credentials: true,
}));
express_app.use(cookieParser());


const STORAGE_ROOT = path.resolve(process.env.STORAGE_PATH);
const JWT_SECRET = path.resolve(process.env.JWT_SECRET);

/* ADMIN REQUIRE UTIL */
function requireAdmin(req, res, next) {
  const token = req.cookies.admin_token;

  if (!token) {
    console.log("no token");
    return res.status(401).json([{ status: 'Unauthorized' }]);
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.admin = decoded;
    console.log("shit works");
    next();
  } catch (err) {
    console.log("error token");
    return res.status(401).json([{ status: 'Invalid or expired token' }]);
  }
}

express_app.get('/admin/me', requireAdmin, (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: ADMIN TOKEN CHECK");
  res.status(200).json([{status: "success"}]);
});


/* MULTER STORAGE */
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, STORAGE_ROOT);
  },
  filename: (req, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `${uuidv4()}${ext}`);
  }
});

const upload = multer({
  storage,
  limits: { fileSize: 20 * 1024 * 1024 }, // 10 MB
});


/* MAILING */

express_app.post('/mail', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: SEND MAIL");
  try {
    const request = mailjet_app.post('send', { version: 'v3.1' }).request({
      Messages: [
        {
          From: {
            Email: '2sidesbooking@gmail.com',
            Name: 'Me',
          },
          To: [
            {
              Email: 'exyleprod@gmail.com',
              Name: 'You',
            },
          ],
          Subject: 'My first Mailjet Email!',
          TextPart: 'Greetings from Mailjet!',
          HTMLPart:
            '<h3>Dear passenger 1, welcome to <a href="https://www.mailjet.com/">Mailjet</a>!</h3><br />May the delivery force be with you!',
        },
      ],
    })
    request
      .then(result => {
        console.log(result.body)
        res.status(200).send([{status: "success"}]);
      })
      .catch(err => {
        console.log(err);
        res.status(500).send('Failed sending mail process');
      })
  } catch (e) {
    console.error(e);
    res.status(500).send('Failed sending mail process');
  }
});



/* ADMIN */

// EXPRESS ENDPOINT: CREATE ADMIN
express_app.post('/admin', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: CREATE ADMIN");
  try {
    queries.createAdmin(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: ADMIN LOGIN
express_app.post('/admin/login', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: LOGIN ADMIN");
  try {
    queries.loginAdmin(req, res);
  } catch (e) {
    console.log(e);
  }
});

express_app.post('/admin/logout', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: LOGOUT ADMIN");
  try {
    res.clearCookie('admin_token', {
      httpOnly: true,
      sameSite: 'strict',
      secure: true,
    }).json([{status: "success"}]);
  } catch (e) {
    console.log(e);
    res.status(401).json([{status: "failure"}]);
  }
});



/* ARTIST */

// EXPRESS ENDPOINT: CREATE ARTIST
express_app.post('/artist', requireAdmin, async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: CREATE ARTIST");
  try {
    queries.createArtist(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: UPDATE ARTIST
express_app.put('/artist', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: UPDATE ARTIST");
  try {
    queries.updateArtist(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ALL ARTIST
express_app.get('/artists', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ALL ARTIST");
  try {
    queries.getAllArtist(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ARTIST BY ID
express_app.get('/artist', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ARTIST BY ID");
  try {
    queries.getArtistById(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ARTIST BY NAME
express_app.get('/artist/name', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ALL ARTIST");
  try {
    queries.getArtistByName(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: DELETE ARTIST
express_app.delete('/artist', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: DELETE ARTIST");
  try {
    queries.deleteArtist(req, res);
  } catch (e) {
    console.error(e);
  }
});


/* EVENT */

// EXPRESS ENDPOINT: CREATE EVENT
express_app.post('/event', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: CREATE EVENT");
  try {
    queries.createEvent(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: UPDATE EVENT
express_app.put('/event', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: UPDATE EVENT");
  try {
    queries.updateEvent(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ALL EVENTS
express_app.get('/events', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ALL EVENTS");
  try {
    queries.getAllEvents(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET EVENT BY ID
express_app.get('/event', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET EVENT BY ID");
  try {
    queries.getEventById(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET EVENT BY NAME
express_app.get('/event/name', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET EVENT BY NAME");
  try {
    queries.getEventByName(req, res);
  } catch (e) {
    console.error(e);
  }
});

//  EXPRESS ENDPOINT: DELETE EVENT
express_app.delete('/event', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: DELETE EVENT");
  try {
    queries.deleteEvent(req, res);
  } catch (e) {
    console.error(e);
  }
});


/* ROSTER */

// EXPRESS ENDPOINT: CREATE ROSTER
express_app.post('/roster', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: CREATE ROSTER");
  try {
    queries.createEvent(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: UPDATE ROSTER
express_app.put('/roster', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: UPDATE ROSTER");
  try {
    queries.updateEvent(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ALL ROSTER
express_app.get('/rosters', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ALL ROSTER");
  try {
    queries.getAllEvents(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ROSTER BY ID
express_app.get('/roster', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ROSTER BY ID");
  try {
    queries.getEventById(req, res);
  } catch (e) {
    console.error(e);
  }
});

//  EXPRESS ENDPOINT: DELETE ROSTER
express_app.delete('/roster', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: DELETE ROSTER");
  try {
    queries.deleteEvent(req, res);
  } catch (e) {
    console.error(e);
  }
});


/* ARTIST_EVENT */

// EXPRESS ENDPOINT: ADD ARTIST TO EVENT
express_app.post('/artist/event', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: ADD ARTIST TO EVENT");
  try {
    queries.addArtistToEvent(req, res);
  } catch (e) {
    console.log(e);
  }
});

// EXPRESS ENDPOINT: GET EVENT ARTISTS
express_app.get('/event/artists', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET EVENT ARTISTS");
  try {
    queries.getArtistOfEvent(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ARTIST EVENTS
express_app.get('/artist/events', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ARTIST EVENTS");
  try {
    queries.getEventOfArtist(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: DELETE ARTIST-EVENT PAIR
express_app.delete('/artist/event', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: DELETE ARTIST-EVENT PAIR");
  try {
    queries.deleteArtistEventPair(req, res);
  } catch (e) {
    console.error(e);
  }
});


/* ARTIST_ROSTER */

// EXPRESS ENDPOINT: ADD ARTIST TO ROSTER
express_app.post('/roster/artist', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT:ADD ARTIST TO ROSTER");
  try {
    queries.addArtistToRoster(req, res);
  } catch (e) {
    console.log(e);
  }
});

// EXPRESS ENDPOINT: GET ROSTER ARTISTS
express_app.get('/roster/artists', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ROSTER ARTISTS");
  try {
    queries.getArtistOfRoster(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ARTIST ROSTERS
express_app.get('/artist/rosters', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ARTIST ROSTERS");
  try {
    queries.getRosterOfArtist(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: DELETE ARTIST-ROSTER PAIR
express_app.delete('/roster/artist', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: DELETE ARTIST-ROSTER PAIR");
  try {
    queries.deleteArtistRosterPair(req, res);
  } catch (e) {
    console.error(e);
  }
});



/* ASSET */

// EXPRESS ENDPOINT: CREATE ASSET
express_app.post('/asset', upload.single('file'), async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: CREATE ASSET");
  try {
    queries.createAsset(req, res);
  } catch (e) {
    console.error(e);
  }
});

express_app.put('/asset', upload.single('file'), async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: UPSERT ASSET");
  try {
    queries.upsertAssetForEntity(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ASSET BY ID
express_app.get('/asset/:id', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ASSET BY ID");
  try {
    queries.getAssetById(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ALL ASSETS
express_app.get('/assets', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ASSET BY ID");
  try {
    queries.getAllAsset(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: DELETE ASSET
express_app.delete('/asset', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: DELETE ASSET");
  try {
    queries.deleteAsset(req, res);
  } catch (e) {
    console.error(e);
  }
});


/* ENTITY ASSET */

// EXPRESS ENDPOINT: ASSIGN ASSET ENTITY ROLE
express_app.post('/entity/asset', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: ASSIGN ASSET ENTITY ROLE");
  try {
    queries.assignAssetEntityRole(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ALL ASSETS OF ENTITY
express_app.get('/entity/assets', async (req,res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ALL ASSETS OF ENTITY");
  try {
    queries.getAllFilesOfEntity(req, res);
  } catch (e) {
    console.error(e);
  }
});


/* ENTITY LINK */

// EXPRESS ENDPOINT: ADD LINK AND ASSIGN TO ENTITY
express_app.post('/entity/link', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: ADD LINK AND ASSIGN TO ENTITY");
  try {
    queries.addLinkAndAssignToEntity(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: ADD LINK AND ASSIGN TO ENTITY
express_app.put('/entity/link', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: UPSERT LINK AND ASSIGN TO ENTITY");
  try {
    queries.upsertLinkForEntity(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: GET ALL LINKS OF ENTITY
express_app.get('/entity/links', async (req,res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ALL LINKS OF ENTITY");
  try {
    queries.getAllLinksOfEntity(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: DELETE LINK OF ENTITY
express_app.delete('/entity/link', async (req,res) => {
  console.log("CALLED EXPRESS ENDPOINT: DELETE LINK OF ENTITY");
  try {
    queries.deleteLink(req, res);
  } catch (e) {
    console.error(e);
  }
});


/* LINK TYPES */

// EXPRESS ENDPOINT: GET ALL LINK TYPES
express_app.get('/link/types', async (req,res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET LINK TYPES");
  try {
    queries.getLinkTypes(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: ADD LINK TYPE
express_app.post('/link/type', async (req,res) => {
  console.log("CALLED EXPRESS ENDPOINT: ADD LINK TYPE");
  try {
    queries.addLinkType(req, res);
  } catch (e) {
    console.error(e);
  }
});


/* ENTITY PALETTE */

// EXPRESS ENDPOINT: GET ENTITY PALETTE
express_app.get('/entity/palette', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: GET ENTITY PALETTE");
  try {
    queries.getEntityColorPalette(req, res);
  } catch (e) {
    console.error(e);
  }
});

// EXPRESS ENDPOINT: UPDATE ENTITY PALETTE
express_app.put('/entity/palette', async (req, res) => {
  console.log("CALLED EXPRESS ENDPOINT: UPDATE ENTITY PALETTE");
  try {
    queries.updateEntityColorPalette(req, res);
  } catch (e) {
    console.error(e);
  }
});


// APP
express_app.listen(express_port, () => {
  console.log(`App running on port ${express_port}.`)
});