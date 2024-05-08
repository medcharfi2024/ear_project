package tn.enis.controller;

import java.io.IOException;
import java.util.List;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import tn.enis.entity.Client;
import tn.enis.service.ClientService;
import tn.enis.service.CompteService;

/**
 * Servlet implementation class ShopController
 */
@WebServlet("/ClientController")
public class ClientController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@EJB
	private ClientService clientService;
	@EJB
	private CompteService compteService;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		if ("add".equals(action)) {
			String cin = request.getParameter("cin");
			String nom = request.getParameter("nom");
			String prenom = request.getParameter("prenom");
			if (cin.length() != 8 || !cin.matches("\\d{8}")) {
				response.sendRedirect("ClientController?action=list&error=invalidCinLength");
				return;
			}
			if (clientService.findById(cin) != null) {
				request.setAttribute("existingClient", true);
			} else {
				Client client = new Client(cin, nom, prenom);
				clientService.save(client);
			}

			response.sendRedirect("ClientController?action=list");
		} else if ("list".equals(action)) {
			List<Client> clients = clientService.findAll();
			request.setAttribute("clients", clients);
			request.getRequestDispatcher("clients.jsp").forward(request, response);
		} else if ("Delete".equals(request.getParameter("action"))) {
			String cin = request.getParameter("cin");
			compteService.deleteClientAndAccounts(cin);
			clientService.delete(cin);
			response.sendRedirect("ClientController?action=list");
			return;
		} else if ("search".equals(action)) {
			String search = request.getParameter("search");
			if (search != null && !search.isEmpty()) {
				List<Client> searchedClients = clientService.findAllByNomClient(search);
				request.setAttribute("clients", searchedClients);
				request.getRequestDispatcher("clients.jsp").forward(request, response);
			} else {

				response.sendRedirect("clients.jsp");
			}

		} else if ("edit".equals(action)) {
			
			String cin = request.getParameter("cin");
			Client client = clientService.findById(cin);
			request.setAttribute("client", client);
			request.getRequestDispatcher("edit.jsp").forward(request, response);
		} else if ("update".equals(action)) {
			
			String cin = request.getParameter("cin");
			String nom = request.getParameter("nom");
			String prenom = request.getParameter("prenom");
			Client client = new Client(cin, nom, prenom);
			clientService.update(client);

			
			response.sendRedirect("ClientController?action=list");
		} else {
			
			
			response.sendRedirect("ClientController?action=list");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

}