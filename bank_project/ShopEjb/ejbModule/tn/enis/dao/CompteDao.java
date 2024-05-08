package tn.enis.dao;

import java.util.List;

import javax.ejb.LocalBean;
import javax.ejb.Singleton;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;

import tn.enis.entity.Client;
import tn.enis.entity.Compte;

/**
 * Session Bean implementation class CompteDao
 */
@Singleton
@LocalBean
public class CompteDao {

	@PersistenceContext
	private EntityManager entityManager;

	public void save(Compte compte) {
		entityManager.persist(compte);
	}

	public Compte findById(Long rib) {
		return entityManager.find(Compte.class, rib);
	}

	public void delete(Compte compte) {
		entityManager.remove(compte);
	}

	public void update(Compte compte) {
		entityManager.merge(compte);
	}

	public List<Compte> findAll() {
		// langage = EJB-QL, != SQL;
		// EJB-QL =~ SQL orient� Objet, on utilise le nom de l'entit� et non de la table
		return entityManager.createQuery("select c from Compte c", Compte.class).getResultList();
	}

	public List<Compte> findByCin(String cin) {
		return entityManager.createQuery("select c from Compte c where c.client.cin = :cin", Compte.class)
				.setParameter("cin", cin).getResultList();
	}
	public List<Compte> findCompteByClient(List<Client> clients) {
		return entityManager.createQuery("select c from Compte c where c.client in :clients", Compte.class)
				.setParameter("clients", clients).getResultList();
	}

	public List<Compte> findAllByClient(List<Client> clients) {
	    // Requ�te JPQL pour s�lectionner les comptes associ�s � la liste de clients sp�cifi�e
	    return entityManager.createQuery(
	            "SELECT c FROM Compte c WHERE c.client IN :clients", Compte.class)
	            .setParameter("clients", clients)
	            .getResultList();
	}
	  public List<Compte> findByClient(Client client) {
	        return findAllByClient(List.of(client));
	    }
	  public void deleteClientAndAccounts(String cin) {
		    // R�cup�rer le client
		    Client client = entityManager.find(Client.class, cin);
		    
		    if (client != null) {
		        // Supprimer tous les comptes associ�s au client
		        entityManager.createQuery("DELETE FROM Compte c WHERE c.client = :client")
		                     .setParameter("client", client)
		                     .executeUpdate();
		        // Supprimer le client
		        entityManager.remove(client);
		    }
		}
}