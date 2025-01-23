# Infinite Calendar

A high-performance iOS calendar application featuring vertical infinite scroll and iCal-compliant event management.

## System Architecture

```mermaid
graph TD
    subgraph "iOS App"
        UI[UI Layer - SwiftUI]
        VM[View Models]
        UC[Use Cases]
        REPO[Repositories]
        NET[Network Layer]
    end
    
    subgraph "Backend - Supabase"
        AUTH[Authentication]
        DB[(PostgreSQL)]
        RLS[Row Level Security]
        RT[Real-time Updates]
    end
    
    UI --> VM
    VM --> UC
    UC --> REPO
    REPO --> NET
    NET --> AUTH
    AUTH --> DB
    DB --> RLS
    DB --> RT
```

## Module Structure
```mermaid
graph LR
    subgraph "App Modules"
        Core[CalendarCore]
        UI[CalendarUI]
        Domain[Domain]
        Data[Data]
        Network[NetworkLayer]
    end
    
    UI --> Core
    UI --> Domain
    Domain --> Data
    Data --> Network
```

## Project Structure
Calendar/
├── App/
│   └── CalendarApp.swift
├── Features/
│   ├── Calendar/
│   │   ├── UI/
│   │   ├── ViewModels/
│   │   └── Models/
│   ├── Events/
│   │   ├── UI/
│   │   ├── ViewModels/
│   │   └── Models/
│   └── Auth/
│       ├── UI/
│       ├── ViewModels/
│       └── Models/
├── Core/
│   ├── Domain/
│   │   ├── Entities/
│   │   ├── UseCases/
│   │   └── Repositories/
│   └── Data/
│       ├── Repositories/
│       ├── DataSources/
│       └── DTOs/
├── Infrastructure/
│   ├── Network/
│   ├── Storage/
│   └── DI/
└── Resources/
    ├── Assets/
    └── Localization/

## Data Flow
```mermaid
sequenceDiagram
    participant UI as SwiftUI View
    participant VM as ViewModel
    participant UC as Use Case
    participant Repo as Repository
    participant API as Supabase API

    UI->>VM: User Action
    VM->>UC: Execute Use Case
    UC->>Repo: Request Data
    Repo->>API: API Request
    API-->>Repo: Response
    Repo-->>UC: Data
    UC-->>VM: Updated State
    VM-->>UI: UI Update
```

## Event Data Model
```mermaid
erDiagram
    USER ||--o{ EVENT : creates
    EVENT ||--o{ RECURRENCE : has
    EVENT {
        uuid id
        string title
        timestamp start_date
        timestamp end_date
        string description
        string location
        string color
        uuid user_id
    }
    RECURRENCE {
        uuid id
        uuid event_id
        string frequency
        string interval
        timestamp until
        string byDay
    }
```