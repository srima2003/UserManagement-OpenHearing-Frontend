<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Open Hearing - React Dashboard</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    
    <script crossorigin src="https://unpkg.com/react@18/umd/react.development.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
    <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        /* (Styles remain exactly the same as before) */
        :root { --header-blue: #2c3e9e; --bg-light: #f4f6f9; --text-dark: #333; --active-green: #28a745; }
        body { margin: 0; font-family: 'Roboto', sans-serif; background-color: var(--bg-light); color: var(--text-dark); }
        .navbar { background-color: var(--header-blue); color: white; height: 60px; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; }
        .brand { font-weight: 700; font-size: 18px; text-transform: uppercase; display: flex; gap: 10px; align-items: center;}
        .user-profile { display: flex; align-items: center; gap: 10px; font-weight: 500; }
        .avatar-circle-admin { width: 32px; height: 32px; background: white; color: var(--header-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; }
        .container { padding: 20px 30px; }
        .page-title { font-size: 16px; font-weight: 700; color: #444; margin-bottom: 20px; text-transform: uppercase; letter-spacing: 0.5px; }
        .widget-row { display: flex; gap: 20px; margin-bottom: 25px; height: 170px; }
        .card { background: white; border-radius: 6px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); padding: 15px; flex: 1; box-sizing: border-box; }
        .card-add { display: flex; align-items: center; justify-content: center; cursor: pointer; color: var(--header-blue); font-size: 18px; font-weight: 600; }
        .card-add:hover { background-color: #f8f9fa; }
        .card-pie { display: flex; align-items: center; justify-content: space-between; }
        .pie-stats h2 { margin: 0; font-size: 26px; color: var(--header-blue); }
        .pie-wrapper { width: 110px; height: 110px; }
        .card-graph { flex: 2; display: flex; flex-direction: column; }
        .graph-wrapper { flex: 1; position: relative; width: 100%; height: 100%; }
        .toolbar { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 13px; color: #555; }
        .search-wrapper { position: relative; }
        .search-wrapper input { padding: 6px 10px 6px 30px; border: 1px solid var(--header-blue); border-radius: 4px; width: 200px; outline: none; }
        .search-wrapper i { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: var(--header-blue); }
        table { width: 100%; background: white; border-collapse: collapse; border-radius: 6px; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 15px; }
        thead { background-color: #e0e0e0; }
        th { text-align: left; padding: 10px 15px; font-size: 12px; font-weight: 600; color: #555; border-bottom: 1px solid #ccc; }
        td { padding: 12px 15px; border-bottom: 1px solid #eee; font-size: 13px; vertical-align: middle; }
        .user-flex { display: flex; align-items: center; gap: 10px; }
        .custom-avatar { width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 13px; text-transform: uppercase; flex-shrink: 0; }
        .status-active { color: #28a745; font-weight: 500; }
        .action-icons i { margin-right: 12px; cursor: pointer; color: #777; font-size: 14px; }
        .action-icons i:hover { color: var(--header-blue); }
        .action-icons .fa-trash:hover { color: #dc3545; }
        .pagination-container { display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #555; }
        .pagination { display: flex; gap: 5px; }
        .page-btn { padding: 5px 10px; border: 1px solid #ccc; background: white; cursor: pointer; border-radius: 4px; }
        .page-btn:hover { background: #eee; }
        .page-btn.active { background: var(--header-blue); color: white; border-color: var(--header-blue); }
        .page-btn.disabled { color: #ccc; cursor: not-allowed; }
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 1000; }
        .modal-content { background: white; padding: 25px; border-radius: 8px; width: 600px; max-height: 90vh; overflow-y: auto; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-size: 13px; font-weight: bold; }
        .form-group input, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .full-width { grid-column: span 2; }
        .modal-btns { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-primary { background: var(--header-blue); color: white; }
        .btn-secondary { background: #ccc; color: #333; }
    </style>
</head>
<body>

    <div id="root"></div>

    <script type="text/babel">
        const { useState, useEffect, useRef } = React;
        const API_URL = "http://localhost:8085/api/users";
        const ROWS_PER_PAGE = 15;

        // --- PALETTE CONFIGURATION ---
        const AVATAR_PALETTE = [
            { bg: '#f5f5dc', text: '#333333' }, { bg: '#3e2d23', text: '#ffffff' },
            { bg: '#b22222', text: '#ffffff' }, { bg: '#c7ccd1', text: '#333333' },
            { bg: '#a3b18a', text: '#ffffff' }, { bg: '#102e45', text: '#ffffff' },
            { bg: '#4a3f77', text: '#ffffff' }, { bg: '#0c4da2', text: '#ffffff' },
            { bg: '#d4af37', text: '#ffffff' }, { bg: '#d57a42', text: '#ffffff' }
        ];

        const getAvatarProps = (name) => {
            if (!name) return { initials: '??', style: AVATAR_PALETTE[0] };
            const parts = name.trim().split(/\s+/);
            let initials = parts.length === 1 ? parts[0].substring(0, 2).toUpperCase() : (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
            let hash = 0;
            for (let i = 0; i < name.length; i++) hash = name.charCodeAt(i) + ((hash << 5) - hash);
            return { initials, style: AVATAR_PALETTE[Math.abs(hash) % AVATAR_PALETTE.length] };
        };

        // --- SUB-COMPONENT: USER FORM MODAL ---
        function UserModal({ user, onClose, onSave }) {
            const [formData, setFormData] = useState(user || {
                name: '', email: '', primaryMobile: '', secondaryMobile: '',
                aadhaar: '', pan: '', dateOfBirth: '', placeOfBirth: '',
                currentAddress: '', permanentAddress: '', isActive: true
            });

            const handleChange = (e) => setFormData({...formData, [e.target.name]: e.target.value});

            return (
                <div className="modal-overlay">
                    <div className="modal-content">
                        <h3>{user ? 'Edit User' : 'Add New User'}</h3>
                        <div className="form-grid">
                            <div className="form-group"><label>Full Name</label><input name="name" value={formData.name} onChange={handleChange} /></div>
                            <div className="form-group"><label>Email</label><input name="email" value={formData.email} onChange={handleChange} /></div>
                            <div className="form-group"><label>Primary Mobile</label><input name="primaryMobile" value={formData.primaryMobile} onChange={handleChange} /></div>
                            <div className="form-group"><label>Secondary Mobile</label><input name="secondaryMobile" value={formData.secondaryMobile || ''} onChange={handleChange} /></div>
                            <div className="form-group"><label>Aadhaar</label><input name="aadhaar" value={formData.aadhaar} onChange={handleChange} /></div>
                            <div className="form-group"><label>PAN Card</label><input name="pan" value={formData.pan} onChange={handleChange} /></div>
                            <div className="form-group"><label>DOB</label><input type="date" name="dateOfBirth" value={formData.dateOfBirth} onChange={handleChange} /></div>
                            <div className="form-group"><label>Place</label><input name="placeOfBirth" value={formData.placeOfBirth || ''} onChange={handleChange} /></div>
                            <div className="form-group full-width"><label>Current Address</label><textarea name="currentAddress" rows="2" value={formData.currentAddress || ''} onChange={handleChange}></textarea></div>
                            <div className="form-group full-width"><label>Permanent Address</label><textarea name="permanentAddress" rows="2" value={formData.permanentAddress || ''} onChange={handleChange}></textarea></div>
                        </div>
                        <div className="modal-btns">
                            <button className="btn btn-secondary" onClick={onClose}>Cancel</button>
                            <button className="btn btn-primary" onClick={() => onSave(formData)}>Save User</button>
                        </div>
                    </div>
                </div>
            );
        }

        // --- SUB-COMPONENT: CHARTS ---
        function DashboardCharts({ totalUsers }) {
            const pieRef = useRef(null);
            const lineRef = useRef(null);
            const chartInstances = useRef({});

            useEffect(() => {
                if(chartInstances.current.pie) chartInstances.current.pie.destroy();
                if(chartInstances.current.line) chartInstances.current.line.destroy();

                chartInstances.current.pie = new Chart(pieRef.current, {
                    type: 'pie', data: { datasets: [{ data: [totalUsers, Math.max(0, 100-totalUsers)], backgroundColor: ['#2c3e9e', '#e6e6e6'], borderWidth: 0 }] }, 
                    options: { maintainAspectRatio: false, events: [] }
                });

                chartInstances.current.line = new Chart(lineRef.current, {
                    type: 'line', data: { labels: ['S', 'M', 'T', 'W', 'T', 'F', 'S'], datasets: [{ data: [12, 19, 17, 21, 18, 22, 20], borderColor: '#5c85ff', backgroundColor: 'rgba(92, 133, 255, 0.1)', fill: true, tension: 0.4, pointRadius: 0 }] }, 
                    options: { maintainAspectRatio: false, plugins: { legend: { display: false } }, scales: { x: { display: false }, y: { display: false } } }
                });

                return () => {
                    if(chartInstances.current.pie) chartInstances.current.pie.destroy();
                    if(chartInstances.current.line) chartInstances.current.line.destroy();
                };
            }, [totalUsers]);

            return (
                <div className="widget-row">
                    <div className="card card-add" onClick={() => window.dispatchEvent(new Event('openAddUser'))}>
                        <div><i className="fa-solid fa-user-plus"></i> Add User</div>
                    </div>
                    <div className="card card-pie">
                        <div className="pie-stats"><h2>{totalUsers}</h2><p>Total Users</p></div>
                        <div className="pie-wrapper"><canvas ref={pieRef}></canvas></div>
                    </div>
                    <div className="card card-graph">
                        <div className="graph-wrapper"><canvas ref={lineRef}></canvas></div>
                    </div>
                </div>
            );
        }

        // --- MAIN COMPONENT: DASHBOARD ---
        function Dashboard() {
            const [users, setUsers] = useState([]);
            const [currentPage, setCurrentPage] = useState(1);
            const [totalItems, setTotalItems] = useState(0);
            const [totalPages, setTotalPages] = useState(0);
            const [isModalOpen, setIsModalOpen] = useState(false);
            const [editingUser, setEditingUser] = useState(null);
            
            // KEY CHANGE: Search state triggers API
            const [searchTerm, setSearchTerm] = useState(""); 
            const [debouncedSearch, setDebouncedSearch] = useState("");

            // Debounce the search input (wait 500ms after typing stops)
            useEffect(() => {
                const timer = setTimeout(() => {
                    setDebouncedSearch(searchTerm);
                    setCurrentPage(1); // Reset to page 1 on new search
                }, 500);
                return () => clearTimeout(timer);
            }, [searchTerm]);

            // LOAD DATA: Triggers on Page Change OR Search Change
            useEffect(() => {
                if(!localStorage.getItem("userToken")) window.location.href = "login.jsp";
                fetchUsers(currentPage, debouncedSearch);
                
                const openHandler = () => { setEditingUser(null); setIsModalOpen(true); };
                window.addEventListener('openAddUser', openHandler);
                return () => window.removeEventListener('openAddUser', openHandler);
            }, [currentPage, debouncedSearch]);

            // API CALL: Include Search Param
            const fetchUsers = async (page, query) => {
                try {
                    // Assuming Backend supports search, otherwise modify backend or use client-side logic below
                    // For now, this mimics client-side if backend API doesn't support 'search' param yet.
                    
                    // IF BACKEND HAS SEARCH: const res = await fetch(`${API_URL}?page=${page - 1}&size=${ROWS_PER_PAGE}&keyword=${query}`);
                    
                    // FALLBACK: If backend has NO search param yet, we fetch normal page.
                    // IMPORTANT: To make this work fully server-side, you MUST update Backend Controller.
                    // If you cannot update backend, this JS will behave as before (page-only search).
                    // This code assumes you have added ?keyword= to your backend.
                    
                    let url = `${API_URL}?page=${page - 1}&size=${ROWS_PER_PAGE}`;
                    if(query) {
                        url += `&keyword=${query}`;
                    }

                    const res = await fetch(url);
                    const data = await res.json();
                    
                    // If backend returned filtered data:
                    setUsers(data.content || []);
                    setTotalItems(data.totalElements || 0);
                    setTotalPages(data.totalPages || 0);

                } catch(e) { console.error("Fetch Error", e); }
            };

            const handleDelete = async (id) => {
                if(!confirm("Delete this user?")) return;
                try {
                    const res = await fetch(`${API_URL}/${id}`, { method: 'DELETE' });
                    if(res.ok) fetchUsers(currentPage, debouncedSearch);
                } catch(e) { console.error(e); }
            };

            const handleSave = async (userData) => {
                const isEdit = !!userData.id;
                const url = isEdit ? `${API_URL}/${userData.id}` : API_URL;
                const method = isEdit ? 'PUT' : 'POST';
                try {
                    const res = await fetch(url, {
                        method: method,
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(userData)
                    });

                    if(res.ok) {
                        const savedUser = await res.json();
                        setIsModalOpen(false);
                        // Optimistic UI update
                        setUsers(prevUsers => {
                            const others = prevUsers.filter(u => u.id !== savedUser.id);
                            return [savedUser, ...others];
                        });
                        if (!isEdit) setTotalItems(prev => prev + 1);
                        alert(isEdit ? "User Updated" : "User Created");
                    } else {
    // Try to parse as JSON first
    const text = await res.text();
    try {
        const jsonErr = JSON.parse(text);
        // If it's our new JSON format, show the clean message
        if (jsonErr.error) {
            alert("Error: " + jsonErr.error);
        } else {
            // If it's validation errors (Map), show all
            alert("Validation Error: " + JSON.stringify(jsonErr));
        }
    } catch (e) {
        // If it fails to parse JSON, it's just plain text (Fallback)
        alert("Error: " + text);
    }
}
                } catch(e) { console.error(e); alert("Connection Failed"); }
            };

            const logout = () => { localStorage.removeItem("userToken"); window.location.href = "login.jsp"; };

            const startEntry = (currentPage - 1) * ROWS_PER_PAGE + 1;
            const endEntry = Math.min(currentPage * ROWS_PER_PAGE, totalItems);

            return (
                <div>
                    <div className="navbar">
                        <div className="brand"><i className="fa-solid fa-infinity"></i> OPEN HEARING</div>
                        <div className="user-profile"><span>Admin</span><div className="avatar-circle-admin">A</div><i className="fa-solid fa-power-off" style={{cursor:'pointer', marginLeft:'10px'}} onClick={logout}></i></div>
                    </div>

                    <div className="container">
                        <div className="page-title">Manage Users</div>
                        <DashboardCharts totalUsers={totalItems} />
                        <div className="toolbar">
                            <div className="filter-left">
                                <span>Showing <span>{totalItems > 0 ? startEntry : 0}</span> to <span>{endEntry}</span> of <span>{totalItems}</span> entries</span>
                            </div>
                            <div className="search-wrapper">
                                <i className="fa-solid fa-magnifying-glass"></i>
                                <input type="text" placeholder="Search entire database..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} />
                            </div>
                        </div>

                        <table>
                            <thead>
                                <tr>
                                    <th style={{width:'30px'}}><input type="checkbox"/></th>
                                    <th>Name</th><th>Email</th><th>Mobile</th><th>Aadhaar</th><th>PAN</th><th>Location</th><th>Status</th><th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {users.length === 0 ? 
                                    <tr><td colSpan="9" style={{textAlign:'center', padding:'20px'}}>No users found</td></tr> :
                                    users.map(user => {
                                        const { initials, style } = getAvatarProps(user.name);
                                        return (
                                            <tr key={user.id}>
                                                <td><input type="checkbox"/></td>
                                                <td>
                                                    <div className="user-flex">
                                                        <div className="custom-avatar" style={{backgroundColor: style.bg, color: style.text}}>
                                                            {initials}
                                                        </div>
                                                        <strong>{user.name}</strong>
                                                    </div>
                                                </td>
                                                <td>{user.email}</td><td>{user.primaryMobile}</td><td>{user.aadhaar}</td><td>{user.pan}</td>
                                                <td>{user.placeOfBirth || '-'}</td>
                                                <td><span className="status-active">Active</span></td>
                                                <td className="action-icons">
                                                    <i className="fa-solid fa-pen" onClick={() => { setEditingUser(user); setIsModalOpen(true); }}></i>
                                                    <i className="fa-solid fa-trash" onClick={() => handleDelete(user.id)}></i>
                                                </td>
                                            </tr>
                                        );
                                    })
                                }
                            </tbody>
                        </table>

                        <div className="pagination-container">
                            <div></div>
                            <div className="pagination">
                                <button className={`page-btn ${currentPage === 1 ? 'disabled' : ''}`} onClick={() => setCurrentPage(p => Math.max(1, p - 1))}>Prev</button>
                                {[...Array(totalPages)].map((_, i) => (
                                    <button key={i} className={`page-btn ${currentPage === i + 1 ? 'active' : ''}`} onClick={() => setCurrentPage(i + 1)}>{i + 1}</button>
                                ))}
                                <button className={`page-btn ${currentPage === totalPages || totalPages === 0 ? 'disabled' : ''}`} onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))}>Next</button>
                            </div>
                        </div>
                    </div>

                    {isModalOpen && (
                        <UserModal user={editingUser} onClose={() => setIsModalOpen(false)} onSave={handleSave} />
                    )}
                </div>
            );
        }

        const root = ReactDOM.createRoot(document.getElementById('root'));
        root.render(<Dashboard />);
    </script>
</body>
</html>
