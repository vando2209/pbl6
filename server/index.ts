import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import productsRoute from './products';

const app = express();

// Restrictive CORS: allow configured origins only
const configuredOriginsRaw = process.env.CORS_ORIGINS || process.env.CLIENT_URL || '';
const configuredOrigins = configuredOriginsRaw
  .split(',')
  .map((s) => s.trim())
  .filter(Boolean);
const devDefaultOrigins = [
  'http://localhost:5173',
  'http://127.0.0.1:5173',
  'http://localhost:4173',
  'http://localhost:3000',
];

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin) return callback(null, true); // same-origin or curl/postman
      const allowlist = configuredOrigins.length ? configuredOrigins : devDefaultOrigins;
      if (allowlist.includes(origin)) return callback(null, true);
      return callback(new Error('Not allowed by CORS'), false);
    },
    credentials: true,
  })
);
app.use(express.json());

app.get('/api/health', (_req, res) => res.json({ ok: true }));
app.use('/api/products', productsRoute);

const port = Number(process.env.PORT || 4000);
app.listen(port, () => {
  console.log('API listening on http://localhost:' + port);
});
