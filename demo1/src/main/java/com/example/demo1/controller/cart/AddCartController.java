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
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = user.getId();

        try {
            int id = (request.getParameter("id") != null) ? Integer.parseInt(request.getParameter("id")) : 0;

            if ("add".equals(action)) {
                Product product = productService.getProduct(id);
                int totalItemsCount = cartService.countItems(userId);

                if (totalItemsCount >= 99) {
                    session.setAttribute("cartError", "Giỏ hàng đã đầy! Giỏ hàng chỉ chứa tối đa 99 loại sản phẩm.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                List<CartItem> currentItems = cartService.getCartItems(userId);
                int currentQty = 0;
                for (CartItem item : currentItems) {
                    if (item.getProduct().getId() == id) {
                        currentQty = item.getQuantity();
                        break;
                    }
                }
                int totalDesired = currentQty + 1;

                if (product != null && totalDesired > product.getStock()) {
                    session.setAttribute("cartError", "Không thể thêm. Sản phẩm " + product.getName() + " chỉ còn " + product.getStock() + " cái.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                cartService.addToCart(userId, id, 1);
                response.sendRedirect("AddCart?action=view");
            }
            else if ("update".equals(action)) {
                int num = Integer.parseInt(request.getParameter("num"));
                Product product = productService.getProduct(id);

                List<CartItem> currentItems = cartService.getCartItems(userId);
                int currentQtyInCart = 0;
                for (CartItem item : currentItems) {
                    if (item.getProduct().getId() == id) {
                        currentQtyInCart = item.getQuantity();
                        break;
                    }
                }

                int futureQuantity = currentQtyInCart + num;

                if (num > 0 && product != null && futureQuantity > product.getStock()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Kho chỉ còn " + product.getStock() + " sản phẩm.");                    return;
                }

                cartService.updateQuantity(userId, id, num);
                response.sendRedirect("AddCart?action=view");
            }
            else if ("delete".equals(action)) {
                cartService.removeItem(userId, id);
                response.sendRedirect("AddCart?action=view");
            }
            else if ("buyNow".equals(action)) {
                Product product = productService.getProduct(id);

                List<CartItem> currentItems = cartService.getCartItems(userId);
                int currentQty = 0;
                for (CartItem item : currentItems) {
                    if (item.getProduct().getId() == id) {
                        currentQty = item.getQuantity();
                        break;
                    }
                }

                int totalItemsCount = cartService.countItems(userId);
                if (totalItemsCount >= 99) {
                    session.setAttribute("cartError", "Giỏ hàng đã đầy! Giỏ hàng chỉ chứa tối đa 99 loại sản phẩm.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                if (product != null && (currentQty + 1) > product.getStock()) {
                    session.setAttribute("cartError", "Sản phẩm " + product.getName() + " đã hết hàng hoặc không đủ số lượng.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                cartService.addToCart(userId, id, 1);
                response.sendRedirect("AddCart?action=checkout&ids=" + id);
            }
            else if ("view".equals(action)) {
                List<CartItem> cartItems = cartService.getCartItems(userId);
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("totalAmount", cartService.calculateTotal(userId));
                request.getRequestDispatcher("/cart.jsp").forward(request, response);
            }
            else if ("checkout".equals(action)) {
                List<CartItem> cartItems = cartService.getCartItems(userId);
                String idsParam = request.getParameter("ids");

                if (cartItems == null || cartItems.isEmpty()) {
                    session.setAttribute("cartError", "Giỏ hàng của bạn đang trống. Vui lòng thêm sản phẩm trước khi đặt hàng.");
                    response.sendRedirect("AddCart?action=view");
                    return;
                }

                double total = 0;

                if (idsParam != null && !idsParam.isEmpty()) {
                    Set<Integer> selectedIds = new HashSet<>();
                    for (String idStr : idsParam.split(",")) {
                        selectedIds.add(Integer.parseInt(idStr.trim()));
                    }

                    List<CartItem> filteredItems = new ArrayList<>();

                    for (CartItem item : cartItems) {
                        if (selectedIds.contains(item.getProduct().getId())) {
                            filteredItems.add(item);
                            total += item.getProduct().getPrice() * item.getQuantity();
                        }
                    }

                    cartItems = filteredItems;
                } else {
                    total = cartService.calculateTotal(userId);
                }

                request.setAttribute("cartItems", cartItems);
                request.setAttribute("totalAmount", total);

                request.getRequestDispatcher("/thanhToan.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp");
        }
    }
}