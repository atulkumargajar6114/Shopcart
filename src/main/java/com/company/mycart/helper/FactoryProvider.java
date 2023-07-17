/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.company.mycart.helper;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class FactoryProvider {

    private static SessionFactory factory;

    public static SessionFactory getFactory() {
        try {
            if (factory == null) {
                Configuration cfg = new Configuration();
                cfg.configure("hibernate.cfg.xml");
                factory = cfg.buildSessionFactory();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return factory;
    }
}
