import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import productsRoute from './products';

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/health', (_req, res) => res.json({ ok: true }));
app.use('/api/products', productsRoute);

const port = Number(process.env.PORT || 4000);
app.listen(port, () => {
  console.log('API listening on http://localhost:' + port);
});
