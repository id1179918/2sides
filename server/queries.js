// ESM imports
import express from 'express';
import path from 'path';
import { Pool } from 'pg';
import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import fs from 'fs/promises';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import cookieParser from 'cookie-parser';

// Emulate __dirname in ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const SALT_ROUNDS = 12;

// Load environment variables
dotenv.config({
  override: true,
  path: path.join(__dirname, 'dev.env')
});

const STORAGE_ROOT = path.resolve(process.env.STORAGE_PATH);
const JWT_SECRET = path.resolve(process.env.JWT_SECRET);

const pool = new Pool({
    host: process.env.HOST,
    user: process.env.USER,
    database: process.env.DATABASE,
    password: process.env.PASSWORD,
    port: process.env.PORT,
    max: 2,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 2000,
    maxLifetimeSeconds: 60
});

const allowedTables = new Set(['artist', 'event']);

// UTILITY FUNCTION: UPADATE THE VALUE OF A GIVEN ELEMENT IN A GIVEN TABLE AND FIELD
function updateFieldFromTable(fieldName, fieldValue, tableName, elementId, response) {
    if (fieldName && fieldValue && tableName && elementId) {
        if (!allowedTables.has(tableName)) {
            throw new Error('Invalid table name');
        }

        const updateQuery = `
          UPDATE ${tableName}
          SET ${fieldName} = $1
          WHERE id = $2
        `;

        pool.query(
            updateQuery, [fieldValue, elementId],
            (error, results) => {
              if (error) {
                throw error;
              }
            }
        );
    } else {
        return response.status(500).send(`Must specify [fieldName, fieldValue, tableName]`);
    }
}


/* ADMIN */
// PG QUERY TO CREATE ADMIN ELEMENT
const createAdmin = async (request, response) => {
  const { email, password } = request.body;
  const hash = await bcrypt.hash(password, SALT_ROUNDS);

  await pool.query(
    `
    INSERT INTO admin (email, password_hash)
    VALUES ($1, $2)
    `,
    [email, hash],
    (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    }
  );
}

// PG QUERY TO LOGIN ADMIN
const loginAdmin = async (request, response) => {
  const { email, password } = request.body;

  const result = await pool.query(
    'SELECT * FROM admin WHERE email = $1 AND is_active = true',
    [email]
  );

  if (result.rowCount === 0) {
    return response.status(401).json([{ error: 'Invalid credentials' }]);
  }

  const admin = result.rows[0];

  const valid = await bcrypt.compare(password, admin.password_hash);
  if (!valid) {
    return response.status(401).json([{ error: 'Invalid credentials' }]);
  }

  const token = jwt.sign(
    {
      adminId: admin.id,
      email: admin.email,
    },
    JWT_SECRET,
    { expiresIn: '2h' }
  );

  await pool.query(
    'UPDATE admin SET last_login_at = now() WHERE id = $1',
    [admin.id]
  );

  response.cookie('admin_token', token, {
    httpOnly: true,
    secure: true,          // HTTPS only
    sameSite: 'none',    // CSRF protection
  }).json([{status: "success"}]);
}


/* ARTIST */

// PG QUERY TO CREATE ARTIST ELEMENT
//const createArtist = async (request, response) => {
//    const name = request.get('name');
//
//    if (!name) {
//        throw response.status(500).send(`Must specify name of artist to create`);
//    }
//
//    try {
//      pool.query('BEGIN');
//      pool.query('INSERT INTO artist (name) VALUES ($1) RETURNING *', [name], async (error, results) => {
//        if (error) {
//          throw error;
//        }
//
//        await pool.query(`
//          INSERT INTO entity_palette (
//            entity_type,
//            entity_id,
//            primary_color,
//            secondary_color,
//            text_color,
//            title_color,
//            link_color,
//            price_color
//          )
//          VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
//          `,
//          [
//            'artist',
//            results.rows[0].id,
//            '#000000', // primary
//            '#ffffff', // secondary
//            '#ffffff', // text
//            '#ffffff', // title
//            '#1e90ff', // link
//            '#ff6600'  // price
//          ]
//        );
//        await pool.query('COMMIT');
//        response.status(200).send([{status: "success"}]);
//      });
//    } catch (e) {
//      await pool.query('ROLLBACK');
//      console.error(e);
//      response.status(500).send([{status: "failed"}]);
//    }
//}
//
const createArtist = async (request, response) => {
  const name = request.get('name');
  const style = request.get('style');

  if (!name) {
      throw response.status(500).send(`Must specify name and style of artist to create`);
  }

  try {
    pool.query('BEGIN');
    pool.query('INSERT INTO artist (name, style) VALUES ($1, $2) RETURNING *', [name, style], async (error, results) => {
      if (error) {
        throw error;
      }

      await pool.query(`
        INSERT INTO entity_palette (
          entity_type,
          entity_id,
          primary_color,
          secondary_color,
          text_color,
          title_color,
          link_color,
          price_color
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
        `,
        [
          'artist',
          results.rows[0].id,
          '#000000', // primary
          '#ffffff', // secondary
          '#ffffff', // text
          '#ffffff', // title
          '#1e90ff', // link
          '#ff6600'  // price
        ]
      );
      await pool.query('COMMIT');
      response.status(200).send([{status: "success"}]);
    });
  } catch (e) {
    await pool.query('ROLLBACK');
    console.error(e);
    response.status(500).send([{status: "failed"}]);
  }
}


// PG QUERY TO GET ALL ARTIST ELEMENTS
const getAllArtist = (request, response) => {
    pool.query('SELECT * FROM artist ORDER BY id ASC', (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}

// PG QUERY TO GET ARTIST ELEMENT BY ID
const getArtistById = (request, response) => {
    const id = parseInt(request.get('id'));

    if (!id) {
        throw response.status(500).send(`Must specify ID of artist`);
    }

    pool.query('SELECT * FROM artist WHERE id = $1', [id], (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}

// PG QUERY TO GET ARTIST ELEMENT BY NAME
const getArtistByName = (request, response) => {
    const { name } = request.body;

    if (!name) {
        throw response.status(500).send(`Must specify name of artist`);
    }

    pool.query('SELECT * FROM artist WHERE name = $1', [name], (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}

// PG QUERY TO UPDATE ARTIST ELEMENT
const updateArtist = (request, response) => {
    const id = parseInt(request.body.id);
    const { name, location, style, description, label } = request.body;
    const position = request.body.position !== undefined ? parseInt(request.body.position) : undefined;

    console.log(position);

    if (!id) {
        throw response.status(500).send(`Must specify ID of artist`);
    }

    if (name) {
        try {
            updateFieldFromTable("name", name, "artist", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (location) {
        try {
            updateFieldFromTable("location", location, "artist", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (style) {
        try {
            updateFieldFromTable("style", style, "artist", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (description) {
        try {
            updateFieldFromTable("description", description, "artist", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (label) {
        try {
            updateFieldFromTable("label", label, "artist", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (position) {
        try {
            updateFieldFromTable("pos", position, "artist", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    return response.status(200).json([{status: "success"}]);
}

const deleteArtist = (request, response) => {
    const id = parseInt(request.body.id)

    if (!id) {
        throw response.status(500).send(`Must specify ID of artist`);
    }

    pool.query('DELETE FROM artist WHERE id = $1', [id], (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`Artist deleted`)
    })
}


/* EVENT */

// PG QUERY TO CREATE EVENT ELEMENT
const createEvent = async (request, response) => {
    const { name } = request.body;

    if (!name) {
        throw response.status(500).send(`Must specify name of event to create`);
    }

    try {
      pool.query('BEGIN');
      pool.query('INSERT INTO event (name) VALUES ($1) RETURNING *', [name], async (error, results) => {
        if (error) {
          throw error;
        }

        await pool.query(`
          INSERT INTO entity_palette (
            entity_type,
            entity_id,
            primary_color,
            secondary_color,
            text_color,
            title_color,
            link_color,
            price_color
          )
          VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
          `,
          [
            'event',
            results.rows[0].id,
            '#000000', // primary
            '#ffffff', // secondary
            '#ffffff', // text
            '#ffffff', // title
            '#1e90ff', // link
            '#ff6600'  // price
          ]
        );
        await pool.query('COMMIT');
        response.status(200).send(`EVENT added with ID: ${results.rows[0].id}`);
      });
    } catch (e) {
      await pool.query('ROLLBACK');
      console.error(e);
      response.status(500).send('Failed to create event');
    }
}

// PG QUERY TO GET ALL EVENT ELEMENTS
const getAllEvents = (request, response) => {
    pool.query('SELECT * FROM event ORDER BY id ASC', (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}

// PG QUERY TO GET EVENT ELEMENT BY ID
const getEventById = (request, response) => {
    const id = parseInt(request.body.id);

    if (!id) {
        throw response.status(500).send(`Must specify ID of event`);
    }

    pool.query('SELECT * FROM event WHERE id = $1', [id], (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}

// PG QUERY TO GET EVENT ELEMENT BY NAME
const getEventByName = (request, response) => {
    const { name } = request.body;

    if (!name) {
        throw response.status(500).send(`Must specify name of event`);
    }

    pool.query('SELECT * FROM event WHERE name = $1', [name], (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}

// PG QUERY TO UPDATE EVENT ELEMENT
const updateEvent = (request, response) => {
    const id = parseInt(request.body.id);
    const { name, location, description, style, price, date } = request.body;

    if (!id) {
        throw response.status(500).send(`Must specify ID of event`);
    }

    if (name) {
        try {
            updateFieldFromTable("name", name, "event", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (location) {
        try {
            updateFieldFromTable("location", location, "event", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (style) {
        try {
            updateFieldFromTable("style", style, "event", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (description) {
        try {
            updateFieldFromTable("description", description, "event", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (price) {
        try {
            updateFieldFromTable("price", price, "event", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (date) {
        try {
            updateFieldFromTable("date", date, "event", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    return response.status(200).send(`Successfully updated element with ID ${id}`);
}

// PG QUERY TO DELETE EVENT ELEMENT
const deleteEvent = (request, response) => {
    const id = parseInt(request.body.id)

    if (!id) {
        throw response.status(500).send(`Must specify ID of event`);
    }

    pool.query('DELETE FROM event WHERE id = $1', [id], (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`Event deleted`)
    })
}


/* ROSTER */

// PG QUERY TO CREATE ROSTER ELEMENT
const createRoster = (request, response) => {
    const { name } = request.body;

    pool.query('INSERT INTO roster (name) VALUES ($1) RETURNING *', [name], (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).send(`ROSTER added with ID: ${results.rows[0].id}`);
    });
}

// PG QUERY TO GET ALL ROSTER ELEMENTS
const getAllRoster = (request, response) => {
    pool.query('SELECT * FROM roster ORDER BY id ASC', (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}

// PG QUERY TO GET ROSTER ELEMENT BY ID
const getRosterById = (request, response) => {
    const id = parseInt(request.body.id);

    if (!id) {
        throw response.status(500).send(`Must specify ID of roster`);
    }

    pool.query('SELECT * FROM roster WHERE id = $1', [id], (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}


// PG QUERY TO UPDATE ROSTER ELEMENT
const updateRoster = (request, response) => {
    const id = parseInt(request.body.id);
    const { name, year, style, description } = request.body;

    if (!id) {
        throw response.status(500).send(`Must specify ID of event`);
    }

    if (name) {
        try {
            updateFieldFromTable("name", name, "roster", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (year) {
        try {
            updateFieldFromTable("year", year, "roster", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (style) {
        try {
            updateFieldFromTable("style", style, "roster", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    if (description) {
        try {
            updateFieldFromTable("description", description, "roster", id, response);
        } catch (e) {
            console.error(e);
        }
    }
    return response.status(200).send(`Successfully updated ROSTER with ID ${id}`);
}

// PG QUERY TO DELETE ROSTER ELEMENT
const deleteRoster = (request, response) => {
    const id = parseInt(request.body.id)

    if (!id) {
        throw response.status(500).send(`Must specify ID of roster`);
    }

    pool.query('DELETE FROM roster WHERE id = $1', [id], (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`Roster deleted`)
    })
}


/* ARTIST_EVENT */
// PG QUERY TO ADD ARTIST TO EVENT
const addArtistToEvent = (request, response) => {
    const { artistId, eventId } = request.body;

    if (!artistId || !eventId) {
        throw response.status(500).send(`Must specify ID of artist and event`);
    }

    pool.query(
      `INSERT INTO artist_event (artist_id, event_id)
       VALUES ($1, $2)
       ON CONFLICT DO NOTHING`,
      [artistId, eventId], (error, results) => {
        if (error) {
            throw error;
        }
        response.status(200).send(`ARTIST ${artistId} added to EVENT ${eventId}`);
      }
    );
}

// PG QUERY GET ARTIST FROM GIVEN EVENT
const getArtistOfEvent = (request, response) => {
    const { eventId } = request.body;

    if (!eventId) {
        throw response.status(500).send(`Must specify ID of event`);
    }

    pool.query(
        `SELECT a.*
        FROM artist_event ae
        JOIN artist a ON a.id = ae.artist_id
        WHERE ae.event_id = $1
        ORDER BY a.name;`,
        [eventId], (error, results) => {
            if (error) {
                throw error;
            }
            response.status(200).json(results.rows);
        }
    );
}

// PG QUERY GET EVENT FROM GIVEN ARTIST
const getEventOfArtist = (request, response) => {
    const { artistId } = request.body;

    if (!artistId) {
        throw response.status(500).send(`Must specify ID of artist`);
    }

    pool.query(
        `SELECT e.*
        FROM artist_event ae
        JOIN event e ON e.id = ae.event_id
        WHERE ae.artist_id = $1
        ORDER BY e.date;`,
        [artistId], (error, results) => {
            if (error) {
                throw error;
            }
            response.status(200).json(results.rows);
        }
    );
}

// PG QUERY DELETE ARTIST-EVENT PAIR
const deleteArtistEventPair = (request, response) => {
    const { artistId, eventId } = request.body;

    if (!artistId || !eventId) {
        throw response.status(500).send(`Must specify ID of artist and event`);
    }

    pool.query('DELETE FROM artist_event WHERE artist_id = $1 AND event_id = $2', [artistId, eventId], (error, results) => {
      if (error) {
        throw error
      }
      response.status(200).send(`Artist-Event pair deleted`)
    })
}


/* ARTIST_ROSTER */

// PG QUERY TO ADD ARTIST TO ROSTER
const addArtistToRoster = (request, response) => {
    const { artistId, rosterId } = request.body;

    if (!artistId || !rosterId) {
        throw response.status(500).send(`Must specify ID of artist and roster`);
    }

    pool.query(
      `INSERT INTO artist_roster (artist_id, roster_id)
       VALUES ($1, $2)
       ON CONFLICT DO NOTHING`,
      [artistId, rosterId], (error, results) => {
        if (error) {
            throw error;
        }
        response.status(200).send(`ARTIST ${artistId} added to ROSTER ${rosterId}`);
      }
    );
}

// PG QUERY GET ARTISTS FROM GIVEN ROSTER
const getArtistOfRoster = (request, response) => {
    const { rosterId } = request.body;

    if (!rosterId) {
        throw response.status(500).send(`Must specify ID of roster`);
    }

    pool.query(
        `SELECT a.*
        FROM artist_roster ar
        JOIN artist a ON a.id = ar.artist_id
        WHERE ar.roster_id = $1
        ORDER BY a.name;`,
        [eventId], (error, results) => {
            if (error) {
                throw error;
            }
            response.status(200).json(results.rows);
        }
    );
}

// PG QUERY GET ROSTERS FROM GIVEN ARTIST
const getRosterOfArtist = (request, response) => {
    const { artistId } = request.body;

    if (!artistId) {
        throw response.status(500).send(`Must specify ID of artist`);
    }

    pool.query(
        `SELECT r.*
        FROM artist_roster ar
        JOIN roster r ON r.id = ar.roster_id
        WHERE ar.artist_id = $1;`,
        [artistId], (error, results) => {
            if (error) {
                throw error;
            }
            response.status(200).json(results.rows);
        }
    );
}

// PG QUERY DELETE ARTIST-ROSTER PAIR
const deleteArtistRosterPair = (request, response) => {
    const { artistId, rosterId } = request.body;

    if (!artistId || !rosterId) {
        throw response.status(500).send(`Must specify ID of artist and roster`);
    }

    pool.query('DELETE FROM artist_roster WHERE artist_id = $1 AND roster_id = $2', [artistId, rosterId], (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).send(`Artist-Roster pair deleted`);
    })
}


/* ASSET */

// PG QUERY TO CREATE ASSET
const createAsset = (request, response) => {
    const file = request.file;

    if (!file) return response.status(400).send('No file uploaded');

    pool.query(`
      INSERT INTO asset
        (original_name, storage_key, mime_type, size_bytes, extension)
      VALUES ($1, $2, $3, $4, $5)
      RETURNING id`,
      [
        file.originalname,
        file.filename,
        file.mimetype,
        file.size,
        path.extname(file.originalname)
      ], (error, results) => {
        if (error) {
          throw error;
        }
        response.status(201).json([{id: results.rows[0].id}]);
    });

}

// PG QUERY TO GET ASSET
const getAssetById = (request, response) => {
    const id = String(request.params.id);

    pool.query(`
      SELECT original_name, storage_key, mime_type
      FROM asset
      WHERE id = $1`, [id], (error, results) => {
        if (error) {
          throw error;
        }
        if (!results.rows.length) return response.sendStatus(404);

        const file = results.rows[0];
        const fullPath = path.join(STORAGE_ROOT, file.storage_key);

        response.setHeader(
          'Content-Disposition',
          `attachment; filename="${file.original_name}"`,
        );
        response.setHeader('Access-Control-Allow-Origin', '*');
        response.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');

        response.type(file.mime_type);
        response.sendFile(fullPath);
    });
}

// PG QUERY TO GET ASSET
const getAssetByIdForDownload = (request, response) => {
    const id = String(request.params.id);
    const artistName = String(request.query.artistName);

    pool.query(`
      SELECT original_name, storage_key, mime_type
      FROM asset
      WHERE id = $1`, [id], (error, results) => {
        if (error) {
          throw error;
        }
        if (!results.rows.length) return response.sendStatus(404);

        const file = results.rows[0];
        const fullPath = path.join(STORAGE_ROOT, file.storage_key);

        response.setHeader('Access-Control-Allow-Origin', '*');
        response.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');

        response.type(file.mime_type);
        response.sendFile(fullPath);
    });
}

// PG QUERY TO GET ALL ASSETS
const getAllAsset = (request, response) => {
    pool.query('SELECT * FROM asset ORDER BY id ASC', (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    });
}

// PG QUERY DELETE ASSET
const deleteAsset = (request, response) => {
    const { assetId } = request.body;

    if (!assetId) {
        throw response.status(500).send(`Must specify ID of asset`);
    }

    try {
        pool.query(`
          SELECT storage_key
          FROM asset
          WHERE id = $1
          FOR UPDATE`,
          [assetId], async (error, results) => {
            if (error) {
              throw error
            }
            if (!results.rows.length) {
              pool.query('ROLLBACK');
               return response.status(404).send('Rows have no length');
            }
            const storageKey = results.rows[0].storage_key;
            const filePath = path.join(STORAGE_ROOT, storageKey);
            pool.query(
              `DELETE FROM asset WHERE id = $1`,
              [assetId]
             );
            try {
              await fs.unlink(filePath);
            } catch (e) {
              pool.query('ROLLBACK');
              console.error('File deletion failed:', e);
              return response.status(500).send('Failed to delete file from disk');
            }
            pool.query('COMMIT');
            response.status(200).send([{status: "success"}]);
          }
        );
    } catch (e) {
     pool.query('ROLLBACK');
      console.error(e);
      response.status(500).send('Failed deletion process');
    }
}


/* ENTITY ASSET */

// PG QUERY TO ASSIGN ASSET ENTITY ROLE
//  (ADD PRIMARY, SECONDARY OR GALLERY ROLE
//  TO AN ASSET TO ANY ENTITY, THAT IS FOR NOW
//  ARTIST, EVENT, ROSTER)
const assignAssetEntityRole = (request, response) => {
    const { entityType, entityId, assetId, role } = request.body;

    if (!entityType || !entityId || !assetId || !role) {
        throw response.status(500).send(`Must specify entityType, entityId, assetId, role`);
    }

    pool.query(`
        INSERT INTO entity_asset (entity_type, entity_id, asset_id, role)
        VALUES ($1, $2, $3, $4)`,
      [
        entityType, entityId, assetId, role
      ], (error, results) => {
        if (error) {
          throw error;
        }
        response.status(201).send([{status: "success"}]);
    });
}

// PG QUERY UPDATE ASSET
const upsertAssetForEntity = async (request, response) => {
  const { entityType, entityId, role } = request.body;

  if (!linkType || !entityType || !entityId) {
    return response.status(400).json({
      error: 'Must specify entityType, entityId, role',
    });
  }

  try {
    await pool.query(
      `
      WITH upsert_asset AS (
        INSERT INTO asset
        (entity_type, entity_id, role)
        VALUES ($1, $2, $3)
        RETURNING id
      )
      INSERT INTO entity_asset (entity_type, entity_id, asset_id)
      SELECT $4, $5, id
      FROM upsert_asset
      ON CONFLICT DO NOTHING;
      `,
      [entityType, entityId, role]
    );

    response.status(200).json([{
      status: 'success',
      message: `Asset ${linkType} upserted for ${entityType} ${entityId}`,
    }]);
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: 'Failed to upsert asset' });
  }
};

// PG QUERY GET ALL FILES OF ENTITY
const getAllFilesOfEntity = (request, response) => {
    const entityType = request.get('entityType');
    const entityId = request.get('entityId');

    if (!entityType || !entityId) {
        throw response.status(500).send(`Must specify entityType, entityId`);
    }

    pool.query(
      `
      SELECT
        ea.role            AS "role",

        a.id,
        a.original_name    AS "original_name",
        a.storage_key      AS "storage_key",
        a.mime_type        AS "mime_type",
        a.size_bytes       AS "size_bytes",
        a.checksum         AS "check_sum",
        a.extension        AS "file_extension",
        a.created_at       AS "created_at"
      FROM entity_asset ea
      JOIN asset a
        ON a.id = ea.asset_id
      WHERE ea.entity_type = $1
        AND ea.entity_id   = $2
      ORDER BY
        ea.role,
        ea.position;
      `,
      [entityType, entityId],
      (error, results) => {
        if (error) {
          throw error;
        }
        response.status(200).json(results.rows);
      }
    );
}


/* LINK */
// PG QUERY CHANGE LINK URL

// PG QUERY CHANGE LINK LABEL


/* ENTITY LINK */
// PG QUERY ADD LINK
const addLinkAndAssignToEntity = (request, response) => {
  const { linkType, url, label, entityType, entityId } = request.body;

  if (!linkType || !url || !entityType || !entityId) {
    throw response.status(500).send(`Must specify linkType, url, entityType, entityId`);
  }

  pool.query(`
    WITH new_link AS (
      INSERT INTO link (type, url, label)
      VALUES ($1, $2, $3)
      RETURNING id
    )
    INSERT INTO entity_link (entity_type, entity_id, link_id)
    SELECT $4, $5, id
    FROM new_link;`,
    [ linkType, url, label, entityType, entityId ],
    (error, results) => {
      if (error) {
        throw error;
      }
      response.status(201).send(`Successfully added link to ${entityType} id:${entityId}`);
  });
}

// PG QUERY UPDATE LINK
const upsertLinkForEntity = async (request, response) => {
  const { linkType, url, label, entityType, entityId } = request.body;

  if (!linkType || !url || !entityType || !entityId) {
    return response.status(400).json({
      error: 'Must specify linkType, url, entityType, entityId',
    });
  }

  try {
    await pool.query(
      `
      WITH upsert_link AS (
        INSERT INTO link (type, url, label)
        VALUES ($1, $2, $3)
        ON CONFLICT (type, url)
        DO UPDATE SET
          label = EXCLUDED.label
        RETURNING id
      )
      INSERT INTO entity_link (entity_type, entity_id, link_id)
      SELECT $4, $5, id
      FROM upsert_link
      ON CONFLICT DO NOTHING;
      `,
      [linkType, url, label, entityType, entityId]
    );

    response.status(200).json([{
      status: 'success',
      message: `Link ${linkType} upserted for ${entityType} ${entityId}`,
    }]);
  } catch (error) {
    console.error(error);
    response.status(500).json({ error: 'Failed to upsert link' });
  }
};


// PG QUERY GET ALL ENTITY LINKS
const getAllLinksOfEntity = (request, response) => {
  const entityType = request.get('entityType');
  const entityId = request.get('entityId');

  if (!entityType || !entityId) {
      throw response.status(500).send(`Must specify entityType, entityId`);
  }

  pool.query(
    `
    SELECT
      l.id,
      l.type,
      l.url,
      l.label
    FROM entity_link el
    JOIN link l
      ON l.id = el.link_id
    WHERE el.entity_type = $1
      AND el.entity_id   = $2
    ORDER BY l.type, l.id;
    `,
    [entityType, entityId],
    (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    }
  );
}

// PG QUERY DELETE LINK
const deleteLink = (request, response) => {
  const { linkId } = request.body;

  if (!linkId) {
      throw response.status(500).send([{ status: 'failed' }]);
  }
  pool.query(
    `
    WITH deleted_link AS (
      DELETE FROM entity_link
      WHERE link_id = $1
    )
    DELETE FROM link
    WHERE id = $1;
    `,
    [linkId],
    (error) => {
      if (error) throw error;
      response.status(200).json([{ status: 'success' }]);
    }
  );
}


/* LINK TYPE */
// PG QUERY GET ALL TYPES OF LINK ENUM
const getLinkTypes = (request, response) => {
    pool.query(`SELECT unnest(enum_range(NULL::link_type)) AS link_type;`,
      (error, results) => {
        if (error) {
          throw error;
        }
        response.status(201).json(results.rows.map(r => r.link_type));
    });
}


/* ENTITY COLOR PALETTE */

// PG QUERY GET ENTITY COLOR PALETTE
const getEntityColorPalette = (request, response) => {
  const { entityType, entityId } = request.body;

  pool.query(`
    SELECT *
    FROM entity_palette
    WHERE entity_type = $1
      AND entity_id = $2;
    `, [ entityType, entityId ], (error, results) => {
      if (error) {
        throw error;
      }
      response.status(200).json(results.rows);
    }
  );
}

const updateEntityColorPalette = (request, response) => {
  const {
    entityType,
    entityId,
    primaryColor,
    secondaryColor,
    textColor,
    titleColor,
    linkColor,
    priceColor
  } = request.body;

  pool.query(`
    UPDATE entity_palette
    SET
      primary_color = CASE
      WHEN NULLIF(trim($3::text), '') IS NULL THEN primary_color
      ELSE $3::hex_color
      END,
      secondary_color = CASE
        WHEN NULLIF(trim($4::text), '') IS NULL THEN secondary_color
        ELSE $4::hex_color
      END,
      text_color = CASE
        WHEN NULLIF(trim($5::text), '') IS NULL THEN text_color
        ELSE $5::hex_color
      END,
      title_color = CASE
        WHEN NULLIF(trim($6::text), '') IS NULL THEN title_color
        ELSE $6::hex_color
      END,
      link_color = CASE
        WHEN NULLIF(trim($7::text), '') IS NULL THEN link_color
        ELSE $7::hex_color
      END,
      price_color = CASE
        WHEN NULLIF(trim($8::text), '') IS NULL THEN price_color
        ELSE $8::hex_color
      END
    WHERE entity_type = $1
      AND entity_id   = $2
    RETURNING *;
    `,
    [
      entityType,
      entityId,
      primaryColor,
      secondaryColor,
      textColor,
      titleColor,
      linkColor,
      priceColor
    ], (error, results) => {
      if (error) {
        throw error;
      }
      if (!results.rows.length) {
        return response.status(404).send('Palette not found');
      }
      response.json(results.rows[0]);
    }
  );
}


export default {
  createAdmin,
  loginAdmin,
  createArtist,
  getAllArtist,
  getArtistById,
  getArtistByName,
  updateArtist,
  deleteArtist,
  createEvent,
  getAllEvents,
  getEventById,
  getEventByName,
  updateEvent,
  deleteEvent,
  addArtistToEvent,
  getArtistOfEvent,
  getEventOfArtist,
  deleteArtistEventPair,
  createRoster,
  getAllRoster,
  getRosterById,
  updateRoster,
  deleteRoster,
  addArtistToRoster,
  getArtistOfRoster,
  getRosterOfArtist,
  deleteArtistRosterPair,
  createAsset,
  getAssetById,
  getAssetByIdForDownload,
  getAllAsset,
  deleteAsset,
  assignAssetEntityRole,
  upsertAssetForEntity,
  getAllFilesOfEntity,
  addLinkAndAssignToEntity,
  upsertLinkForEntity,
  getAllLinksOfEntity,
  deleteLink,
  getLinkTypes,
  getEntityColorPalette,
  updateEntityColorPalette,
}
