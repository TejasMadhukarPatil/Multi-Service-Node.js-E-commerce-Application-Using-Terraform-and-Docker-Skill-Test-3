# Multi-Service-Node.js-E-commerce-Application-Using-Terraform-and-Docker-Skill-Test-3
E-Commerce Microservices Application                                                                                                                                                                      A full-stack MERN e-commerce application built with microservices architecture, featuring 4 separate Node.js backend services and a React frontend.


**Architecture Overview**

This application demonstrates modern microservices architecture with the following components:

Frontend (React) → API Gateway → Microservices
                                    ├── User Service (3001)
                                    ├── Product Service (3002)
                                    ├── Cart Service (3003)
                                    └── Order Service (3004)


                                   **Microservices**

                                   1. User Service (Port 3001)
1] User registration and authentication
2] Profile management
3] JWT token generation and validation
4] User data persistence


                                  2. Product Service (Port 3002)
1] Product catalog management
2] Category management
3] Product search and filtering
4] Inventory tracking


                                  3. Cart Service (Port 3003)
1] Shopping cart management
2] Add/remove/update cart items
3] Cart validation
4] Integration with Product Service


                                  4. Order Service (Port 3004)
1] Order creation and management
2] Payment processing simulation
3] Order status tracking
4] Integration with Cart and Product Services




              **Installation**
             1] Clone the repository
             git clone <repository-url>
             cd ecommerce-microservices

            2] Install dependencies for each service
            
# Install User Service dependencies
cd backend/user-service && npm install

# Install Product Service dependencies
cd ../product-service && npm install

# Install Cart Service dependencies
cd ../cart-service && npm install

# Install Order Service dependencies
cd ../order-service && npm install

# Install Frontend dependencies
cd ../../frontend && npm install

            3]Set up environment variables
            
            backend/user-service/.env:
            PORT=3001
            MONGODB_URI=mongodb://localhost:27017/ecommerce_users
            JWT_SECRET=your-jwt-secret-key

            backend/product-service/.env:
            PORT=3002
            MONGODB_URI=mongodb://localhost:27017/ecommerce_products

            backend/cart-service/.env:
            PORT=3003
            MONGODB_URI=mongodb://localhost:27017/ecommerce_carts
            PRODUCT_SERVICE_URL=http://localhost:3002

            backend/order-service/.env:

            PORT=3004
            MONGODB_URI=mongodb://localhost:27017/ecommerce_orders
            CART_SERVICE_URL=http://localhost:3003
            PRODUCT_SERVICE_URL=http://localhost:3002
            USER_SERVICE_URL=http://localhost:3001

            frontend/.env:
            REACT_APP_USER_SERVICE_URL=http://localhost:3001
            REACT_APP_PRODUCT_SERVICE_URL=http://localhost:3002
            REACT_APP_CART_SERVICE_URL=http://localhost:3003
            REACT_APP_ORDER_SERVICE_URL=http://localhost:3004

           ** Running the Application**

           Terminal 1 - User Service:

           cd backend/user-service && npm start

           Terminal 2 - Product Service:

           cd backend/product-service && npm start

           Terminal 3 - Cart Service:

           cd backend/cart-service && npm start

           Terminal 4 - Order Service:

           cd backend/order-service && npm start

           Terminal 5 - Frontend:

           cd frontend && npm start
**           **The application will be available at:**

1] Frontend: http://localhost:3000/
2] User Service: http://localhost:3001/
3] Product Service: http://localhost:3002
4] Cart Service: http://localhost:3003
5] Order Service: http://localhost:3004


**Docker Deployment**

Each service can be containerized with Docker:

 **Dockerfile for a service**
 
FROM node:16-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY . .

EXPOSE 3001

CMD  ["npm", "start"]
            


