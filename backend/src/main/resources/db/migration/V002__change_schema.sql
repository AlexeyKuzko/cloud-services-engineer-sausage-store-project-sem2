-- Add indexes for better query performance
CREATE INDEX idx_order_product_order_id ON order_product(order_id);
CREATE INDEX idx_order_product_product_id ON order_product(product_id);
CREATE INDEX idx_orders_date_created ON orders(date_created);
CREATE INDEX idx_orders_status ON orders(status);

-- Add constraints
ALTER TABLE order_product
    ADD CONSTRAINT fk_order_product_order_id
    FOREIGN KEY (order_id)
    REFERENCES orders(id)
    ON DELETE CASCADE;

ALTER TABLE order_product
    ADD CONSTRAINT fk_order_product_product_id
    FOREIGN KEY (product_id)
    REFERENCES product(id)
    ON DELETE RESTRICT; 