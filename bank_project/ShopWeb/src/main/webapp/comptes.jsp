<%@page import="tn.enis.entity.Compte"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Account Interface</title>
<link
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/2.1.2/sweetalert.min.js"></script>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="#">BANK</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav">
				<li class="nav-item"><a class="nav-link"
					href="ClientController?action=list">Clients</a></li>
				<li class="nav-item"><a class="nav-link"
					href="CompteController?action=list">Accounts</a></li>
			</ul>
		</div>
	</nav>
	<div class="container">
		<h1>Account List</h1>
		<form action="CompteController" method="post">
			<div class="form-row">
				<div class="form-group col-md-2">
					<label for="solde">Solde</label> <input type="text"
						class="form-control" id="solde" name="solde">
				</div>
				<div class="form-group col-md-2">
					<label for="cin">Client (CIN)</label> <input type="hidden"
						id="Add_name_hidden" name="cinClient"> <input type="text"
						class="form-control" id="cin" name="cin">
				</div>
				<div class="form-group col-md-2 align-self-end">
					<label>&nbsp;</label> <input type="submit" class="btn btn-primary"
						name="action" value="Add">
				</div>
			</div>
		</form>
		<hr />
		<form action="CompteController" method="post">
			<div class="form-row">
				<div class="form-group col-md-3">
					<label for="search">Search Client</label> <input type="text"
						class="form-control" id="search" name="search">
				</div>
				<div class="form-group col-md-2 align-self-end">
					<label>&nbsp;</label> <input type="submit" class="btn btn-primary"
						name="action" value="search">
				</div>
			</div>
		</form>
		<form action="CompteController" method="post">
			<input type="hidden" name="action" value="ShowList"> <input
				type="submit" class="btn btn-primary" value="Show List">
		</form>
		<table class="table">
			<thead>
				<tr>
					<th>RIB</th>
					<th>Solde</th>
					<th>Client</th>
					<th>Action</th>
				</tr>
			</thead>
			<tbody>
				<%
				List<Compte> comptes = (List<Compte>) request.getAttribute("comptes");
				if (comptes != null && !comptes.isEmpty()) {
					for (Compte compte : comptes) {
				%>
				<tr>
					<td><%=compte.getRib()%></td>
					<td><%=compte.getSolde()%></td>
					<td><%=compte.getClient().getNom() + " " + compte.getClient().getPrenom()%></td>
					<td>
						<form action="CompteController" method="post">
							<input type="hidden" name="rib" value="<%=compte.getRib()%>">
							<input type="number" name="newSolde"
								value="<%=compte.getSolde()%>"> <input type="submit"
								class="btn btn-primary" name="action" value="UpdateSolde">
							<button type="button" class="btn btn-danger delete-btn">Delete</button>
						</form>
					</td>
				</tr>
				<%
				}
				}
				%>
			</tbody>
		</table>
	</div>
	<script>
$(document).ready(function() {
    $(document).on("click", ".delete-btn", function() {
        var rib = $(this).closest("form").find('input[name="rib"]').val();
        var deleteForm = $(this).closest("form");
        swal({
            title: "Are you certain?",
            text: "You won't be able to recover this account!",
            icon: "warning",
            buttons: {
                cancel: "Cancel",
                confirm: {
                    text: "Delete",
                    value: true,
                    visible: true,
                    className: "delete-btn"
                }
            },
            dangerMode: true,
        }).then((willDelete) => {
            if (willDelete) {
                $.ajax({
                    url: "CompteController",
                    type: "POST",
                    data: {
                        action: "Delete",
                        rib: rib
                    },
                    success: function() {
                        deleteForm.closest("tr").remove();
                        swal("Compte supprimé!", {
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

    // Autocomplete for Client ID
    $.ajax({
        url: "CompteController",
        method: "GET",
        data: { action: "getClients" },
        dataType: "json",
        success: function(data) {
            $("#cin").autocomplete({
                source: function(request, response) {
                    var filteredData = $.map(data, function(item) {
                        return {
                            label: item.value,
                            value: item.item
                        };
                    });
                    response(filteredData);
                },
                select: function(event, ui) {
                    $("#Add_name_hidden").val(ui.item.value);
                }
            });
        },
        error: function(xhr, status, error) {
            console.error(xhr.responseText);
        }
    });
    $('#solde').on('input', function() {
        $(this).val(function(i, val) {
            return val.replace(/[^0-9.]/g, '');
        });
    });
});
</script>

</body>
</html>