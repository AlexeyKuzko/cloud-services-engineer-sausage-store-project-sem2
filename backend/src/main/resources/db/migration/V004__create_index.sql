-- Create indexes for report queries
CREATE INDEX idx_orders_status_date ON orders(status, date_created);
CREATE INDEX idx_order_product_quantity ON order_product(quantity);
CREATE INDEX idx_product_price ON product(price);

-- Create materialized view for order statistics
CREATE MATERIALIZED VIEW order_statistics AS
SELECT 
    p.id as product_id,
    p.name as product_name,
    COUNT(op.id) as total_orders,
    SUM(op.quantity) as total_quantity,
    AVG(op.quantity) as avg_quantity,
    MIN(op.quantity) as min_quantity,
    MAX(op.quantity) as max_quantity
FROM product p
LEFT JOIN order_product op ON p.id = op.product_id
GROUP BY p.id, p.name;

CREATE UNIQUE INDEX idx_order_statistics_product_id ON order_statistics(product_id); 