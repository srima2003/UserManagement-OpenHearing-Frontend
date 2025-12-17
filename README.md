#  Project Report: User Management System

## 1. Project Overview
This project is a full-stack **User Management System** designed to handle Create, Read, Update, and Delete (CRUD) operations for user entities. It is built using **Java 21**, **Spring Boot 3.4**, and **MySQL**, adhering to enterprise-grade best practices such as **Layered Architecture**, **DTO Pattern**, and **Soft Deletes**.

The system features a **Dynamic Web Project Frontend (JSP)** that interacts with the backend via RESTful APIs, utilizing **Fetch API** for asynchronous data handling and **Chart.js** for data visualization.

---

## 2.  Pain Points & Technical Challenges
During the development lifecycle, I encountered several specific technical hurdles. Here is how I diagnosed and resolved them:

### **A. The "Empty JSON" Mystery (Lombok vs. Manual Getters)**
* **The Issue:** The backend was returning JSON arrays successfully (Status 200 OK), but the fields were `null` (e.g., `[{"name": null, "email": null}]`).
* **Diagnosis:** I initially relied on Lombok's `@Data` annotation. However, due to an IDE configuration issue, the bytecode wasn't generating the Getters/Setters. Since Jackson (the JSON serializer) relies on Getters to map data to JSON, it couldn't read the values.
* **The Fix:** I manually generated Getters and Setters for the `User` entity and `UserDTO` classes, ensuring reliable data serialization.

### **B. Syntax Collision: JSP Expression Language vs. JavaScript**
* **The Issue:** The Dashboard failed to load user data, throwing a server-side parsing error.
* **Diagnosis:** Modern JavaScript uses `${}` for Template Literals (e.g., `` `Hello ${name}` ``). However, **JSP** uses the exact same syntax `${}` for its Server-Side Expression Language (EL). The server tried to interpret the JavaScript code as Java code and failed.
* **The Fix:** I explicitly disabled EL on the dashboard page by adding `<%@ page isELIgnored="true" %>`. This forced the server to ignore the syntax and let the browser handle it as standard JavaScript.

### **C. Cross-Origin Resource Sharing (CORS)**
* **The Issue:** The Frontend (running on Port 8080) was blocked from making API calls to the Backend (running on Port 8085) by the browser's security policy.
* **The Fix:** I implemented Global CORS configuration in the `UserController` using the annotation `@CrossOrigin(origins = "http://localhost:8080")`, explicitly allowing the frontend to communicate with the backend.

### **D. Boolean Logic Mismatch (Active vs. Inactive)**
* **The Issue:** The "Active Users" pie chart was displaying incorrect data.
* **Diagnosis:** The MySQL database stored boolean values as `BIT` types (returning `0` or `1`), whereas the Java boolean is `true`/`false`. JavaScript's loose typing caused comparison errors.
* **The Fix:** I wrote a strict utility check in JavaScript to handle all possible truthy values:
    ```javascript
    if (user.isActive === 1 || user.isActive === true || user.isActive === "true") { ... }
    ```

---

## 3.  Key Learnings & Architectural Decisions

### **1. Soft Delete Implementation**
Instead of physically deleting records (`DELETE FROM users...`), I implemented a **Soft Delete** strategy using an `isActive` flag.
* **Why?** In real-world enterprise systems, data is valuable for auditing and history. Hard deletes destroy this history.
* **How?** The `deleteUser()` service method updates the `isActive` column to `false` (or `0`) instead of removing the row.

### **2. DTO (Data Transfer Object) Pattern**
I strictly decoupled the **Database Entity** (`User.java`) from the **API Response** (`UserDTO.java`).
* **Why?** Exposing database entities directly is a security risk (Mass Assignment Vulnerability) and creates tight coupling. DTOs allow us to format data specifically for the API consumer without changing the database schema.

### **3. Global Exception Handling**
I implemented a centralized `@RestControllerAdvice` class.
* **Why?** To prevent the API from leaking raw Java Stack Traces to the client, which is bad for both User Experience and Security.
* **How?** The `GlobalExceptionHandler` intercepts validation errors (like invalid Mobile/PAN formats) and returns a structured, user-friendly JSON response.

---

## 4.  Best Practices Implemented (Checklist)

| Category | Practice | Implementation Detail |
| :--- | :--- | :--- |
| **Validation** | Input Sanitization | Used `@Pattern` (Regex) for strict validation of Indian PAN, Aadhaar, and Mobile numbers. |
| **Database** | Data Integrity | Enforced `unique=true` constraints on Email, PAN, and Aadhaar columns. |
| **API** | REST Standards | Used proper HTTP verbs: `POST` (Create), `PUT` (Update), `GET` (Read), `DELETE` (Remove). |
| **Performance** | Pagination | Implemented `PageRequest` to efficiently load users in chunks rather than fetching the entire database at once. |
| **Testing** | Unit Testing | Wrote JUnit 5 test cases to verify the Service layer logic and ensure stability. |
| **Version Control** | Git Strategy | Followed a "Feature-based" commit history (e.g., `feat: add user service`, `fix: cors issue`) rather than a single bulk upload. |

---
