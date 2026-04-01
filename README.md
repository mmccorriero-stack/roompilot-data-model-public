# RoomPilot Data Model Public

Public SQL repository for the RoomPilot hospitality data model.

This repository contains the public-facing SQL structure used to organize hospitality reservation data for reporting, analytics, and revenue management use cases.

## Repository structure

- `staging/` → cleaned source tables used as input layer
- `fact/` → fact tables for analytical modeling
- `dimensions/` → dimension tables for descriptive attributes
- `kpi/` → core KPI queries such as ADR, Occupancy, RevPAR
- `booking_behavior/` → lead time, booking window, pickup analysis
- `revenue/` → revenue analysis by channel and segment

## Current scope

This public repository includes:
- staging and analytical table definitions
- KPI logic
- booking behavior queries
- revenue breakdown queries

Advanced pricing logic, forecasting models, and proprietary RoomPilot engine components are kept outside the public repository.
