<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="tn.enis.entity.Client"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Client Interface</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="#">BANK</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="ClientController?action=list">Clients</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="CompteController?action=list">Accounts</a>
                </li>
            </ul>
        </div>
    </nav>

	<div class="container">
		<h1>Add Client</h1>
		<form id="addClientForm" action="ClientController" method="POST">
			<div class="form-group">
				<label for="cin">CIN</label> <input type="text" class="form-control"
					id="cin" name="cin" pattern="[0-9]*"
					title="Please enter only numeric characters"
					oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
			</div>
			<div class="form-group">
				<label for="nom">Name</label> <input type="text"
					class="form-control" id="nom" name="nom" pattern="[A-Za-z]+"
					title="Please enter only alphabetical characters"
					oninput="this.value = this.value.replace(/[^A-Za-z]/g, '')"
					required>
			</div>
			<div class="form-group">
				<label for="prenom">Second Name</label> <input type="text"
					class="form-control" id="prenom" name="prenom" pattern="[A-Za-z]+"
					title="Please enter only alphabetical characters"
					oninput="this.value = this.value.replace(/[^A-Za-z]/g, '')"
					required>
			</div>
			<button type="submit" class="btn btn-primary" name="action"
				value="add">Add</button>
		</form>
		<form action="ClientController" method="GET">
			<input type="hidden" name="action" value="search" />
			<div class="form-group">
				<label for="search">Search</label> <input type="text"
					class="form-control" id="search" name="search">
			</div>
			<button type="submit" class="btn btn-primary">Search</button>
		</form>
		<form action="ClientController" method="GET">
			<input type="hidden" name="action" value="list" />
			<button type="submit" class="btn btn-primary">Show List</button>
		</form>
		<h1>Client List</h1>
		<table id="clientsTable" class="table table-bordered">
			<thead>
				<tr>
					<th>CIN</th>
					<th>Name</th>
					<th>Second Name</th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${clients}" var="client">
					<tr id="tr${client.cin}">
						<td>${client.cin}</td>
						<td>${client.nom}</td>
						<td>${client.prenom}</td>
						<td>
							<form id="deleteForm${client.cin}" class="delete-form">
								<input type="hidden" name="action" value="Delete" /> <input
									type="hidden" name="cin" value="${client.cin}" />
								<button type="button" class="btn btn-danger delete-btn">Delete</button>
							</form>
							<form action="ClientController" method="GET">
								<input type="hidden" name="action" value="edit" /> <input
									type="hidden" name="cin" value="${client.cin}" />
								<button type="submit" class="btn btn-warning">Edit</button>
							</form>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<%
	if (request.getAttribute("invalidCinLength") != null) {
	%>
	<div class="alert alert-danger" role="alert">CIN must be exactly
		8 digits.</div>
	<%
	}
	%>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
	<script>
    $(document).ready(function() {
        $(document).on("click", ".delete-btn", function() {
            var cin = $(this).closest("form").find('input[name="cin"]').val();
            swal({
                title: "Are you certain?",
                text: "You won't be able to recover this customer!",
                icon: "warning",
                buttons: ["Cancel", "Delete"],
                dangerMode: true,
            })
            .then((willDelete) => {
                if (willDelete) {
                    $.ajax({
                        url: "ClientController",
                        type: "POST",
                        data: {
                            action: "Delete",
                            cin: cin
                        },
                        success: function() {
                            $("#tr" + cin).remove();
                            swal("Client supprimé!", {
                                icon: "success",
                            });
                        },
                        error: function() {
                            swal("Serveur Error!", {
                                icon: "error",
                            });
                        }
                    });
                } else {
                    swal("Cancel delete!", {
                        icon: "info",
                    });
                }
            });
        });
        $.ajax({
            url: "CompteController",
            method: "GET",
            data:{action : "getClients"},
            dataType: "json",
            success: function(data) {
                //console.log(data);        
                $("#Add_name").autocomplete({
                    source: data,
                    select: function(event, ui) {
                        // Set the value of the hidden input field
                        $("#Add_name_hidden").val(ui.item.item);


                    }
                });
            },
            error: function(xhr, status, error) {
                console.error(xhr.responseText);
            }
        });
        $.ajax({
            url: "CompteController",
            method: "GET",
            data:{action : "getClients"},
            dataType: "json",
            success: function(data) {
                //console.log(data);        
                $("#Add_name").autocomplete({
                    source: data,
                    select: function(event, ui) {
                        // Set the value of the hidden input field
                        $("#Add_name_hidden").val(ui.item.item);


                    }
                });
            },
            error: function(xhr, status, error) {
                console.error(xhr.responseText);
            }
        });


    });
    </script>
   
    
</body>
</html>
