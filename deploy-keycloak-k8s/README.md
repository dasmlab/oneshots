## High Level Design

Keycloak is the DASMLAB IdP in the overall OAUTH/OICD service ecc-system to develop against

```mermaid
sequenceDiagram
    participant Client as Client (Browser/App)
    participant Service as DASMLAB Service (API)
    participant IDP as Keycloak OIDC (keycloak.dasmlab.org)

    Client->>Service: (1) Request Protected Resource (no token)
    Service-->>Client: (2) 401 Unauthorized (OIDC required)
    Client->>IDP: (3) Redirect/Login (OIDC Authorization Code)
    IDP-->>Client: (4) OIDC Token (ID/Access)
    Client->>Service: (5) Request with Bearer Token
    Service->>IDP: (6) Validate/Decode Token
    IDP-->>Service: (7) Token Valid/Claims
    Service-->>Client: (8) Return Protected Data
