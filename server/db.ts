import 'dotenv/config';
import mysql from 'mysql2/promise';

if (!process.env.DATABASE_URL) {
  throw new Error('Missing DATABASE_URL in .env');
}

export const pool = mysql.createPool(process.env.DATABASE_URL);
