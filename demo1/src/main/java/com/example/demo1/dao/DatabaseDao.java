package com.example.demo1.dao;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.StatementException;
public class DatabaseDao {
    private static final String HOST = "localhost";
    private static final String PORT = "3306";
    private static final String DATABASE = "webgroup24";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    private static Jdbi jdbi = null;

    public static Jdbi get() {
        if (jdbi == null) {
            try {
                MysqlDataSource ds = new MysqlDataSource();
                String url = "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE
                        + "?useUnicode=true"
                        + "&characterEncoding=UTF-8"
                        + "&useSSL=false"
                        + "&serverTimezone=Asia/Ho_Chi_Minh"
                        + "&allowPublicKeyRetrieval=true";

                ds.setURL(url);
                ds.setUser(DB_USER);
                ds.setPassword(DB_PASSWORD);
                ds.setUseSSL(false);
                ds.setServerTimezone("Asia/Ho_Chi_Minh");
                ds.setAllowPublicKeyRetrieval(true);

                jdbi = Jdbi.create(ds);

                System.out.println("Kết nối JDBI MySQL thành công!");
            } catch (Exception e) {
                System.err.println("Lỗi kết nối JDBI MySQL!");
                e.printStackTrace();
            }
        }
        return jdbi;
    }

    public static void main(String[] args) {
        Jdbi jdbi = DatabaseDao.get();

        if (jdbi != null) {
            try {
                jdbi.withHandle(handle -> {
                    String result = handle.createQuery("SELECT 'Hello JDBI!' as message")
                            .mapTo(String.class)
                            .one();
                    System.out.println("Test query: " + result);
                    return result;
                });

                System.out.println("Test kết nối JDBI thành công!");
            } catch (StatementException e) {
                System.err.println("Lỗi query!");
                e.printStackTrace();
            }
        } else {
            System.out.println("Kết nối JDBI thất bại!");
        }
    }
}
