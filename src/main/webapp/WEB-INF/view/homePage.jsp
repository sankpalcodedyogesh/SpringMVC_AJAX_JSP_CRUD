<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.app.entity.User"%>
<%
User user = (User) session.getAttribute("loggedInUser");
String role = (user != null) ? user.getRole() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Student Records</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script type="text/javascript">
        $(document).ready(function () {
            loadTable();

            $('#cancleBtn, #crossBtn').click(function () {
                $('#addStudentForm input').removeClass('is-invalid');
            });

            $('#saveStudentBtn').click(function () {
                var name = $('#addStudentName').val().trim();
                var email = $('#addStudentEmail').val().trim();
                var address = $('#addStudentAddress').val().trim();

                var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                var nameRegex = /^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$/;
                var addressRegex = /^[a-zA-Z0-9\s,'-\.#]+$/;

                $('#addStudentForm input').removeClass('is-invalid');

                let isValid = true;
                if (!name || !nameRegex.test(name)) { $('#addStudentName').addClass('is-invalid'); isValid = false; }
                if (!email || !emailRegex.test(email)) { $('#addStudentEmail').addClass('is-invalid'); isValid = false; }
                if (!address || !addressRegex.test(address)) { $('#addStudentAddress').addClass('is-invalid'); isValid = false; }

                if (!isValid) return;

                var student = { name, email, address };

                $.ajax({
                    url: 'students/saveStudent',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(student),
                    success: function () {
                        $('#addStudentModal').modal('hide');
                        alert("Student added successfully.");
                        $('#addStudentForm')[0].reset();
                        loadTable();
                    },
                    error: function () {
                        alert("Error adding student.");
                    }
                });
            });
        });

        function loadTable() {
            $.ajax({
                url: 'students/studentList',
                type: 'GET',
                dataType: 'json',
                success: function (data) {
                    var rows = '';
                    for (var i = 0; i < data.length; i++) {
                        var student = data[i];
                        var id = student.id || '';
                        var name = student.name || '';
                        var email = student.email || '';
                        var address = student.address || '';
                        var serial = i + 1;

                        rows += '<tr data-id="' + id + '">' +
                            '<td>' + serial + '</td>' +
                            '<td>' + name + '</td>' +
                            '<td>' + email + '</td>' +
                            '<td>' + address + '</td>' +
                            '<td>';
                        <%if ("ADMIN".equals(role)) {%>
                            rows += '<button class="btn btn-primary btn-sm editBtn">Edit</button> ' +
                                    '<button class="btn btn-danger btn-sm" onclick="deleteStudent(' + id + ')">Delete</button>';
                        <%} else {%>
                            rows += '<span class="text-muted">Restricted</span>';
                        <%}%>
                        rows += '</td></tr>';
                    }
                    $('#studentTableBody').html(rows);
                    bindEditEvents();
                },
                error: function (xhr, status, error) {
                    console.error("Error loading data:", error);
                }
            });
        }

        function deleteStudent(id) {
            if (confirm("Are you sure you want to delete this student?")) {
                $.ajax({
                    url: 'student/deleteStudent/' + id,
                    type: 'DELETE',
                    success: function () {
                        alert("Student deleted successfully.");
                        loadTable();
                    },
                    error: function (xhr) {
                        alert("Error deleting student: " + xhr.responseText);
                    }
                });
            }
        }

        function bindEditEvents() {
            $('.editBtn').click(function () {
                var row = $(this).closest('tr');
                var id = row.data('id');
                var name = row.find('td').eq(1).text().trim();
                var email = row.find('td').eq(2).text().trim();
                var address = row.find('td').eq(3).text().trim();

                $('#editStudentId').val(id);
                $('#editStudentName').val(name);
                $('#editStudentEmail').val(email);
                $('#editStudentAddress').val(address);
                $('#editStudentForm input').removeClass('is-invalid');

                var modal = new bootstrap.Modal(document.getElementById('editStudentModal'));
                modal.show();
            });

            $('#updateStudentBtn').off('click').on('click', function () {
                var id = $('#editStudentId').val();
                var name = $('#editStudentName').val().trim();
                var email = $('#editStudentEmail').val().trim();
                var address = $('#editStudentAddress').val().trim();

                var emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                var nameRegex = /^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$/;
                var addressRegex = /^[a-zA-Z0-9\s,'-\.#]+$/;

                $('#editStudentForm input').removeClass('is-invalid');

                let isValid = true;
                if (!name || !nameRegex.test(name)) { $('#editStudentName').addClass('is-invalid'); isValid = false; }
                if (!email || !emailRegex.test(email)) { $('#editStudentEmail').addClass('is-invalid'); isValid = false; }
                if (!address || !addressRegex.test(address)) { $('#editStudentAddress').addClass('is-invalid'); isValid = false; }

                if (!isValid) return;

                var student = { id, name, email, address };

                $.ajax({
                    url: 'student/updateStudent',
                    type: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify(student),
                    success: function () {
                        var modalEl = document.getElementById('editStudentModal');
                        var modal = bootstrap.Modal.getInstance(modalEl);
                        modal.hide();

                        alert("Student updated successfully.");
                        loadTable();
                    },
                    error: function () {
                        alert("Error updating student.");
                    }
                });
            });
        }

        function filterTable() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var rows = document.getElementById("studentTableBody").getElementsByTagName("tr");

            for (var i = 0; i < rows.length; i++) {
                var name = rows[i].cells[1].innerText.toLowerCase();
                var email = rows[i].cells[2].innerText.toLowerCase();
                var address = rows[i].cells[3].innerText.toLowerCase();

                if (name.includes(filter) || email.includes(filter) || address.includes(filter)) {
                    rows[i].style.display = "";
                } else {
                    rows[i].style.display = "none";
                }
            }
        }
    </script>
</head>
<body>
	<div class="container mt-4">
		<h2 class="mb-4 text-center">Student Records</h2>

		<div class="mb-3 d-flex justify-content-between align-items-center">
			<input type="text" id="searchInput" class="form-control w-25"
				placeholder="Search..." onkeyup="filterTable()" />

			<div class="d-flex">
				<%
				if ("ADMIN".equals(role)) {
				%>
				<button class="btn btn-outline-success me-2" data-bs-toggle="modal"
					data-bs-target="#addStudentModal">Add New Student</button>
				<%
				}
				%>
				<form action="${pageContext.request.contextPath}/logout"
					method="get">
					<button type="submit" class="btn btn-outline-danger">Logout</button>
				</form>
			</div>
		</div>



		<table class="table table-bordered table-hover">
			<thead class="table-dark">
				<tr>
					<th>#</th>
					<th>Name</th>
					<th>Email</th>
					<th>Address</th>
					<th>Actions</th>
				</tr>
			</thead>
			<tbody id="studentTableBody"></tbody>
		</table>
	</div>

	<!-- Edit Student Modal -->
	<div class="modal fade" id="editStudentModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Edit Student</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<form id="editStudentForm">
						<input type="hidden" id="editStudentId">
						<div class="mb-3">
							<label class="form-label">Name</label> <input type="text"
								class="form-control" id="editStudentName">
							<div class="invalid-feedback">Please enter a valid name.</div>
						</div>
						<div class="mb-3">
							<label class="form-label">Email</label> <input type="email"
								class="form-control" id="editStudentEmail">
							<div class="invalid-feedback">Please enter a valid email.</div>
						</div>
						<div class="mb-3">
							<label class="form-label">Address</label> <input type="text"
								class="form-control" id="editStudentAddress">
							<div class="invalid-feedback">Please enter a valid address.</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
					<button class="btn btn-success" id="updateStudentBtn">Update</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Add Student Modal -->
	<div class="modal fade" id="addStudentModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Add Student</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						id="crossBtn"></button>
				</div>
				<div class="modal-body">
					<form id="addStudentForm">
						<div class="mb-3">
							<label class="form-label">Name</label> <input type="text"
								class="form-control" id="addStudentName">
							<div class="invalid-feedback">Please enter a valid name.</div>
						</div>
						<div class="mb-3">
							<label class="form-label">Email</label> <input type="email"
								class="form-control" id="addStudentEmail">
							<div class="invalid-feedback">Please enter a valid email.</div>
						</div>
						<div class="mb-3">
							<label class="form-label">Address</label> <input type="text"
								class="form-control" id="addStudentAddress">
							<div class="invalid-feedback">Please enter a valid address.</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button class="btn btn-secondary" data-bs-dismiss="modal"
						id="cancleBtn">Cancel</button>
					<button class="btn btn-primary" id="saveStudentBtn">Save</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>
