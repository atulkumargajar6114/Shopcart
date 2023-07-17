/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.company.mycart.dao;
 
import org.hibernate.SessionFactory;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.company.mycart.entities.AddToCart;
import java.util.List;
import org.hibernate.query.Query;

public class AddToCartDao {
    private SessionFactory factory;

    public AddToCartDao(SessionFactory factory) {
        this.factory = factory;
    }
    
    public boolean saveATD(AddToCart addToCart){
        boolean f=false;
        try {
            Session session=this.factory.openSession();
            Transaction tx=session.beginTransaction();
            session.saveOrUpdate(addToCart);
            tx.commit();
            session.close();
            f=true;
        } catch (Exception e) {
            e.printStackTrace();
            f=false;
        }
    return f;
    
    }
    public List<AddToCart> getCartItemsByUserId(int userId) {
    Session session = this.factory.openSession();
    Transaction tx = null;
    List<AddToCart> cartItems = null;

    try {
        tx = session.beginTransaction();
        String hql = "FROM AddToCart WHERE userid.id = :userId";
        Query query = session.createQuery(hql);
        query.setParameter("userId", userId);
        cartItems = query.list();
        tx.commit();
    } catch (Exception e) {
        if (tx != null) {
            tx.rollback();
        }
        e.printStackTrace();
    } finally {
        session.close();
    }

    return cartItems;
}
   public boolean deleteATD(AddToCart item){
       boolean success=false;
       Session session=this.factory.openSession();
       Transaction tx=null;
       try {
           tx=session.beginTransaction();
           int quantity=item.getQuantity();
           quantity--;
           item.setQuantity(quantity);
           if(quantity==0){
               session.delete(item);
           }else{
           session.update(item);
           }
           tx.commit();
           success=true;
       } catch (Exception e) {
           if(tx!=null){
               tx.rollback();
           }
           e.printStackTrace();
           success=false;
       }finally{
           session.close();
       }
       return success;
   }

    
}
