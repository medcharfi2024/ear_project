package tn.enis.service;

import java.util.List;

import javax.ejb.EJB;
import javax.ejb.LocalBean;
import javax.ejb.Stateful;
import javax.ejb.Stateless;

import tn.enis.dao.ClientDao;
import tn.enis.dao.CompteDao;
import tn.enis.entity.Client;
import tn.enis.entity.Compte;

@Stateless
@LocalBean
public class CompteService {

    @EJB
    private CompteDao compteDao;
    
    @EJB
    private ClientDao clientDao; // Injection de ClientDao

    public void save(Compte compte) {
        compteDao.save(compte);
    }

    public void update(Compte compte) {
        compteDao.update(compte);
    }

    public void delete(Compte compte) {
        compteDao.delete(compte);
    }

    public Compte findById(Long rib) {
        return compteDao.findById(rib);
    }

    public List<Compte> findAll() {
        return compteDao.findAll();
    }

    public List<Compte> findByCin(String cin) {
        return compteDao.findByCin(cin);
    }

    public void delete(Long rib) {
        delete(findById(rib));
    }

    public List<Compte> findCompteByClient(List<Client> clients) {
        return compteDao.findCompteByClient(clients);
    }

    public void updateSolde(Long rib, float newSolde) {
        Compte compte = findById(rib);
        if (compte != null) {
            compte.setSolde(newSolde);
            update(compte);
        }
    }

    public List<Compte> findByClient(Client client) {
        return compteDao.findByClient(client);
    }

    public void deleteClientAndAccounts(String cin) {
        List<Compte> comptes = compteDao.findByCin(cin);
        for (Compte compte : comptes) {
            compteDao.delete(compte);
        }
    }
    }