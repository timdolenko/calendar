# Infinite Calendar

A high-performance iOS calendar application featuring vertical infinite scroll and iCal-compliant event management.

## Requirements

### Functional Requirements:

- User should be able to login using Google Authentication
- User should be able to create an event
- User should be able to create a recurring event
- User should be able to see calendar in a day and monthly view
- Monthly view should implement smooth vertical scroll

### Non-Functional Requirements:
- Use pagination/infinite scroll for the monthly view
- Data should be loaded from the backend on start only
- Offline mode is not supported

## Infrastructure Diagram

```mermaid
graph LR
    subgraph "High Level Components"
        Auth[Google Auth]
        API[Supabase API]
        DB[Database]
        SBSDK[Supabase SDK]
        iOS[iOS Client]
    end
    
    iOS --> SBSDK
    SBSDK --> API
    API --> Auth
    API --> DB
```

## Frontent Design

```mermaid
graph LR
    SBSDK[Supabase SDK]

    subgraph "App"
        DI[Dependency Injection]
    end

    subgraph "Domain"
        AuthService[Auth Service]
        Repository[Repository Interface]
        Event[Event Entity]
    end
    
    subgraph "Network"
        AuthServiceLive[Auth Service Impl]
        RepositoryLive[Repository Impl]
        EventDTO[Event Data Tranfer Object]
    end

    subgraph "CalendarUI"
        MonthView[Monthly View]
        MonthModel[Monthly Model]
        DayView[Day View]
        DayModel[Day Model]
        AuthView[Auth View]
        AuthModel[Auth Model]
    end
    
    Network --> Domain
    Network --> SBSDK
    MonthModel --> Domain
    DayModel --> Domain
    AuthModel --> Domain
    MonthView --> MonthModel
    DayView --> DayModel
    AuthView --> AuthModel
    App --> Domain
    App --> Network
    App --> CalendarUI
```
## Data Model
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
        uuid user_id
    }
    RECURRENCE {
        uuid id
        uuid event_id
        string frequency "daily, weekly, monthly, annual"
        timestamp until
    }
```

## API
```mermaid
sequenceDiagram
    participant Client as iOS Client
    participant API as Supabase API

    Client->>API: select events { :start_date :end_date :user_id }
    API->>Client: Response { Array<EventDTO> }

    Client->>API: insert event { :start_date :end_date :user_id }
    API->>Client: Response { EventDTO  }

    Client->>API: update event { :start_date :end_date :user_id }
    API->>Client: Response { EventDTO  }

    Client->>API: delete event { :uuid :user_id }
    API->>Client: Response { :success  }
```


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
```
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
```

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

## Configuration Management

The app uses environment-specific configuration files for managing secrets and environment variables:

```plaintext
ios/Sources/CalendarCore/Resources/
├── Config.development.plist.template
├── Config.staging.plist.template
└── Config.production.plist.template
```

### Setup

1. Copy the template files and remove the `.template` extension
2. Update the values in each environment file
3. Files are gitignored to prevent committing sensitive data

### Usage

The configuration is managed through `AppConfig` in CalendarCore module and automatically loads the correct environment based on build configuration:
- DEBUG builds use development configuration
- RELEASE builds use production configuration

### Adding New Configuration

Add new keys to the template files and update the `AppConfig` struct in CalendarCore module.