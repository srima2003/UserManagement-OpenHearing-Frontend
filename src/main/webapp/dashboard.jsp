<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Open Hearing - Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root { --header-blue: #2c3e9e; --bg-light: #f4f6f9; --text-dark: #333; --active-green: #28a745; }
        body { margin: 0; font-family: 'Roboto', sans-serif; background-color: var(--bg-light); color: var(--text-dark); }

        /* Navbar */
        .navbar { background-color: var(--header-blue); color: white; height: 60px; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; }
        .brand { font-weight: 700; font-size: 18px; text-transform: uppercase; display: flex; gap: 10px; align-items: center;}
        .user-profile { display: flex; align-items: center; gap: 10px; font-weight: 500; }
        .avatar-circle { width: 32px; height: 32px; background: white; color: var(--header-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; }

        /* Container */
        .container { padding: 20px 30px; }
        .page-title { font-size: 16px; font-weight: 700; color: #444; margin-bottom: 20px; text-transform: uppercase; letter-spacing: 0.5px; }

        /* Widgets */
        .widget-row { display: flex; gap: 20px; margin-bottom: 25px; height: 170px; }
        .card { background: white; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); padding: 15px; flex: 1; box-sizing: border-box; }
        .card-add { display: flex; align-items: center; justify-content: center; cursor: pointer; color: var(--header-blue); font-size: 18px; font-weight: 600; }
        .card-add:hover { background-color: #f8f9fa; }
        .card-pie { display: flex; align-items: center; justify-content: space-between; }
        .pie-stats h2 { margin: 0; font-size: 26px; color: var(--header-blue); }
        .pie-wrapper { width: 110px; height: 110px; }
        .card-graph { flex: 2; display: flex; flex-direction: column; }
        .graph-wrapper { flex: 1; position: relative; width: 100%; }

        /* Toolbar */
        .toolbar { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 13px; color: #555; }
        .filter-left { display: flex; gap: 10px; align-items: center; }
        .search-wrapper { position: relative; }
        .search-wrapper input { padding: 6px 10px 6px 30px; border: 1px solid var(--header-blue); border-radius: 4px; width: 200px; outline: none; }
        .search-wrapper i { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: var(--header-blue); }

        /* Table */
        table { width: 100%; background: white; border-collapse: collapse; border-radius: 6px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 15px; }
        thead { background-color: #e0e0e0; }
        th { text-align: left; padding: 10px 15px; font-size: 12px; font-weight: 600; color: #555; border-bottom: 1px solid #ccc; }
        td { padding: 12px 15px; border-bottom: 1px solid #eee; font-size: 13px; vertical-align: middle; }
        .user-flex { display: flex; align-items: center; gap: 10px; }
        .table-avatar { width: 28px; height: 28px; border-radius: 50%; object-fit: cover; }
        .status-active { color: #28a745; font-weight: 500; }
        .action-icons i { margin-right: 12px; cursor: pointer; color: #777; font-size: 14px; }
        .action-icons i:hover { color: var(--header-blue); }
        .action-icons .fa-trash:hover { color: #dc3545; }

        /* Pagination */
        .pagination-container { display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #555; }
        .pagination { display: flex; gap: 5px; }
        .page-btn { padding: 5px 10px; border: 1px solid #ccc; background: white; cursor: pointer; border-radius: 4px; }
        .page-btn:hover { background: #eee; }
        .page-btn.active { background: var(--header-blue); color: white; border-color: var(--header-blue); }
        .page-btn.disabled { color: #ccc; cursor: not-allowed; }

        /* Modal */
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); justify-content: center; align-items: center; z-index: 1000; overflow-y: auto; }
        .modal-content { background: white; padding: 25px; border-radius: 8px; width: 600px; max-height: 90vh; overflow-y: auto; position: relative; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group { margin-bottom: 10px; }
        .form-group.full-width { grid-column: span 2; }
        .form-group label { display: block; margin-bottom: 5px; font-size: 13px; font-weight: bold; }
        .form-group input, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .modal-btns { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-primary { background: var(--header-blue); color: white; }
        .btn-secondary { background: #ccc; color: #333; }
        h3 { margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 10px; }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="brand"><i class="fa-solid fa-infinity"></i> Open Hearing</div>
        <div class="user-profile"><span>Admin</span><div class="avatar-circle">A</div><i class="fa-solid fa-power-off" style="cursor:pointer; margin-left:10px;" onclick="logout()"></i></div>
    </div>

    <div class="container">
        <div class="page-title">Manage Users</div>

        <div class="widget-row">
            <div class="card card-add" onclick="openAddModal()"><div><i class="fa-solid fa-user-plus"></i> Add User</div></div>
            <div class="card card-pie">
                <div class="pie-stats"><h2 id="totalUsersCount">0</h2><p>Total Users</p></div>
                <div class="pie-wrapper"><canvas id="pieChart"></canvas></div>
            </div>
            <div class="card card-graph"><div class="graph-wrapper"><canvas id="lineChart"></canvas></div></div>
        </div>

        <div class="toolbar">
            <div class="filter-left">
                <span>Showing <span id="startEntry">0</span> to <span id="endEntry">0</span> of <span id="totalEntry">0</span> entries</span>
            </div>
            <div class="search-wrapper"><i class="fa-solid fa-magnifying-glass"></i><input type="text" placeholder="Search user..." id="searchInput" onkeyup="filterTable()"></div>
        </div>

        <table>
            <thead>
                <tr>
                    <th style="width:30px;"><input type="checkbox"></th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Mobile</th>
                    <th>Aadhaar</th>
                    <th>PAN</th>
                    <th>Location</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="tableBody">
                <tr><td colspan="9" style="text-align:center; padding:20px;">Loading data...</td></tr>
            </tbody>
        </table>

        <div class="pagination-container">
            <div></div> <div class="pagination" id="paginationControls">
                </div>
        </div>
    </div>

    <div id="userModal" class="modal">
        <div class="modal-content">
            <h3 id="modalTitle">Add New User</h3>
            <input type="hidden" id="userId"> <div class="form-grid">
                <div class="form-group"><label>Full Name</label><input type="text" id="mName"></div>
                <div class="form-group"><label>Email</label><input type="email" id="mEmail"></div>
                
                <div class="form-group"><label>Primary Mobile</label><input type="text" id="mMobile1"></div>
                <div class="form-group"><label>Secondary Mobile</label><input type="text" id="mMobile2"></div>
                
                <div class="form-group"><label>Aadhaar</label><input type="text" id="mAadhaar"></div>
                <div class="form-group"><label>PAN Card</label><input type="text" id="mPan"></div>
                
                <div class="form-group"><label>Date of Birth</label><input type="date" id="mDob"></div>
                <div class="form-group"><label>Place of Birth</label><input type="text" id="mPlace"></div>
                
                <div class="form-group full-width"><label>Current Address</label><textarea id="mCurAddr" rows="2"></textarea></div>
                <div class="form-group full-width"><label>Permanent Address</label><textarea id="mPermAddr" rows="2"></textarea></div>
            </div>

            <div class="modal-btns">
                <button class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                <button class="btn btn-primary" onclick="submitUser()">Save User</button>
            </div>
        </div>
    </div>

    <script>
        const API_URL = "http://localhost:8085/api/users";
        let allUsers = [];
        let filteredUsers = []; // Stores users after search filtering
        let currentPage = 1;
        const rowsPerPage = 15;

        document.addEventListener("DOMContentLoaded", () => {
            if(!localStorage.getItem("userToken")) window.location.href = "login.jsp";
            initCharts();
            loadUsers();
        });

        function logout() { localStorage.removeItem("userToken"); window.location.href = "login.jsp"; }

        // --- LOAD DATA ---
        async function loadUsers() {
            try {
                const res = await fetch(API_URL);
                if(!res.ok) throw new Error("Failed");
                const data = await res.json();
                allUsers = data.content;
                filteredUsers = [...allUsers]; // Init filtered list with all users
                
                document.getElementById("totalUsersCount").innerText = allUsers.length;
                
                // Initialize Pagination View
                currentPage = 1;
                displayPage(1);
                setupPagination();
                
            } catch(e) {
                console.error(e);
                document.getElementById("tableBody").innerHTML = `<tr><td colspan="9" style="text-align:center; color:red;">Connection Error</td></tr>`;
            }
        }

        // --- DISPLAY PAGE (Core Pagination Logic) ---
        function displayPage(page) {
            currentPage = page;
            const start = (page - 1) * rowsPerPage;
            const end = start + rowsPerPage;
            const paginatedItems = filteredUsers.slice(start, end);

            // Update Info Text
            const total = filteredUsers.length;
            document.getElementById("startEntry").innerText = total === 0 ? 0 : start + 1;
            document.getElementById("endEntry").innerText = Math.min(end, total);
            document.getElementById("totalEntry").innerText = total;

            renderTable(paginatedItems);
            setupPagination(); // Re-render buttons to update active state
        }

        // --- SETUP PAGINATION BUTTONS ---
        function setupPagination() {
            const container = document.getElementById("paginationControls");
            container.innerHTML = "";
            const totalPages = Math.ceil(filteredUsers.length / rowsPerPage);

            if (totalPages <= 1) return; // Hide if only 1 page

            // Prev Button
            const prevBtn = document.createElement("button");
            prevBtn.innerText = "Prev";
            prevBtn.classList.add("page-btn");
            if (currentPage === 1) prevBtn.classList.add("disabled");
            else prevBtn.onclick = () => displayPage(currentPage - 1);
            container.appendChild(prevBtn);

            // Numbered Buttons
            for (let i = 1; i <= totalPages; i++) {
                const btn = document.createElement("button");
                btn.innerText = i;
                btn.classList.add("page-btn");
                if (i === currentPage) btn.classList.add("active");
                btn.onclick = () => displayPage(i);
                container.appendChild(btn);
            }

            // Next Button
            const nextBtn = document.createElement("button");
            nextBtn.innerText = "Next";
            nextBtn.classList.add("page-btn");
            if (currentPage === totalPages) nextBtn.classList.add("disabled");
            else nextBtn.onclick = () => displayPage(currentPage + 1);
            container.appendChild(nextBtn);
        }

        // --- RENDER TABLE ---
        function renderTable(users) {
            const tbody = document.getElementById("tableBody");
            tbody.innerHTML = "";
            
            if (users.length === 0) {
                tbody.innerHTML = `<tr><td colspan="9" style="text-align:center; padding:20px;">No users found</td></tr>`;
                return;
            }

            users.forEach(user => {
                const avatar = `https://ui-avatars.com/api/?name=${user.name}&background=random&color=fff&size=28`;
                const row = document.createElement("tr");
                row.innerHTML = `
                    <td><input type="checkbox"></td>
                    <td><div class="user-flex"><img src="${avatar}" class="table-avatar"><strong>${user.name}</strong></div></td>
                    <td>${user.email}</td>
                    <td>${user.primaryMobile}</td>
                    <td>${user.aadhaar}</td>
                    <td>${user.pan}</td>
                    <td>${user.placeOfBirth || '-'}</td>
                    <td><span class="status-active">Active</span></td>
                    <td class="action-icons">
                        <i class="fa-solid fa-pen" onclick="openEditModal(${user.id})" title="Edit"></i>
                        <i class="fa-solid fa-trash" onclick="deleteUser(${user.id})" title="Delete"></i>
                    </td>
                `;
                tbody.appendChild(row);
            });
        }

        // --- FILTER / SEARCH ---
        function filterTable() {
            const query = document.getElementById("searchInput").value.toLowerCase();
            filteredUsers = allUsers.filter(u => 
                u.name.toLowerCase().includes(query) || 
                u.email.toLowerCase().includes(query)
            );
            
            // Reset to page 1 on search
            currentPage = 1;
            displayPage(1);
            setupPagination();
        }

        // --- DELETE USER ---
        async function deleteUser(id) {
            if(!confirm("Are you sure you want to delete this user?")) return;
            try {
                const res = await fetch(API_URL + "/" + id, { method: 'DELETE' });
                if(res.ok) { loadUsers(); } 
                else { alert("Failed to delete user"); }
            } catch(e) { console.error(e); }
        }

        // --- MODAL LOGIC (ADD & EDIT) ---
        function openAddModal() {
            document.getElementById("modalTitle").innerText = "Add New User";
            document.getElementById("userId").value = ""; 
            clearForm();
            document.getElementById("userModal").style.display = "flex";
        }

        function openEditModal(id) {
            const user = allUsers.find(u => u.id === id);
            if(!user) return;

            document.getElementById("modalTitle").innerText = "Edit User";
            document.getElementById("userId").value = user.id;
            
            // Populate Fields
            document.getElementById("mName").value = user.name;
            document.getElementById("mEmail").value = user.email;
            document.getElementById("mMobile1").value = user.primaryMobile;
            document.getElementById("mMobile2").value = user.secondaryMobile || "";
            document.getElementById("mAadhaar").value = user.aadhaar;
            document.getElementById("mPan").value = user.pan;
            document.getElementById("mDob").value = user.dateOfBirth;
            document.getElementById("mPlace").value = user.placeOfBirth || "";
            document.getElementById("mCurAddr").value = user.currentAddress || "";
            document.getElementById("mPermAddr").value = user.permanentAddress || "";

            document.getElementById("userModal").style.display = "flex";
        }

        function closeModal() { document.getElementById("userModal").style.display = "none"; }
        function clearForm() {
            document.querySelectorAll("#userModal input, #userModal textarea").forEach(i => i.value = "");
        }

        // --- SUBMIT USER (CREATE OR UPDATE) ---
        async function submitUser() {
            const id = document.getElementById("userId").value;
            const isEdit = id !== "";
            
            const userData = {
                name: document.getElementById("mName").value,
                email: document.getElementById("mEmail").value,
                primaryMobile: document.getElementById("mMobile1").value,
                secondaryMobile: document.getElementById("mMobile2").value,
                aadhaar: document.getElementById("mAadhaar").value,
                pan: document.getElementById("mPan").value,
                dateOfBirth: document.getElementById("mDob").value || "2000-01-01",
                placeOfBirth: document.getElementById("mPlace").value,
                currentAddress: document.getElementById("mCurAddr").value,
                permanentAddress: document.getElementById("mPermAddr").value
            };

            const method = isEdit ? "PUT" : "POST";
            const url = isEdit ? (API_URL + "/" + id) : API_URL;

            try {
                const res = await fetch(url, {
                    method: method,
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(userData)
                });

                if(res.ok) {
                    closeModal();
                    loadUsers();
                    alert(isEdit ? "User Updated!" : "User Created!");
                } else {
                    const err = await res.json();
                    alert("Error: " + JSON.stringify(err));
                }
            } catch(e) { console.error(e); alert("Connection Error"); }
        }

        function initCharts() {
            new Chart(document.getElementById('pieChart'), {
                type: 'pie', data: { datasets: [{ data: [70, 30], backgroundColor: ['#2c3e9e', '#e6e6e6'], borderWidth: 0 }] }, options: { maintainAspectRatio: false, events: [] }
            });
            new Chart(document.getElementById('lineChart'), {
                type: 'line', data: { labels: ['S', 'M', 'T', 'W', 'T', 'F', 'S'], datasets: [{ data: [12, 19, 17, 21, 18, 22, 20], borderColor: '#5c85ff', backgroundColor: 'rgba(92, 133, 255, 0.1)', fill: true, tension: 0.4, pointRadius: 0 }] }, options: { maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { display: false }, y: { display: false } } }
            });
        }
    </script>
</body>
</html>
