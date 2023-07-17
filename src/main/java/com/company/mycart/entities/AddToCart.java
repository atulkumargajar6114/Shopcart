/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.company.mycart.entities;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

@Entity
public class AddToCart {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int aid;
    
    @ManyToOne
    @JoinColumn(name = "userid_user_id")
    private User userid;
    
    @ManyToOne
    private Product productid;
    
    private int quantity;

    public AddToCart(int aid, User userid, Product productid, int quantity) {
        this.aid = aid;
        this.userid = userid;
        this.productid = productid;
        this.quantity = quantity;
    }

    public AddToCart(User userid, Product productid) {
        this.userid = userid;
        this.productid = productid;
        this.quantity=1;
    }

    public AddToCart(User userid, Product productid, int quantity) {
        this.userid = userid;
        this.productid = productid;
        this.quantity = quantity;
    }

    public AddToCart() {
    }

    public int getAid() {
        return aid;
    }

    public void setAid(int aid) {
        this.aid = aid;
    }

    public User getUserid() {
        return userid;
    }

    public void setUserid(User userid) {
        this.userid = userid;
    }

    public Product getProductid() {
        return productid;
    }

    public void setProductid(Product productid) {
        this.productid = productid;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    
    
    
    
    

    @Override
    public String toString() {
        return "AddToCart{" + "aid=" + aid + ", userid=" + userid + ", productid=" + productid + '}';
    }
    
    
    
}
