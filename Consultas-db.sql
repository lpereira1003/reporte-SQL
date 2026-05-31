-- =====================================================
-- 01 INSERTAR PROPIETARIO
-- EN: tourism.owners
-- ES: propietarios
-- =====================================================
INSERT INTO tourism.owners (first_name, last_name, company_name, email, phone, tax_id, address_line1, city, STATE, country)
VALUES
('Luis', 'Pereira', 'PCS Tourism', 'pereira1003@gmail.com', '7777-8888', '0614-100362-101-1', 'Colonia Centro', 'San Miguel', 'San Miguel', 'El Salvador');

-- =====================================================
-- 02 INSERTAR ALOJAMIENTO
-- EN: tourism.accommodations, tourism.owners, tourism.accommodation_types, tourism.locations -- ES: alojamientos, propietarios, tipos de alojamiento, ubicaciones
-- =====================================================
INSERT INTO tourism.accommodations (owner_id, accommodation_type_id, location_id, name, description, max_guests, bedroom_count, bathroom_count, base_price_per_night, currency_code, check_in_time, check_out_time, is_active)
VALUES
(1, 1, 1, 'Hotel PCS', 'Hotel turístico moderno', 4, 2, 1, 120.00, 'USD', '14:00', '12:00', TRUE);

-- =====================================================
-- 03 INSERTAR HUÉSPED Y RESERVA
-- EN: tourism.guests, tourism.bookings -- ES: huéspedes, reservas
-- =====================================================
INSERT INTO tourism.guests (first_name, last_name, email, phone, nationality)
VALUES
('Carlos', 'Martinez', 'carlos@gmail.com', '7000-1111', 'Salvadoreña');
INSERT INTO tourism.bookings (
  guest_id,
  accommodation_id,
  room_id,
  booking_status_id,
  check_in_date,
  check_out_date,
  adult_count,
  child_count,
  total_nights,
  subtotal_amount,
  tax_amount,
  discount_amount,
  total_amount,
  booking_reference
)
VALUES
(
  1,
  1,
  1,
  1,
  '2026-06-01',
  '2026-06-05',
  2,
  0,
  4,
  480,
  62.40,
  0,
  542.40,
  'BR-101'
);
-- =====================================================
-- 04 INSERTAR PAGO
-- EN: tourism.payments, tourism.bookings
-- ES: pagos, reservas
-- =====================================================
INSERT INTO tourism.payments (booking_id, payment_date, amount, payment_method, payment_status, transaction_reference)
VALUES
(1, NOW(), 542.40, 'Tarjeta', 'Pagado', 'TXN-10001');
-- =====================================================
-- 05 ALOJAMIENTOS ACTIVOS
-- EN: tourism.accommodations
-- ES: alojamientos
-- =====================================================
SELECT
  *
FROM
  tourism.accommodations
WHERE
  is_active = TRUE;
-- =====================================================
-- 06 HUÉSPEDES POR PAÍS
-- EN: tourism.guests
-- ES: huéspedes
-- =====================================================
SELECT
  *
FROM
  tourism.guests
WHERE
  nationality = 'Salvadoreña';
-- =====================================================
-- 07 RESERVAS POR FECHA
-- EN: tourism.bookings
-- ES: reservas
-- =====================================================
SELECT
  *
FROM
  tourism.bookings
WHERE
  check_in_date BETWEEN '2026-06-01'
  AND '2026-06-30';
-- =====================================================
-- 08 ACTUALIZAR PRECIO
-- EN: tourism.accommodations
-- ES: alojamientos
-- =====================================================
UPDATE tourism.accommodations
SET base_price_per_night = 150.00
WHERE
  accommodation_id = 1;
-- =====================================================
-- 09 ACTUALIZAR ESTADO DE RESERVA (de pendiente(1) a confirmado(2)
-- EN: tourism.bookings, tourism.booking_statuses
-- ES: reservas, estados de reserva
-- =====================================================
UPDATE tourism.bookings
SET booking_status_id = 2
WHERE
  booking_id = 1;
-- =====================================================
-- 10 ELIMINAR RESEÑA
-- EN: tourism.reviews
-- ES: reseñas
-- =====================================================
DELETE
FROM
  tourism.reviews
WHERE
  review_id = 1;
-- =====================================================
-- 11 RESERVAS + HUÉSPED
-- EN: tourism.bookings, tourism.guests
-- ES: reservas, huéspedes
-- =====================================================
SELECT
  b.booking_id,
  g.first_name,
  g.last_name,
  b.check_in_date,
  b.check_out_date
FROM
  tourism.bookings b
  INNER JOIN tourism.guests g ON b.guest_id = g.guest_id;
-- =====================================================
-- 12 ALOJAMIENTO COMPLETO
-- EN: tourism.accommodations, tourism.owners, tourism.locations
-- ES: alojamientos, propietarios, ubicaciones
-- =====================================================
SELECT
  a.name AS alojamiento,
  o.first_name || ', ' || o.last_name AS propietario, -->concatenando nombre + apellido
  l.city,
  l.country
FROM
  tourism.accommodations a
  INNER JOIN tourism.owners o ON a.owner_id = o.owner_id
  INNER JOIN tourism.locations l ON a.location_id = l.location_id;
-- =====================================================
-- 13 PAGOS + RESERVAS
-- EN: tourism.payments, tourism.bookings
-- ES: pagos, reservas
-- =====================================================
SELECT
  p.payment_id,
  p.amount AS pagos,
  p.payment_method AS metodo_de_pago,
  b.booking_id,
  b.total_amount AS total_pagado
FROM
  tourism.payments p
  INNER JOIN tourism.bookings b ON p.booking_id = b.booking_id;
-- =====================================================
-- 14 ALOJAMIENTOS SIN RESEÑAS
-- EN: tourism.accommodations, tourism.reviews
-- ES: alojamientos, reseñas
-- =====================================================
SELECT
  a.accommodation_id,
  a.name
FROM
  tourism.accommodations a
  LEFT JOIN tourism.reviews r ON a.accommodation_id = r.accommodation_id
WHERE
  r.review_id IS NULL;
-- =====================================================
-- 15 ALOJAMIENTOS SIN RESERVAS
-- EN: tourism.accommodations, tourism.bookings
-- ES: alojamientos, reservas
-- =====================================================
SELECT
  a.accommodation_id,
  a.name
FROM
  tourism.accommodations a
  LEFT JOIN tourism.bookings b ON a.accommodation_id = b.accommodation_id
WHERE
  b.booking_id IS NULL;
-- =====================================================
-- 16 TOTAL INGRESOS
-- EN: tourism.payments
-- ES: pagos
-- =====================================================
SELECT
  SUM(amount) AS total_ingresos
FROM
  tourism.payments;
-- =====================================================
-- 17 PROMEDIO RATING
-- EN: tourism.reviews
-- ES: reseñas
-- =====================================================
SELECT
  ROUND(AVG(rating), 2) AS promedio_rating
FROM
  tourism.reviews;
-- =====================================================
-- 18 TOP ALOJAMIENTOS
-- EN: tourism.bookings, tourism.accommodations
-- ES: reservas, alojamientos
-- =====================================================
SELECT
  bookings.accommodation_id,
  accommodations.name,
  COUNT(*) AS total_reservas
FROM
  bookings
  INNER JOIN accommodations ON accommodations.accommodation_id = bookings.accommodation_id
GROUP BY
  bookings.accommodation_id,
  accommodations."name"
ORDER BY
  total_reservas DESC
  LIMIT 5;
-- =====================================================
-- 19 MÁS DE 3 RESERVAS
-- EN: tourism.bookings, tourism.accommodations
-- ES: reservas, alojamientos
-- =====================================================
SELECT
  accommodation_id,
  COUNT(*) AS total_reservas
FROM
  tourism.bookings
GROUP BY
  accommodation_id
HAVING
  COUNT(*) > 3
ORDER BY
  total_reservas ASC;
	 -- =====================================================
  -- 20 ALOJAMIENTO MÁS CARO
  -- EN: tourism.accommodations
  -- ES: alojamientos
  -- =====================================================
SELECT
  description,
  max_guests,
  base_price_per_night
FROM
  tourism.accommodations
WHERE
  base_price_per_night = (SELECT MAX(base_price_per_night) FROM tourism.accommodations);