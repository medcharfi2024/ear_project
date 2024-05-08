package tn.enis.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

import tn.enis.entity.Client;
import tn.enis.entity.Compte;
import tn.enis.service.ClientService;
import tn.enis.service.CompteService;

/**
 * Servlet implementation class CompteController
 */
@WebServlet("/CompteController")
public class CompteController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	@EJB
	private CompteService compteService;
	@EJB
	private ClientService clientService;

	public CompteController() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		if (action == null || action.isEmpty()) {
			
			List<Compte> comptes = compteService.findAll();
			request.setAttribute("comptes", comptes);
		} else {
			if ("Add".equals(action)) {
			    String soldeParam = request.getParameter("solde");
			    String cinParam = request.getParameter("cin");

			    if (soldeParam.isEmpty() || cinParam.isEmpty()) {
			        request.setAttribute("errorMessage", "Please fill in all fields.");
			        request.getRequestDispatcher("comptes.jsp").forward(request, response);
			        return;
			    }

			    float solde = Float.parseFloat(soldeParam);
			    Client client = clientService.findById(cinParam);

			    if (client == null) {
			        request.setAttribute("errorMessage", "Client not found.");
			        request.getRequestDispatcher("comptes.jsp").forward(request, response);
			        return;
			    }

			    Compte compte = new Compte(solde, client);
			    compteService.save(compte);
			    response.sendRedirect("CompteController");
			    return;
			}else if ("Delete".equals(action)) {
				
				Long rib = Long.parseLong(request.getParameter("rib"));
				compteService.delete(rib);
				response.sendRedirect("CompteController?action=ShowList"); // Redirect to show the list of comptes
				return;
			}
		

		if ("search".equals(action)) {
			String name = request.getParameter("search");
			if (name != null && !name.isEmpty()) {
				List<Client> clients = clientService.findAllByNomClient(name);
				List<Compte> searchedComptes = compteService.findCompteByClient(clients);
				request.setAttribute("comptes", searchedComptes);
				request.getRequestDispatcher("comptes.jsp").forward(request, response);
			} else {
				response.sendRedirect("comptes.jsp");
				return;
			}
		} else if ("UpdateSolde".equals(action)) {
			// Handle updating the balance of an account
			Long rib = Long.parseLong(request.getParameter("rib"));
			float newSolde = Float.parseFloat(request.getParameter("newSolde"));
			compteService.updateSolde(rib, newSolde);
			response.sendRedirect("CompteController");
			return;
		} else if ("ShowList".equals(action)) {
			List<Compte> allComptes = compteService.findAll();
			request.setAttribute("comptes", allComptes);
			request.getRequestDispatcher("comptes.jsp").forward(request, response);
		} else if ("getClients".equalsIgnoreCase(action)) {
		    List<Client> clients = clientService.findAll();

		    JSONArray clientsArray = new JSONArray();
		    for (Client client : clients) {
		        String cin_hidden = client.getCin().substring(Math.max(client.getCin().length() - 4, 0));
		        String mid = client.getPrenom() + " " + client.getNom() + " " + "****" + cin_hidden;
		        JSONObject clientObject = new JSONObject();
		        clientObject.put("value", mid);
		        clientObject.put("item", client.getCin());
		        clientsArray.put(clientObject);
		    }

		    response.setContentType("application/json");
		    PrintWriter out = response.getWriter();
		    out.print(clientsArray.toString());
		    out.flush();
		}
		
		}request.getRequestDispatcher("comptes.jsp").forward(request, response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
