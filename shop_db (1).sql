-- shop_db_fixed.sql
-- Generated: 2025-10-24T16:28:54
-- Purpose: Fix data inconsistencies and tighten constraints for demo/staging use.

START TRANSACTION;

-- ===================================================================
-- A) SCHEMA TWEAKS (safe, non-destructive)
-- ===================================================================

-- Ensure review_count defaults to 0; keep rating nullable
-- (Will succeed if columns already exist.)
ALTER TABLE products
  MODIFY review_count INT NOT NULL DEFAULT 0,
  MODIFY rating DECIMAL(3,1) NULL;

-- ===================================================================
-- B) DATA FIXES
-- ===================================================================

-- B1) Coupons: turn off any coupon that is marked active but already expired
UPDATE coupons
SET is_active = 0
WHERE is_active = 1
  AND ends_at IS NOT NULL
  AND ends_at < NOW();

-- B2) Orders ↔ Payments
-- Insert captured payments for any PAID order that lacks a payment row.
INSERT INTO payments (order_id, provider, amount, status, txn_id, payload, created_at, updated_at)
SELECT o.id AS order_id,
       'cod' AS provider,
       o.grand_total AS amount,
       'captured' AS status,
       CONCAT('AUTO-', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), '-', o.id) AS txn_id,
       NULL AS payload,
       NOW() AS created_at,
       NOW() AS updated_at
FROM orders o
LEFT JOIN payments p ON p.order_id = o.id
WHERE o.status = 'paid'
  AND p.id IS NULL;

-- If there are any orders that already have an authorized/captured payment,
-- but their status is not 'paid', normalize them to 'paid' for consistency.
UPDATE orders o
SET o.status = 'paid'
WHERE o.status <> 'paid'
  AND EXISTS (
    SELECT 1 FROM payments p
    WHERE p.order_id = o.id
      AND p.status IN ('authorized','captured')
  );

-- B3) Recalculate products.rating and products.review_count from reviews
UPDATE products p
LEFT JOIN (
  SELECT product_id,
         COUNT(*) AS review_count,
         ROUND(AVG(rating), 1) AS avg_rating
  FROM reviews
  GROUP BY product_id
) r ON r.product_id = p.id
SET p.review_count = COALESCE(r.review_count, 0),
    p.rating       = CASE WHEN r.review_count > 0 THEN r.avg_rating ELSE NULL END;

-- ===================================================================
-- C) BUSINESS-SAFETY TRIGGERS
-- ===================================================================

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS trg_orders_before_update_paid;
DROP TRIGGER IF EXISTS trg_payments_after_insert;
DROP TRIGGER IF EXISTS trg_coupons_before_ins;
DROP TRIGGER IF EXISTS trg_coupons_before_upd;

DELIMITER $$

-- C1) Guard: prevent marking an order as 'paid' without a corresponding payment
CREATE TRIGGER trg_orders_before_update_paid
BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
  IF NEW.status = 'paid' AND OLD.status <> 'paid' THEN
    IF NOT EXISTS (
      SELECT 1 FROM payments
      WHERE order_id = NEW.id
        AND status IN ('authorized','captured')
      LIMIT 1
    ) THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order cannot be marked as paid without a corresponding payment';
    END IF;
  END IF;
END$$

-- C2) Convenience: when a captured/authorized payment is inserted, mark order as paid
CREATE TRIGGER trg_payments_after_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
  IF NEW.status IN ('authorized','captured') THEN
    UPDATE orders
    SET status = 'paid'
    WHERE id = NEW.order_id AND status <> 'paid';
  END IF;
END$$

-- C3) Guard: active coupon must not be expired (on INSERT)
CREATE TRIGGER trg_coupons_before_ins
BEFORE INSERT ON coupons
FOR EACH ROW
BEGIN
  IF NEW.is_active = 1 AND NEW.ends_at IS NOT NULL AND NEW.ends_at < NOW() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Active coupon must not be expired';
  END IF;
END$$

-- C4) Guard: active coupon must not be expired (on UPDATE)
CREATE TRIGGER trg_coupons_before_upd
BEFORE UPDATE ON coupons
FOR EACH ROW
BEGIN
  IF NEW.is_active = 1 AND NEW.ends_at IS NOT NULL AND NEW.ends_at < NOW() THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Active coupon must not be expired';
  END IF;
END$$

DELIMITER ;

-- ===================================================================
-- D) OPTIONAL CLEANUP OF REDUNDANT TABLES (safe if not present)
--     If these tables don't exist in your dump, IF EXISTS prevents errors.
-- ===================================================================

-- Drop rating aggregation table if present (duplicate of products.rating/review_count)
DROP TABLE IF EXISTS product_rating_agg;

-- Drop demo/admin tables if present (not used by the current app code)
DROP TABLE IF EXISTS admin_customers;
DROP TABLE IF EXISTS admin_orders;

COMMIT;

-- End of patch
