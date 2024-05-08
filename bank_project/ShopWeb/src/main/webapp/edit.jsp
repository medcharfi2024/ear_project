<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Edit Client</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container mt-5">
		<div class="card">
			<div class="card-header bg-primary text-white">
				<h2 class="card-title mb-0">Edit Client</h2>
			</div>
			<div class="card-body">
				<form action="ClientController" method="GET">
					<input type="hidden" name="action" value="update" />
					<div class="form-group row">
						<label for="cin" class="col-sm-3 col-form-label">CIN</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="cin" name="cin"
								value="${client.cin}" readonly>
						</div>
					</div>
					<div class="form-group row">
						<label for="nom" class="col-sm-3 col-form-label">Name</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="nom" name="nom"
								value="${client.nom}">
						</div>
					</div>
					<div class="form-group row">
						<label for="prenom" class="col-sm-3 col-form-label">Second
							Name</label>
						<div class="col-sm-9">
							<input type="text" class="form-control" id="prenom" name="prenom"
								value="${client.prenom}">
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-9 offset-sm-3">
							<button type="submit" class="btn btn-primary">Update</button>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>