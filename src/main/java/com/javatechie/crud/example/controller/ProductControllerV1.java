package com.javatechie.crud.example.controller;

import com.javatechie.crud.example.entity.Product;
import com.javatechie.crud.example.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")  // Version 1.0 API
public class ProductControllerV1 {

    @Autowired
    private ProductService service;

    @GetMapping("/health")
    public String healthCheck() {
        return "Service is running";
    }

    @GetMapping("/products")
    public List<Product> findAllProducts() {
        return service.getProducts();
    }
}
