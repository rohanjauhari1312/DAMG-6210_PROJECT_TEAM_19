
-- VIEWS


CREATE OR REPLACE VIEW Current_Inventory_Status AS
SELECT 
    v.vehicle_id,
    v.make,
    v.model,
    v.year,
    v.status,
    l.address,
    l.city,
    l.state,
    l.zip_code,
    v.price_per_hour
FROM 
    Vehicles v
JOIN 
    Locations l ON v.location_id = l.location_id
WHERE 
    v.status IN ('Available', 'Reserved', 'In Maintenance');
    
    
    




CREATE OR REPLACE VIEW Reservation_Revenue_Analysis AS
SELECT 
    v.vehicle_id,
    v.make,
    v.model,
    SUM(v.price_per_hour * (r.end_time - r.start_time) * 24) AS total_revenue
FROM 
    Reservations r
JOIN 
    Vehicles v ON r.vehicle_id = v.vehicle_id
GROUP BY 
    v.vehicle_id, v.make, v.model;
    
    
    
    
    
    
CREATE OR REPLACE VIEW Most_Popular_Vehicles AS
SELECT 
    v.vehicle_id,
    v.make,
    v.model,
    COUNT(r.reservation_id) AS reservation_count
FROM 
    Vehicles v
LEFT JOIN 
    Reservations r ON v.vehicle_id = r.vehicle_id
GROUP BY 
    v.vehicle_id, v.make, v.model
ORDER BY 
    reservation_count DESC;
    
    
    
    
CREATE OR REPLACE VIEW Vehicle_Availability_By_Location AS
SELECT 
    l.location_id,
    l.address || ', ' || l.city || ', ' || l.state || ' ' || l.zip_code AS location_name,  -- Concatenated full address
    COUNT(v.vehicle_id) AS available_vehicles
FROM 
    Locations l
LEFT JOIN 
    Vehicles v ON l.location_id = v.location_id AND v.status = 'Available'
GROUP BY 
    l.location_id, 
    l.address, l.city, l.state, l.zip_code;