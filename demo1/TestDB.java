import java.sql.*;

public class TestDB {
    public static void main(String[] args) throws Exception {
        String url = "jdbc:mysql://localhost:3306/webgroup24?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true";
        try (Connection conn = DriverManager.getConnection(url, "root", "")) {
            Statement stmt = conn.createStatement();
            
            // create dummy product and discount
            stmt.executeUpdate("INSERT INTO discounts (id, discount_value, start_time, end_time) VALUES (9999, 50, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(NOW(), INTERVAL 1 DAY)) ON DUPLICATE KEY UPDATE start_time = DATE_SUB(NOW(), INTERVAL 1 DAY)");
            stmt.executeUpdate("INSERT INTO products (id, category_id, brand_id, name, stock, old_price, price, discount_id, status) VALUES (9999, 1, 1, 'TEST', 10, 1000, 500, 9999, 'active') ON DUPLICATE KEY UPDATE discount_id=9999");
            
            ResultSet rs = stmt.executeQuery("SELECT p.old_price, (CASE WHEN d.id IS NOT NULL AND NOW() BETWEEN d.start_time AND d.end_time THEN p.price ELSE p.old_price END) AS calculated_price, d.discount_value, NOW() as current_time_db FROM products p LEFT JOIN discounts d ON p.discount_id = d.id WHERE p.id = 9999");
            if (rs.next()) {
                System.out.println("old_price: " + rs.getDouble("old_price"));
                System.out.println("calculated_price: " + rs.getDouble("calculated_price"));
                System.out.println("discount_value: " + rs.getDouble("discount_value"));
                System.out.println("NOW(): " + rs.getTimestamp("current_time_db"));
            }
            
            // cleanup
            stmt.executeUpdate("DELETE FROM products WHERE id = 9999");
            stmt.executeUpdate("DELETE FROM discounts WHERE id = 9999");
        }
    }
}
