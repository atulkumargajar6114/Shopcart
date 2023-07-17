/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.company.mycart.dao;

import com.company.mycart.entities.Product;
import org.hibernate.SessionFactory;
import org.hibernate.query.*;
import org.hibernate.Session;
import com.company.mycart.entities.User;
import java.util.List;
import org.hibernate.Transaction;

public class UserDao {

    private SessionFactory factory;

    public UserDao(SessionFactory factory) {
        this.factory = factory;
    }

    //get user by email and password
    public User getUserByEmailAndPassword(String email, String password) {
        User user = null;
        try {
            Session session = this.factory.openSession();
            String query = "from User where userEmail =: e and userPassword =: p";
            Query q = session.createQuery(query);
            q.setParameter("e", email);
            q.setParameter("p", password);
            user = (User) q.uniqueResult();
            session.close();
        } catch (Exception e) {
            e.printStackTrace();

        }

        return user;
    }

    //get all User
    public List<User> getAllUsers() {
        Session s = this.factory.openSession();
        Query query = s.createQuery("from User");
        List<User> list = query.list();
        return list;

    }

//    Edit user data
    public void updateUser(User user, int userId) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = this.factory.openSession();
            transaction = session.beginTransaction();

            // Retrieve the user from the database based on the user ID
            User existingUser = session.get(User.class, userId);
            if (existingUser != null) {
                // Update the user properties with the new values
                existingUser.setUserName(user.getUserName());
                existingUser.setUserEmail(user.getUserEmail());
                existingUser.setUserPassword(user.getUserPassword());
                existingUser.setUserPhone(user.getUserPhone());
                existingUser.setUserAddress(user.getUserAddress());

                // Save the updated user
                session.update(existingUser);

                // Commit the transaction
                transaction.commit();
            }
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

    //get user using user id
    public User getUserById(int userId) {
        User user = null;
        try ( Session session = this.factory.openSession()) {
            user = session.get(User.class, userId);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

//    delete user
    public void deleteUser(int userId) {
        Session session = null;
        Transaction transaction = null;
        try {
            session = this.factory.openSession();
            transaction = session.beginTransaction();
            User user = session.get(User.class, userId);
            if (user != null && "normal".equals(user.getUserType()) ) {
                session.delete(user);
                transaction.commit();
            }
            
        } catch (Exception e) {
            if (transaction != null) {
                transaction.rollback();
            }
        } finally {
            if (session != null) {
                session.close();
            }
        }
    }

}
