package com.example.demo1.controller.cart;

import com.example.demo1.model.CartItem;
import com.example.demo1.model.Product;
import com.example.demo1.model.User;
import com.example.demo1.service.CartService;
import com.example.demo1.service.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AddCartController", value = "/AddCart")
public class AddCartController extends HttpServlet {
    private final CartService cartService = new CartService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath()+"/login");
            return;
        }

        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        try {
            int id = (request.getParameter("id") != null) ? Integer.parseInt(request.getParameter("id")) : 0;

            if ("add".equals(action)) {
                Product product = productService.getProduct(id);

                int currentQty = (cart.containsKey(id)) ? cart.get(id).getQuantity() : 0;
                int totalDesired = currentQty + 1;

                if (product != null && totalDesired > product.getStock()) {
                    session.setAttribute("cartError", "Không thể thêm. Sản phẩm " + product.getName() + " chỉ còn " + product.getStock() + " cái.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                cartService.addToCart(cart, id, 1);
                response.sendRedirect("AddCart?action=view");
            }

            else if ("update".equals(action)) {
                int num = Integer.parseInt(request.getParameter("num"));

                Product product = productService.getProduct(id);
                CartItem currentItem = cart.get(id);
                int currentQtyInCart = (currentItem != null) ? currentItem.getQuantity() : 0;

                int futureQuantity = currentQtyInCart + num;

                if (num > 0 && product != null && futureQuantity > product.getStock()) {
                    session.setAttribute("cartError", "Không thể tăng. Kho chỉ còn " + product.getStock() + " sản phẩm.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                cartService.updateQuantity(cart, id, num);
                response.sendRedirect("AddCart?action=view");
            }
            else if ("delete".equals(action)) {
                cartService.removeItem(cart, id);
                response.sendRedirect("AddCart?action=view");
            }
            else if ("buyNow".equals(action)) {
                Product product = productService.getProduct(id);
                int currentQty = (cart.containsKey(id)) ? cart.get(id).getQuantity() : 0;

                if (product != null && (currentQty + 1) > product.getStock()) {
                    session.setAttribute("cartError", "Sản phẩm " + product.getName() + " đã hết hàng hoặc không đủ số lượng.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                cartService.addToCart(cart, id, 1);
                response.sendRedirect("AddCart?action=checkout");
            }
            else if ("view".equals(action)) {
                request.setAttribute("totalAmount", cartService.calculateTotal(cart));
                request.getRequestDispatcher("/cart.jsp").forward(request, response);
            }
            else if ("checkout".equals(action)) {
                if (cart == null || cart.isEmpty()) {
                    session.setAttribute("cartError", "Giỏ hàng của bạn đang trống. Vui lòng thêm sản phẩm trước khi đặt hàng.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                double total = cartService.calculateTotal(cart);
                request.setAttribute("totalAmount", total);
                request.getRequestDispatcher("/thanhToan.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
}