CREATE DATABASE IF NOT EXISTS clinic_db;
USE clinic_db;

CREATE TABLE patients (
    id INT GENERATED ALWAYS AS IDENTITY, 
    name VARCHAR(50),
    data_of_birth DATE, 
    PRIMARY KEY(id)
);

CREATE TABLE medical_histories (
    id INT GENERATED ALWAYS AS IDENTITY, 
    admitted_at TIMESTAMP,
    patient_id INT REFERENCES patients(id),
    status VARCHAR(25), 
    PRIMARY KEY(id)
);

CREATE TABLE treatments (
    id INT GENERATED ALWAYS AS IDENTITY,
    type VARCHAR(25),
    name VARCHAR(50),
    PRIMARY KEY(id)
);

CREATE TABLE medical_histories_treatments_map (
    medical_histories_id INT REFERENCES medical_histories(id),
    treatments_id INT REFERENCES treatments(id),
    PRIMARY KEY (medical_histories_id,treatments_id)
);

CREATE TABLE invoices (
    id INT GENERATED ALWAYS AS IDENTITY,
    total_amount DECIMAL(8,2),
    generated_at TIMESTAMP,
    payed_at TIMESTAMP,
    medical_history_id INT REFERENCES medical_histories(id),
    PRIMARY KEY(id)
);

CREATE TABLE invoice_items (
    id INT GENERATED ALWAYS AS IDENTITY,
    unit_price DECIMAL(8,2),
    quantity INT,
    total_price DECIMAL(8,2),
    invoice_id INT REFERENCES invoices(id),
    treatment_id INT REFERENCES treatments(id),
    PRIMARY KEY(id)
);

-- FK INDEXES
CREATE INDEX idx_medical_histories_patient_id ON medical_histories(patient_id);
CREATE INDEX idx_medical_histories_treatments_map_medical_histories_id ON medical_histories_treatments_map(medical_histories_id);
CREATE INDEX idx_medical_histories_treatments_map_treatments_id ON medical_histories_treatments_map(treatments_id);
CREATE INDEX idx_invoices_medical_history_id ON invoices(medical_history_id);
CREATE INDEX idx_invoice_items_invoice_id ON invoice_items(invoice_id);
CREATE INDEX idx_invoice_items_treatment_id ON invoice_items(treatment_id);