import { Router } from 'express';
import { pool } from './db';

const router = Router();

router.get('/', async (req, res) => {
  try {
    const page = Math.max(1, Number(req.query.page ?? 1));
    const pageSize = Math.min(100, Math.max(1, Number(req.query.pageSize ?? 20)));
    const offset = (page - 1) * pageSize;

    const where: string[] = [];
    const params: any[] = [];

    // Lọc category_id: chỉ chấp nhận men|women|kids
    const category = String(req.query.category_id ?? '').trim();
    if (category) {
      if (!['men', 'women', 'kids'].includes(category)) {
        return res.status(400).json({ error: 'category_id must be men|women|kids' });
      }
      where.push('category_id = ?');
      params.push(category);
    }

    // Lọc subcategory_id (số)
    if (req.query.subcategory_id !== undefined) {
      const subId = Number(req.query.subcategory_id);
      if (!Number.isFinite(subId)) return res.status(400).json({ error: 'subcategory_id must be a number' });
      where.push('subcategory_id = ?');
      params.push(subId);
    }

    // Lọc is_new / is_sale (0|1)
    if (req.query.is_new !== undefined) {
      where.push('is_new = ?');
      params.push(Number(req.query.is_new) ? 1 : 0);
    }
    if (req.query.is_sale !== undefined) {
      where.push('is_sale = ?');
      params.push(Number(req.query.is_sale) ? 1 : 0);
    }

    // Tìm kiếm tên / mô tả
    if (req.query.q) {
      const kw = `%${String(req.query.q).trim()}%`;
      where.push('(name LIKE ? OR description LIKE ?)');
      params.push(kw, kw);
    }

    // Khoảng giá
    if (req.query.min_price !== undefined) {
      const v = Number(req.query.min_price);
      if (!Number.isFinite(v)) return res.status(400).json({ error: 'min_price must be a number' });
      where.push('price >= ?');
      params.push(v);
    }
    if (req.query.max_price !== undefined) {
      const v = Number(req.query.max_price);
      if (!Number.isFinite(v)) return res.status(400).json({ error: 'max_price must be a number' });
      where.push('price <= ?');
      params.push(v);
    }

    // Sắp xếp
    let orderBy = 'id DESC';
    switch (String(req.query.sort || '')) {
      case 'newest':
        orderBy = 'created_at DESC, id DESC';
        break;
      case 'price_asc':
        orderBy = 'price ASC, id DESC';
        break;
      case 'price_desc':
        orderBy = 'price DESC, id DESC';
        break;
      case 'rating_desc':
        orderBy = 'rating DESC, review_count DESC, id DESC';
        break;
    }

    const whereSql = where.length ? `WHERE ${where.join(' AND ')}` : '';

    // Lưu ý: SQL_CALC_FOUND_ROWS đã deprecated trên MySQL 8; nếu muốn "đúng chuẩn" hơn, hãy chạy COUNT(*) riêng.
    const [rows] = await pool.query(
      `SELECT SQL_CALC_FOUND_ROWS *
       FROM products
       ${whereSql}
       ORDER BY ${orderBy}
       LIMIT ? OFFSET ?`,
      [...params, pageSize, offset]
    );
    const [totalRows]: any = await pool.query('SELECT FOUND_ROWS() AS total');

    res.json({
      data: rows,
      pagination: { page, pageSize, total: totalRows[0]?.total ?? 0 }
    });
  } catch (e: any) {
    res.status(500).json({ error: String(e?.message || e) });
  }
});

router.get('/:id', async (req, res) => {
  try {
    const [rows]: any = await pool.query('SELECT * FROM products WHERE id=?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Not found' });
    res.json(rows[0]);
  } catch (e: any) {
    res.status(500).json({ error: String(e?.message || e) });
  }
});

export default router;
