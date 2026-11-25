# API Contract — Milestones 1, 3, 4 & 5

> Version: 3.0 | Date: 2026-11-23
> Base URL: `{REACT_APP_API_URL}/api` (default: `http://localhost:8080/api`)
> Auth: Bearer token in `Authorization` header (unless noted as Public)

This contract defines the exact REST endpoints Dev 1 (Backend) must implement and Dev 2 (Frontend) must consume for Milestone 1. Both teams can build in parallel against these specs.

---

## Existing Endpoints (unchanged, for reference)

These already work and are NOT changing in M1.

| Method | Path | Auth | Notes |
|--------|------|------|-------|
| POST | `/customer/signup` | Public | Register new customer |
| POST | `/customer/login` | Basic | Login by contact number |
| POST | `/customer/google-login` | Public | Google SSO |
| POST | `/customer/logout` | Bearer | Invalidate token |
| PUT | `/customer` | Bearer | Update name |
| PUT | `/customer/password` | Bearer | Change password |
| GET | `/restaurant` | Public | List all restaurants |
| GET | `/restaurant/{name}` | Public | Search restaurants |
| GET | `/restaurant/{id}` | Public | Restaurant details |
| PUT | `/restaurant/{id}` | Bearer | Update rating |
| GET | `/category` | Public | All categories |
| GET | `/category/{name}` | Public | Category by name |
| GET | `/item/restaurant/{id}` | Public | Items by restaurant |
| GET | `/address/customer` | Bearer | Customer addresses |
| POST | `/address` | Bearer | Save address |
| DELETE | `/address/{id}` | Bearer | Delete address |
| GET | `/states` | Public | All states |
| GET | `/payment` | Public | Payment methods |
| POST | `/order` | Bearer | Place order |
| GET | `/order` | Bearer | Customer's orders |
| GET | `/order/coupon/{name}` | Bearer | Get coupon by name |

---

## New / Modified Endpoints for M1

---

### 1. Login Response Change (M1-03)

**Endpoint:** `POST /customer/login` (MODIFIED response only)
**Auth:** Basic

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "first_name": "John",
  "last_name": "Doe",
  "contact_number": "1234567890",
  "email_address": "john@example.com",
  "message": "LOGGED IN SUCCESSFULLY",
  "role": "CUSTOMER"
}
```

**Change:** Added `role` field. Same for Google login response.

**Header:** `access-token: <jwt-token>` (unchanged)

---

### 2. Google Login Response Change (M1-03)

**Endpoint:** `POST /customer/google-login` (MODIFIED response only)
**Auth:** Public

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "first_name": "John",
  "last_name": "Doe",
  "contact_number": null,
  "email_address": "john@gmail.com",
  "message": "LOGGED IN SUCCESSFULLY",
  "role": "CUSTOMER"
}
```

**Change:** Added `role` field.

---

### 3. Email Login (M1-04)

**Endpoint:** `POST /customer/login` (MODIFIED — accepts email as username)
**Auth:** Basic (`email:password` OR `contactNumber:password`)

The backend detects which field was sent:
- If username contains `@` → lookup by email
- Else → lookup by contact_number (existing behavior)

**Responses:** Same as current login response (with `role` field added per M1-03).

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 401 | ATH-001 | This contact number / email has not been registered |
| 401 | ATH-002 | Password failed |

---

### 4. Admin — Dashboard Stats (M1-06)

**Endpoint:** `GET /admin/dashboard`
**Auth:** Bearer (ADMIN role required)

**Response (200 OK):**
```json
{
  "total_orders": 142,
  "total_revenue": 28450.00,
  "active_users": 87,
  "total_restaurants": 15
}
```

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 403 | AUT-001 | You are not authorized to perform this operation |

---

### 5. Admin — List Users (M1-03, M1-06)

**Endpoint:** `GET /admin/users?page=0&size=20`
**Auth:** Bearer (ADMIN role required)

**Query params:**
| Param | Type | Default | Description |
|-------|------|---------|-------------|
| page | int | 0 | Zero-indexed page number |
| size | int | 20 | Items per page |

**Response (200 OK):**
```json
{
  "users": [
    {
      "id": "uuid-string",
      "first_name": "John",
      "last_name": "Doe",
      "email": "john@example.com",
      "contact_number": "1234567890",
      "role": "CUSTOMER",
      "auth_provider": "LOCAL"
    }
  ],
  "page": 0,
  "size": 20,
  "total": 87
}
```

---

### 6. Admin — Change User Role (M1-03)

**Endpoint:** `PUT /admin/users/{customerUuid}/role`
**Auth:** Bearer (ADMIN role required)
**Content-Type:** `application/json`

**Request:**
```json
{
  "role": "RESTAURANT_OWNER"
}
```

**Valid roles:** `CUSTOMER`, `RESTAURANT_OWNER`, `DRIVER`, `ADMIN`

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "first_name": "John",
  "role": "RESTAURANT_OWNER",
  "message": "USER ROLE UPDATED SUCCESSFULLY"
}
```

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 403 | AUT-001 | You are not authorized to perform this operation |
| 404 | USR-001 | User not found |
| 400 | USR-002 | Invalid role |

---

### 7. Admin — List Restaurants (M1-06)

**Endpoint:** `GET /admin/restaurants?page=0&size=20`
**Auth:** Bearer (ADMIN role required)

**Response (200 OK):**
```json
{
  "restaurants": [
    {
      "id": "uuid-string",
      "restaurant_name": "Pizza Place",
      "photo_url": "https://...",
      "customer_rating": 4.2,
      "average_price_for_two": 350,
      "number_of_customers_rated": 42,
      "status": "ACTIVE",
      "address": {
        "id": "uuid-string",
        "flat_building_name": "123",
        "locality": "Main St",
        "city": "Mumbai",
        "pincode": "400001",
        "state": "Maharashtra"
      }
    }
  ],
  "page": 0,
  "size": 20,
  "total": 15
}
```

---

### 8. Admin — Update Restaurant Status (M1-06)

**Endpoint:** `PUT /admin/restaurants/{restaurantUuid}/status`
**Auth:** Bearer (ADMIN role required)
**Content-Type:** `application/json`

**Request:**
```json
{
  "status": "SUSPENDED"
}
```

**Valid statuses:** `ACTIVE`, `SUSPENDED`

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "restaurant_name": "Pizza Place",
  "status": "SUSPENDED",
  "message": "RESTAURANT STATUS UPDATED SUCCESSFULLY"
}
```

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 403 | AUT-001 | You are not authorized to perform this operation |
| 404 | RNF-001 | Restaurant not found |
| 400 | RST-001 | Invalid status |

---

### 9. Admin — List All Orders (M1-06)

**Endpoint:** `GET /admin/orders?page=0&size=20`
**Auth:** Bearer (ADMIN role required)

**Response (200 OK):**
```json
{
  "orders": [
    {
      "id": "uuid-string",
      "customer_name": "John Doe",
      "restaurant_name": "Pizza Place",
      "bill": 450.00,
      "discount": 45.00,
      "date": "2026-11-18T14:30:00",
      "payment": "Credit Card",
      "address": "123, Main St, Mumbai 400001"
    }
  ],
  "page": 0,
  "size": 20,
  "total": 142
}
```

---

## DB Migrations (M1)

Execute in order. All are additive (no data loss).

### V3__rbac.sql
```sql
ALTER TABLE customer ADD COLUMN role VARCHAR(20) DEFAULT 'CUSTOMER' NOT NULL;
```

**Admin bootstrap rule:** On signup (or Google SSO auto-register), if no user with `role = 'ADMIN'` exists yet, the new user is auto-promoted to `ADMIN`. This is checked in `CustomerService.saveCustomer()` and `authenticateWithGoogle()` after persisting the new user.

### V4__email_unique.sql
```sql
ALTER TABLE customer ADD CONSTRAINT customer_email_unique UNIQUE (email);
```

### V5__restaurant_status.sql
```sql
ALTER TABLE restaurant ADD COLUMN status VARCHAR(20) DEFAULT 'ACTIVE' NOT NULL;
```

---

## New Java Classes (M1)

| Class | Module | Owner | Card |
|-------|--------|-------|------|
| `RoleGuard.java` | service/business | Dev 1 | M1-03 |
| `AdminController.java` | api/controller | Dev 1 | M1-06 |
| `AdminService.java` | service/business | Dev 1 | M1-06 |

---

## New React Files (M1)

| File | Owner | Card |
|------|-------|------|
| `src/common/utils/AuthGuard.js` | Dev 2 | M1-05 |
| `src/screens/admin/Admin.js` | Dev 2 | M1-07 |
| `src/screens/admin/DashboardTab.js` | Dev 2 | M1-07 |
| `src/screens/admin/RestaurantsTab.js` | Dev 2 | M1-07 |
| `src/screens/admin/UsersTab.js` | Dev 2 | M1-07 |
| `src/screens/admin/OrdersTab.js` | Dev 2 | M1-07 |

---

## Frontend Config.js Additions (M1)

```javascript
{ "name": "Admin Dashboard",       "uri": "/api/admin/dashboard" },
{ "name": "Admin Users",           "uri": "/api/admin/users" },
{ "name": "Admin User Role",       "uri": "/api/admin/users" },
{ "name": "Admin Restaurants",     "uri": "/api/admin/restaurants" },
{ "name": "Admin Restaurant Status", "uri": "/api/admin/restaurants" },
{ "name": "Admin Orders",          "uri": "/api/admin/orders" }
```

---

## Role Guard Behavior

All existing endpoints remain `CUSTOMER`-accessible (no behavioral change). New endpoints require specific roles:

| Path prefix | Required role |
|-------------|---------------|
| `/api/admin/*` | `ADMIN` |
| `/api/restaurant/mine` | `RESTAURANT_OWNER` |
| `/api/restaurant/{uuid}` (PUT, owner ops) | `RESTAURANT_OWNER` (own restaurant only) |
| `/api/restaurant/{uuid}/item/*` (owner ops) | `RESTAURANT_OWNER` (own restaurant only) |
| `/api/invite/{token}` | Public |
| `/api/order/{uuid}/status` (PUT) | `ADMIN` or `RESTAURANT_OWNER` |
| `/api/customer/favorites/*` | Any authenticated user |
| `/api/driver/*` (future) | `DRIVER` |
| Everything else | Any authenticated user |

---

## New Endpoints for M3 — Launch Readiness

---

### 10. Admin — Create Restaurant (M3-01)

**Endpoint:** `POST /admin/restaurants`
**Auth:** Bearer (ADMIN role required)
**Content-Type:** `application/json`

**Request:**
```json
{
  "restaurant_name": "Pizza Palace",
  "photo_url": "https://images.unsplash.com/...",
  "average_price_for_two": 350,
  "address": {
    "flat_building_name": "123, Food Street",
    "locality": "Koramangala",
    "city": "Bangalore",
    "pincode": "560034",
    "state_uuid": "uuid-of-karnataka"
  },
  "category_uuids": ["uuid-cat-1", "uuid-cat-2"]
}
```

**Response (201 Created):**
```json
{
  "id": "uuid-string",
  "restaurant_name": "Pizza Palace",
  "status": "ACTIVE",
  "message": "RESTAURANT CREATED SUCCESSFULLY"
}
```

**Notes:**
- Admin-created restaurants default to `ACTIVE` (skip approval)
- `owner_id` left NULL (admin-managed until an owner is invited)

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 403 | AUT-001 | You are not authorized to perform this operation |
| 400 | RST-002 | Restaurant name is required |
| 404 | SNF-001 | State not found |

---

### 11. Admin — Add Menu Items (M3-01)

**Endpoint:** `POST /admin/restaurants/{restaurantUuid}/items`
**Auth:** Bearer (ADMIN role required)
**Content-Type:** `application/json`

**Request:**
```json
{
  "items": [
    {
      "item_name": "Margherita Pizza",
      "price": 299,
      "type": "VEG"
    },
    {
      "item_name": "Chicken Tikka Pizza",
      "price": 449,
      "type": "NON_VEG"
    }
  ]
}
```

**Response (201 Created):**
```json
{
  "items": [
    { "id": "uuid-1", "item_name": "Margherita Pizza", "price": 299, "type": "VEG" },
    { "id": "uuid-2", "item_name": "Chicken Tikka Pizza", "price": 449, "type": "NON_VEG" }
  ],
  "message": "2 ITEMS ADDED SUCCESSFULLY"
}
```

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 403 | AUT-001 | You are not authorized to perform this operation |
| 404 | RNF-001 | Restaurant not found |
| 400 | ITM-001 | Item name is required |
| 400 | ITM-002 | Price must be greater than 0 |
| 400 | ITM-003 | Type must be VEG or NON_VEG |

---

### 12. Admin — Edit Menu Item (M3-01)

**Endpoint:** `PUT /admin/restaurants/{restaurantUuid}/items/{itemUuid}`
**Auth:** Bearer (ADMIN role required)
**Content-Type:** `application/json`

**Request:**
```json
{
  "item_name": "Margherita Pizza (Large)",
  "price": 349,
  "type": "VEG"
}
```

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "item_name": "Margherita Pizza (Large)",
  "price": 349,
  "type": "VEG",
  "message": "ITEM UPDATED SUCCESSFULLY"
}
```

---

### 13. Admin — Delete Menu Item (M3-01)

**Endpoint:** `DELETE /admin/restaurants/{restaurantUuid}/items/{itemUuid}`
**Auth:** Bearer (ADMIN role required)

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "message": "ITEM DELETED SUCCESSFULLY"
}
```

---

### 14. Admin — Update Restaurant Status (M3-02, extended)

**Endpoint:** `PUT /admin/restaurants/{restaurantUuid}/status` (MODIFIED — adds PENDING)
**Auth:** Bearer (ADMIN role required)

**Request:**
```json
{
  "status": "ACTIVE"
}
```

**Valid statuses:** `PENDING`, `ACTIVE`, `SUSPENDED`

**Change from M1:** Added `PENDING` as a valid status. Self-registered restaurants start as `PENDING`. Admin approves by setting to `ACTIVE`.

---

### 15. Admin — Generate Invite Link (M3-03)

**Endpoint:** `POST /admin/restaurants/{restaurantUuid}/invite`
**Auth:** Bearer (ADMIN role required)

**Response (201 Created):**
```json
{
  "token": "abc123-unique-token",
  "restaurant_name": "Pizza Palace",
  "invite_url": "/invite/abc123-unique-token",
  "expires_at": "2026-11-28T19:00:00",
  "message": "INVITE LINK GENERATED SUCCESSFULLY"
}
```

**Notes:**
- Token is a UUID, expires in 7 days
- Single-use: once claimed, cannot be reused
- Admin can generate a new one if the old one expires

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 403 | AUT-001 | You are not authorized to perform this operation |
| 404 | RNF-001 | Restaurant not found |

---

### 16. Public — Validate Invite Token (M3-03)

**Endpoint:** `GET /invite/{token}`
**Auth:** Public (no auth required)

**Response (200 OK):**
```json
{
  "restaurant_name": "Pizza Palace",
  "status": "valid"
}
```

**Error responses:**
```json
{ "status": "expired", "message": "This invite link has expired" }
{ "status": "used", "message": "This invite link has already been used" }
{ "status": "invalid", "message": "Invalid invite link" }
```

---

### 17. Public — Claim Invite (M3-03)

**Endpoint:** `POST /invite/{token}/claim`
**Auth:** Bearer (any authenticated user)

**Description:** After the user signs up or logs in from the invite page, they call this to link themselves as the restaurant owner.

**Response (200 OK):**
```json
{
  "restaurant_id": "uuid-string",
  "restaurant_name": "Pizza Palace",
  "role": "RESTAURANT_OWNER",
  "message": "YOU ARE NOW THE OWNER OF THIS RESTAURANT"
}
```

**Side effects:**
- User's role set to `RESTAURANT_OWNER`
- Restaurant's `owner_id` set to the user's ID
- Invite token marked as used

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 400 | INV-001 | Invite link has expired |
| 400 | INV-002 | Invite link has already been used |
| 400 | INV-003 | Restaurant already has an owner |
| 404 | INV-004 | Invalid invite link |

---

### 18. Owner — Create Restaurant (M3-04)

**Endpoint:** `POST /restaurant`
**Auth:** Bearer (RESTAURANT_OWNER role required)
**Content-Type:** `application/json`

**Request:** Same shape as Admin Create (endpoint 10), minus `category_uuids` (admin assigns later).

**Response (201 Created):**
```json
{
  "id": "uuid-string",
  "restaurant_name": "My Biryani House",
  "status": "PENDING",
  "message": "RESTAURANT CREATED — PENDING ADMIN APPROVAL"
}
```

**Notes:**
- Owner-created restaurants default to `PENDING`
- `owner_id` auto-set to current user

---

### 19. Owner — Get My Restaurants (M3-04)

**Endpoint:** `GET /restaurant/mine`
**Auth:** Bearer (RESTAURANT_OWNER role required)

**Response (200 OK):**
```json
{
  "restaurants": [
    {
      "id": "uuid-string",
      "restaurant_name": "My Biryani House",
      "status": "PENDING",
      "photo_url": "https://...",
      "customer_rating": 0,
      "number_of_customers_rated": 0,
      "average_price_for_two": 400
    }
  ]
}
```

---

### 20. Owner — CRUD Menu Items (M3-04)

Same as Admin endpoints 11–13, but on the owner path and scoped to own restaurants:

| Method | Path | Notes |
|--------|------|-------|
| POST | `/restaurant/{uuid}/item` | Add item (own restaurant only) |
| PUT | `/restaurant/{uuid}/item/{itemUuid}` | Edit item (own restaurant only) |
| DELETE | `/restaurant/{uuid}/item/{itemUuid}` | Delete item (own restaurant only) |

Returns 403 if the restaurant's `owner_id` doesn't match the authenticated user.

---

## New Endpoints for M4 — Order Tracking & Favorites

---

### 21. Order Status — Get (M4-01)

**Endpoint:** `GET /order/{orderUuid}/status`
**Auth:** Bearer (any authenticated user)

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "status": "PREPARING",
  "status_updated_at": "2026-11-23T14:30:00",
  "date": "2026-11-23T12:00:00"
}
```

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 404 | ONF-001 | Order not found |

---

### 22. Order Status — Update (M4-01)

**Endpoint:** `PUT /order/{orderUuid}/status`
**Auth:** Bearer (ADMIN or RESTAURANT_OWNER role required)

**Request:**
```json
{
  "status": "CONFIRMED"
}
```

**Valid statuses (forward-only):** `PLACED` → `CONFIRMED` → `PREPARING` → `OUT_FOR_DELIVERY` → `DELIVERED`

**Response (200 OK):**
```json
{
  "id": "uuid-string",
  "status": "CONFIRMED",
  "status_updated_at": "2026-11-23T14:35:00",
  "message": "ORDER STATUS UPDATED SUCCESSFULLY"
}
```

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 400 | OST-001 | Invalid status |
| 400 | OST-002 | Cannot move status backward |
| 404 | ONF-001 | Order not found |

**Notes:**
- Status can only advance forward in the flow, never backward
- Frontend polls this endpoint every 30 seconds (MUI Stepper UI)

---

### 23. Customer — Add Favorite (M4-02)

**Endpoint:** `POST /customer/favorites/{restaurantUuid}`
**Auth:** Bearer (any authenticated user)

**Response (201 Created):**
```json
{
  "id": "restaurant-uuid",
  "message": "RESTAURANT ADDED TO FAVORITES"
}
```

**Duplicate handling:** Returns 200 with `"Restaurant is already in your favorites"` if already favorited.

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 404 | RNF-001 | Restaurant not found |

---

### 24. Customer — Remove Favorite (M4-02)

**Endpoint:** `DELETE /customer/favorites/{restaurantUuid}`
**Auth:** Bearer (any authenticated user)

**Response (200 OK):**
```json
{
  "id": "restaurant-uuid",
  "message": "RESTAURANT REMOVED FROM FAVORITES"
}
```

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 404 | RNF-001 | Restaurant not found |
| 404 | — | Restaurant is not in your favorites |

---

### 25. Customer — List Favorites (M4-02)

**Endpoint:** `GET /customer/favorites`
**Auth:** Bearer (any authenticated user)

**Response (200 OK):**
```json
{
  "restaurants": [
    {
      "id": "uuid-string",
      "restaurant_name": "Pizza Palace",
      "photo_url": "https://...",
      "customer_rating": 4.5,
      "average_price_for_two": 350,
      "number_of_customers_rated": 120
    }
  ]
}
```

---

## New Endpoints for M5 — Bulk Operations

---

### 26. Admin — Bulk Restaurant Import (M5-03)

**Endpoint:** `POST /admin/restaurants/import`
**Auth:** Bearer (ADMIN role required)
**Content-Type:** `multipart/form-data`
**Field:** `file` (CSV)

**CSV Columns:**

| Column | Required | Notes |
|--------|----------|-------|
| `name` | Yes | Restaurant name |
| `photo_url` | No | Image URL |
| `avg_price` | No | Average price for two (integer) |
| `flat_buil_number` | No | Address line |
| `locality` | No | Address locality |
| `city` | No | Address city |
| `pincode` | No | Address pincode |
| `state` | No | State name (case-insensitive match) |
| `category` | No | Pipe-separated: `Indian\|Chinese` |
| `status` | No | PENDING/ACTIVE/SUSPENDED (default: ACTIVE) |

**Response (200 OK):**
```json
{
  "imported_count": 8,
  "error_count": 2,
  "imported": [
    { "line": 2, "id": "uuid-string", "restaurant_name": "Pizza Palace", "status": "ACTIVE" }
  ],
  "errors": [
    { "line": 5, "message": "Missing restaurant name" },
    { "line": 9, "message": "Unknown state: Atlantis" }
  ],
  "message": "8 restaurants imported, 2 rows skipped"
}
```

**Errors:**
| Status | Code | Message |
|--------|------|---------|
| 400 | IMP-001 | CSV file is empty |
| 400 | IMP-002 | CSV file has no header row |
| 400 | IMP-003 | CSV must have a 'name' column |
| 400 | IMP-004 | Failed to read CSV |

**Notes:**
- Bad rows are skipped, not rolled back — partial success is expected
- State and category matched by name (case-insensitive)
- Multiple categories separated by pipe `|` character

---

## DB Migrations (M3–M5)

Execute after M1 migrations. All are additive.

### V6__restaurant_owner.sql
```sql
ALTER TABLE restaurant ADD COLUMN owner_id INTEGER REFERENCES customer(id);
```

### V7__invite_tokens.sql
```sql
CREATE TABLE invite_tokens (
    id SERIAL PRIMARY KEY,
    uuid VARCHAR(200) NOT NULL,
    token VARCHAR(200) NOT NULL UNIQUE,
    restaurant_id INTEGER NOT NULL REFERENCES restaurant(id),
    expires_at TIMESTAMP NOT NULL,
    used_at TIMESTAMP,
    used_by INTEGER REFERENCES customer(id),
    CONSTRAINT invite_tokens_uuid_unique UNIQUE (uuid)
);
```

### V8__restaurant_pending_status.sql
```sql
-- No schema change needed: status column (V5) already accepts any VARCHAR.
-- This migration documents the PENDING status convention:
-- PENDING = self-registered, awaiting admin approval
-- ACTIVE  = approved and visible in public listing
-- SUSPENDED = admin-suspended, hidden from public listing
-- Application enforces: GET /api/restaurant excludes WHERE status != 'ACTIVE'
COMMENT ON COLUMN restaurant.status IS 'PENDING | ACTIVE | SUSPENDED';
```

### V9__order_status.sql
```sql
ALTER TABLE orders ADD COLUMN status VARCHAR(30) DEFAULT 'PLACED' NOT NULL;
ALTER TABLE orders ADD COLUMN status_updated_at TIMESTAMP;
```

### V10__customer_favorites.sql
```sql
CREATE TABLE customer_favorite (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customer(id) ON DELETE CASCADE,
    restaurant_id INTEGER NOT NULL REFERENCES restaurant(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT customer_favorite_unique UNIQUE (customer_id, restaurant_id)
);
```

---

## New Java Classes (M3–M5)

| Class | Module | Owner | Card |
|-------|--------|-------|------|
| `RestaurantOwnerController.java` | api/controller | Dev 1 | M3-04 |
| `RestaurantOwnerService.java` | service/business | Dev 1 | M3-04 |
| `InviteTokenEntity.java` | service/entity | Dev 1 | M3-03 |
| `InviteTokenDao.java` | service/dao | Dev 1 | M3-03 |
| `InviteController.java` | api/controller | Dev 1 | M3-03 |
| `CustomerFavoriteController.java` | api/controller | Dev 1 | M4-02 |
| `CustomerFavoriteEntity.java` | service/entity | Dev 1 | M4-02 |
| `CustomerFavoriteDao.java` | service/dao | Dev 1 | M4-02 |

---

## New React Files (M3)

| File | Owner | Card |
|------|-------|------|
| `src/screens/admin/RestaurantForm.js` | Dev 2 | M3-01 |
| `src/screens/admin/MenuItemManager.js` | Dev 2 | M3-01 |
| `src/screens/admin/InviteLinkDialog.js` | Dev 2 | M3-03 |
| `src/screens/invite/InvitePage.js` | Dev 2 | M3-03 |
| `src/screens/owner/MyRestaurants.js` | Dev 2 | M3-05 |
| `src/screens/owner/RestaurantEditor.js` | Dev 2 | M3-05 |
| `src/screens/owner/MenuManager.js` | Dev 2 | M3-05 |
| `src/screens/owner/OwnerOrders.js` | Dev 2 | M3-05 |
| `src/screens/marketing/ForRestaurants.js` | Dev 2 | M3-06 |

---

## Frontend Config.js Additions (M3)

```javascript
{ "name": "Admin Create Restaurant",    "uri": "/api/admin/restaurants" },
{ "name": "Admin Restaurant Items",     "uri": "/api/admin/restaurants" },
{ "name": "Admin Restaurant Invite",    "uri": "/api/admin/restaurants" },
{ "name": "Validate Invite",            "uri": "/api/invite" },
{ "name": "Claim Invite",               "uri": "/api/invite" },
{ "name": "Owner My Restaurants",       "uri": "/api/restaurant/mine" },
{ "name": "Owner Restaurant Item",      "uri": "/api/restaurant" },
{ "name": "Order Status",              "uri": "/api/order" },
{ "name": "Customer Favorites",        "uri": "/api/customer/favorites" },
{ "name": "Admin Import Restaurants",  "uri": "/api/admin/restaurants/import" },
```
